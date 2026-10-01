from pathlib import Path
import pandas as pd

DATA = Path(__file__).resolve().parent.parent / "data"
CSV = next(DATA.glob("*atenciones_hospitalarias.csv"))   # tolera acentos/codificación en el nombre
MESES = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto",
         "Septiembre","Octubre","Noviembre","Diciembre"]

def leer_datos():
    df = pd.read_csv(CSV, encoding="utf-8")
    df = df.astype({"id_atencion_fuente": "int64", "id_paciente_fuente": "int64",
                    "id_hospital_fuente": "int64", "id_diagnostico_fuente": "int64",
                    "num_consultas": "int64",
                    "tiempo_espera_min": "float64",   # el CSV trae decimales (16.6)
                    "costo_atencion": "float64"})
    df["fecha"] = pd.to_datetime(df["fecha"], format="%d/%m/%Y", errors="raise")
    df["mes"] = df["fecha"].dt.month
    df["nombre_mes"] = df["mes"].map(lambda m: MESES[m - 1])   # español, sin depender del locale
    df["trimestre"] = df["fecha"].dt.quarter
    df["anio"] = df["fecha"].dt.year
    df["dia"] = df["fecha"].dt.day
    return df
