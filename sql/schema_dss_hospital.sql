-- Data Warehouse Hospital_DSS (modelo estrella)
DROP DATABASE IF EXISTS Hospital_DSS;
CREATE DATABASE Hospital_DSS CHARACTER SET utf8mb4;
USE Hospital_DSS;

-- ===== Dimensiones =====
CREATE TABLE Tiempo (            -- jerarquía: anio > trimestre > mes > dia
    id_tiempo   INT AUTO_INCREMENT PRIMARY KEY,
    fecha       DATE NOT NULL UNIQUE,
    dia         INT NOT NULL,
    mes         INT NOT NULL,            -- 1..12 (antes VARCHAR: no ordenaba bien)
    nombre_mes  VARCHAR(20),
    trimestre   INT NOT NULL,
    anio        INT NOT NULL
);

CREATE TABLE Paciente (
    id_paciente        INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente_fuente INT NOT NULL UNIQUE,
    sexo_paciente      VARCHAR(50),
    grupo_edad         VARCHAR(50),
    municipio_paciente VARCHAR(50)
);

CREATE TABLE Hospital (          -- jerarquía: tipo > ciudad > hospital
    id_hospital        INT AUTO_INCREMENT PRIMARY KEY,
    id_hospital_fuente INT NOT NULL UNIQUE,
    hospital           VARCHAR(80),
    ciudad_hospital    VARCHAR(50),
    tipo_hospital      VARCHAR(50)
);

CREATE TABLE Diagnostico (       -- jerarquía: categoria > diagnostico
    id_diagnostico        INT AUTO_INCREMENT PRIMARY KEY,
    id_diagnostico_fuente INT NOT NULL UNIQUE,
    diagnostico           VARCHAR(80),
    categoria_diagnostico VARCHAR(50)
);

-- ===== Tabla de hechos =====
CREATE TABLE Hechos_Atencion (
    id_hecho           INT AUTO_INCREMENT PRIMARY KEY,
    id_atencion_fuente INT NOT NULL UNIQUE,   -- hace el ETL re-ejecutable sin duplicar
    id_paciente        INT NOT NULL,
    id_hospital        INT NOT NULL,
    id_tiempo          INT NOT NULL,
    id_diagnostico     INT NOT NULL,
    num_consultas      INT,
    tiempo_espera_min  DECIMAL(6,1),          -- antes INT: se truncaban los decimales
    costo_atencion     DECIMAL(10,2),
    FOREIGN KEY (id_paciente)    REFERENCES Paciente(id_paciente),
    FOREIGN KEY (id_hospital)    REFERENCES Hospital(id_hospital),
    FOREIGN KEY (id_tiempo)      REFERENCES Tiempo(id_tiempo),
    FOREIGN KEY (id_diagnostico) REFERENCES Diagnostico(id_diagnostico)
);
