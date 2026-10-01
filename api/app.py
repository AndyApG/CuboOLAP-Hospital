"""API OLAP: un solo endpoint que implementa DRILL DOWN y ROLL UP sobre las jerarquías."""
import os
from decimal import Decimal
from pathlib import Path
import pymysql
from dotenv import load_dotenv
from flask import Flask, jsonify, request

BASE = Path(__file__).resolve().parent.parent
load_dotenv(BASE / ".env")
app = Flask(__name__, static_folder=str(BASE / "ui"), static_url_path="")

# Jerarquías: lista ordenada de niveles (de lo general a lo detallado): (nombre, columna llave, columna etiqueta)
HIER = {
    "tiempo":      [("Año", "t.anio", "t.anio"), ("Trimestre", "t.trimestre", "t.trimestre"),
                    ("Mes", "t.mes", "t.nombre_mes"), ("Día", "t.fecha", "t.fecha")],
    "hospital":    [("Tipo", "hs.tipo_hospital", "hs.tipo_hospital"),
                    ("Ciudad", "hs.ciudad_hospital", "hs.ciudad_hospital"),
                    ("Hospital", "hs.hospital", "hs.hospital")],
    "diagnostico": [("Categoría", "d.categoria_diagnostico", "d.categoria_diagnostico"),
                    ("Diagnóstico", "d.diagnostico", "d.diagnostico")],
}
FROM = """FROM Hechos_Atencion h JOIN Tiempo t USING (id_tiempo)
          JOIN Hospital hs USING (id_hospital) JOIN Diagnostico d USING (id_diagnostico)"""

def db():
    return pymysql.connect(host=os.getenv("DB_HOST", "localhost"), user=os.getenv("DB_USER"),
                           password=os.getenv("DB_PASSWORD"), database=os.getenv("DB_NAME"),
                           charset="utf8mb4", cursorclass=pymysql.cursors.DictCursor)

@app.get("/")
def index():
    return app.send_static_file("index.html")

@app.get("/api/olap")
def olap():
    h = request.args.get("h", "tiempo")
    if h not in HIER:
        return jsonify(error="jerarquía inválida"), 400
    niveles = HIER[h]
    vals = [v for v in request.args.get("path", "").split("|") if v != ""]
    n = len(vals)                       # nivel actual = cuántos padres ya fijamos
    if n >= len(niveles):
        return jsonify(error="ya estás en el nivel más detallado"), 400
    _, key, lab = niveles[n]
    where = " AND ".join(f"{niveles[i][1]} = %s" for i in range(n)) or "1=1"   # solo columnas de la lista blanca
    sql = f"""SELECT {key} AS k, {lab} AS etiqueta, COUNT(*) AS atenciones,
                     ROUND(SUM(h.costo_atencion),2) AS costo_total,
                     ROUND(AVG(h.costo_atencion),2) AS costo_prom,
                     ROUND(AVG(h.tiempo_espera_min),1) AS espera_prom
              {FROM} WHERE {where} GROUP BY {key}, {lab} ORDER BY {key}"""
    with db() as conn, conn.cursor() as cur:
        cur.execute(sql, vals)
        rows = [{c: (float(v) if isinstance(v, Decimal) else str(v) if c in ("k", "etiqueta") else v)
                 for c, v in r.items()} for r in cur.fetchall()]
    return jsonify(hier=h, nivel=niveles[n][0], niveles=[x[0] for x in niveles],
                   n=n, puede_drill=n + 1 < len(niveles), rows=rows)

if __name__ == "__main__":
    app.run(debug=True)
