"""API OLAP: 5 consultas sobre la tabla de hechos, cada una con DRILL DOWN / ROLL UP por 5 jerarquías."""
import os
from decimal import Decimal
from pathlib import Path
import pymysql
from dotenv import load_dotenv
from flask import Flask, jsonify, request

BASE = Path(__file__).resolve().parent.parent
load_dotenv(BASE / ".env")
app = Flask(__name__, static_folder=str(BASE / "ui"), static_url_path="")

# Jerarquías (general -> detalle): (nombre del nivel, columna llave, columna etiqueta)
HIER = {
    "tiempo":      ("Tiempo",      [("Año", "t.anio", "t.anio"), ("Trimestre", "t.trimestre", "t.trimestre"),
                                    ("Mes", "t.mes", "t.nombre_mes"), ("Día", "t.fecha", "t.fecha")]),
    "hospital":    ("Hospital",    [("Tipo", "hs.tipo_hospital", "hs.tipo_hospital"),
                                    ("Ciudad", "hs.ciudad_hospital", "hs.ciudad_hospital"),
                                    ("Hospital", "hs.hospital", "hs.hospital")]),
    "diagnostico": ("Diagnóstico", [("Categoría", "d.categoria_diagnostico", "d.categoria_diagnostico"),
                                    ("Diagnóstico", "d.diagnostico", "d.diagnostico")]),
    "medico":      ("Médico",      [("Especialidad", "m.especialidad", "m.especialidad"),
                                    ("Médico", "m.id_medico_fuente", "CONCAT('Médico ', m.id_medico_fuente)")]),
    "paciente":    ("Paciente",    [("Municipio", "p.municipio_paciente", "p.municipio_paciente"),
                                    ("Grupo de edad", "p.grupo_edad", "p.grupo_edad"),
                                    ("Paciente", "p.id_paciente_fuente", "CONCAT('Paciente ', p.id_paciente_fuente)")]),
}
# Las 5 consultas: (título, expresión de la métrica sobre la tabla de hechos, jerarquía inicial, unidad)
CONSULTAS = {
    1: ("Número de atenciones", "COUNT(*)", "hospital", ""),
    2: ("Tiempo promedio de espera", "ROUND(AVG(h.tiempo_espera_min),1)", "tiempo", "min"),
    3: ("Costo total de atención", "ROUND(SUM(h.costo_atencion),2)", "diagnostico", "$"),
    4: ("Costo promedio por atención", "ROUND(AVG(h.costo_atencion),2)", "medico", "$"),
    5: ("% de atenciones con espera > 45 min", "ROUND(100*AVG(h.tiempo_espera_min>45),1)", "paciente", "%"),
}
FROM = """FROM Hechos_Atencion h JOIN Tiempo t USING (id_tiempo) JOIN Hospital hs USING (id_hospital)
          JOIN Diagnostico d USING (id_diagnostico) JOIN Medico m USING (id_medico) JOIN Paciente p USING (id_paciente)"""

def db():
    return pymysql.connect(host=os.getenv("DB_HOST", "localhost"), user=os.getenv("DB_USER"),
                           password=os.getenv("DB_PASSWORD"), database=os.getenv("DB_NAME"),
                           charset="utf8mb4", cursorclass=pymysql.cursors.DictCursor)

def limpio(r):
    return {c: (float(v) if isinstance(v, Decimal) else str(v) if c.startswith(("k", "etiqueta")) else v) for c, v in r.items()}

def eje(h, vals, i):
    """Un 'eje' = una jerarquía en su nivel actual (nivel = cuántos padres ya fijamos)."""
    niveles = HIER[h][1]; n = len(vals)
    _, key, lab = niveles[n]
    return dict(h=h, n=n, niveles=niveles, vals=vals, grp=[key, lab], sel=f"{key} AS k{i}, {lab} AS etiqueta{i}",
                where=[f"{niveles[j][1]} = %s" for j in range(n)])   # solo columnas de la lista blanca

def partes(txt):
    return [v for v in (txt or "").split("|") if v != ""]

@app.get("/")
def index():
    return app.send_static_file("index.html")

@app.get("/api/meta")
def meta():
    return jsonify(consultas=[dict(id=i, titulo=c[0], hier=c[2], unidad=c[3]) for i, c in CONSULTAS.items()],
                   jerarquias={k: v[0] for k, v in HIER.items()})

@app.get("/api/olap")
def olap():
    q, h, h2 = request.args.get("q", type=int), request.args.get("h", "tiempo"), request.args.get("h2", "")
    if q not in CONSULTAS or h not in HIER or (h2 and (h2 not in HIER or h2 == h)):
        return jsonify(error="consulta o jerarquía inválida"), 400
    ejes = [eje(h, partes(request.args.get("path")), 1)]
    if h2:
        ejes.append(eje(h2, partes(request.args.get("path2")), 2))
    for e in ejes:
        if e["n"] >= len(e["niveles"]):
            return jsonify(error="ya estás en el nivel más detallado"), 400
    metrica = CONSULTAS[q][1]
    sel = ", ".join(e["sel"] for e in ejes)
    grp = ", ".join(c for e in ejes for c in e["grp"])
    where = " AND ".join(w for e in ejes for w in e["where"]) or "1=1"
    params = [v for e in ejes for v in e["vals"]]
    sql = f"SELECT {sel}, {metrica} AS valor, COUNT(*) AS atenciones {FROM} WHERE {where} GROUP BY {grp} ORDER BY {grp}"
    with db() as conn, conn.cursor() as cur:
        cur.execute(sql, params); rows = [limpio(r) for r in cur.fetchall()]
        cur.execute(f"SELECT {metrica} AS valor, COUNT(*) AS atenciones {FROM} WHERE {where}", params)
        total = limpio(cur.fetchone())          # métrica sobre todo el conjunto (correcto aunque sea promedio o %)
    mostrar = " ".join(sql.split())
    for v in params:
        mostrar = mostrar.replace("%s", f"'{v}'", 1)    # solo para mostrar en pantalla; no se ejecuta
    info = [dict(hier=e["h"], nivel=e["niveles"][e["n"]][0], niveles=[x[0] for x in e["niveles"]], n=e["n"],
                 puede_drill=e["n"] + 1 < len(e["niveles"])) for e in ejes]
    return jsonify(q=q, titulo=CONSULTAS[q][0], unidad=CONSULTAS[q][3], ejes=info, rows=rows, total=total, sql=mostrar)

if __name__ == "__main__":
    app.run(debug=True)
