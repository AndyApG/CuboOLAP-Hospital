"""ETL: CSV -> dimensiones -> hechos. Re-ejecutable (upsert por llave natural)."""
from load_csv_mysql import conexion
from read_csv import leer_datos

def upsert(cur, tabla, cols, filas, actualizar):
    ph = ", ".join(["%s"] * len(cols))
    upd = ", ".join(f"{c}=VALUES({c})" for c in actualizar)
    cur.executemany(f"INSERT INTO {tabla} ({', '.join(cols)}) VALUES ({ph}) "
                    f"ON DUPLICATE KEY UPDATE {upd}", filas)

def main():
    df = leer_datos()
    conn = conexion(); cur = conn.cursor()

    def uniq(cols):  # una fila por llave natural (las dimensiones son pequeñas)
        return [tuple(r) for r in df[cols].drop_duplicates(cols[0]).itertuples(index=False)]

    upsert(cur, "Hospital", ["id_hospital_fuente","hospital","ciudad_hospital","tipo_hospital"],
           uniq(["id_hospital_fuente","hospital","ciudad_hospital","tipo_hospital"]),
           ["hospital","ciudad_hospital","tipo_hospital"])
    upsert(cur, "Paciente", ["id_paciente_fuente","sexo_paciente","grupo_edad","municipio_paciente"],
           uniq(["id_paciente_fuente","sexo_paciente","grupo_edad","municipio_paciente"]),
           ["sexo_paciente","grupo_edad","municipio_paciente"])
    upsert(cur, "Diagnostico", ["id_diagnostico_fuente","diagnostico","categoria_diagnostico"],
           uniq(["id_diagnostico_fuente","diagnostico","categoria_diagnostico"]),
           ["diagnostico","categoria_diagnostico"])
    t = df.drop_duplicates("fecha")
    upsert(cur, "Tiempo", ["fecha","dia","mes","nombre_mes","trimestre","anio"],
           [(r.fecha.date(), r.dia, r.mes, r.nombre_mes, r.trimestre, r.anio) for r in t.itertuples()],
           ["dia","mes","nombre_mes","trimestre","anio"])

    # Mapas llave natural -> llave sustituta
    def mapa(sql): cur.execute(sql); return {k: v for k, v in cur.fetchall()}
    m_h = mapa("SELECT id_hospital_fuente, id_hospital FROM Hospital")
    m_p = mapa("SELECT id_paciente_fuente, id_paciente FROM Paciente")
    m_d = mapa("SELECT id_diagnostico_fuente, id_diagnostico FROM Diagnostico")
    m_t = mapa("SELECT fecha, id_tiempo FROM Tiempo")

    hechos = [(r.id_atencion_fuente, m_p[r.id_paciente_fuente], m_h[r.id_hospital_fuente],
               m_t[r.fecha.date()], m_d[r.id_diagnostico_fuente],
               r.num_consultas, r.tiempo_espera_min, r.costo_atencion)
              for r in df.itertuples()]
    upsert(cur, "Hechos_Atencion",
           ["id_atencion_fuente","id_paciente","id_hospital","id_tiempo","id_diagnostico",
            "num_consultas","tiempo_espera_min","costo_atencion"], hechos,
           ["id_paciente","id_hospital","id_tiempo","id_diagnostico",
            "num_consultas","tiempo_espera_min","costo_atencion"])
    conn.commit()

    for tb in ["Tiempo","Paciente","Hospital","Diagnostico","Hechos_Atencion"]:
        cur.execute(f"SELECT COUNT(*) FROM {tb}"); print(f"{tb:16} {cur.fetchone()[0]:>4} filas")
    conn.close()

if __name__ == "__main__":
    main()
