# CuboOLAP-Hospital
Proyecto que implementa las funciones OLAP en un DW implementado en MySQL Workbench.

## Instalación
Para poder reproducir el proyecto es necesario tener instalado **Python 3.10 o superior**.

Primero crea un entorno virtual en tu computadora para instalar las dependencias necesarias del proyecto:
```bash
python -m venv venv
```
Después, activa el entorno en Windows

```bash
./venv/scripts/activate
```

Instala los requerimientos necesarios

``` bash
 pip install -r requirements.txt
```

Ejecuta el proyecto 
```bash
python api/app.py
```
Al ejecutarse, aparecerá una URL (por ejemplo http://127.0.0.1:5000) que puedes abrir en tu navegador para visualizar el dashboard.
