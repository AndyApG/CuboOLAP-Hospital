import os
import pymysql
from dotenv import load_dotenv
from pathlib import Path

load_dotenv(Path(__file__).resolve().parent.parent / ".env")   

def conexion():
    return pymysql.connect(host=os.getenv("DB_HOST", "localhost"), user=os.getenv("DB_USER"),
                           password=os.getenv("DB_PASSWORD"), database=os.getenv("DB_NAME"),
                           charset="utf8mb4", cursorclass=pymysql.cursors.Cursor)
