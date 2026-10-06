# CuboOLAP-Hospital
Data Warehouse hospitalario (modelo estrella de **5 dimensiones**) en MySQL, con ETL en Python y una app web que ejecuta
**5 consultas** con operadores **drill down** y **roll up**.

## Estructura
| Carpeta | Contenido |
|---|---|
| `sql/schema_dss_hospital.sql` | Solo estructura (dimensiones + hechos) |
| `sql/dw_hospital_poblado.sql` | Estructura **y datos** (se carga solo, sin Python) |
| `sql/consultas.sql` | Las 5 consultas SQL de análisis |
| `etl/` | Lee el CSV y puebla dimensiones y hechos |
| `api/app.py` | API Flask (drill down / roll up) + sirve la interfaz |
| `ui/` | Interfaz web |
| `img/modelo_estrella_5dim.png` | Modelo del cubo |

## Instalación (Python 3.10+)
```bash
python -m venv venv
./venv/scripts/activate          # Windows  (Linux/Mac: source venv/bin/activate)
pip install -r requirements.txt
```
Crea un archivo `.env` en la raíz con `DB_HOST`, `DB_USER`, `DB_PASSWORD` y `DB_NAME=Hospital_DSS`.

## Base de datos (elige una opción)
```bash
mysql -u root -p < sql/dw_hospital_poblado.sql      # A) esquema + datos ya cargados
# B) esquema vacío y poblarlo con Python:
mysql -u root -p < sql/schema_dss_hospital.sql
cd etl && python cargar_datos.py                    # es re-ejecutable: no duplica datos
```

## Ejecutar la app
```bash
python api/app.py
```
Abre http://127.0.0.1:5000 . Elige una de las 5 consultas y una dimensión; haz clic en una fila para **drill down**
y usa las migas de pan o **⬆ Roll up** para subir.
Con **Cruzar con** combinas dos dimensiones (p. ej. Hospital × Tiempo) y haces drill down / roll up en cada una por separado. El panel «Ver consulta SQL» muestra el SQL del nivel actual.
