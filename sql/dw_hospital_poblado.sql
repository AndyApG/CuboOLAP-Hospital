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

CREATE TABLE Medico (            -- jerarquía: especialidad > medico
    id_medico        INT AUTO_INCREMENT PRIMARY KEY,
    id_medico_fuente INT NOT NULL UNIQUE,
    especialidad     VARCHAR(50)
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
    id_medico          INT NOT NULL,
    num_consultas      INT,
    tiempo_espera_min  DECIMAL(6,1),          -- antes INT: se truncaban los decimales
    costo_atencion     DECIMAL(10,2),
    FOREIGN KEY (id_paciente)    REFERENCES Paciente(id_paciente),
    FOREIGN KEY (id_hospital)    REFERENCES Hospital(id_hospital),
    FOREIGN KEY (id_tiempo)      REFERENCES Tiempo(id_tiempo),
    FOREIGN KEY (id_diagnostico) REFERENCES Diagnostico(id_diagnostico),
    FOREIGN KEY (id_medico)      REFERENCES Medico(id_medico)
);

-- ===== Datos =====
/*M!999999\- enable the sandbox mode */ 
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (1,'2025-04-25',25,4,'Abril',2,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (2,'2026-07-13',13,7,'Julio',3,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (3,'2026-06-02',2,6,'Junio',2,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (4,'2026-03-06',6,3,'Marzo',1,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (5,'2025-06-13',13,6,'Junio',2,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (6,'2025-04-15',15,4,'Abril',2,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (7,'2025-02-14',14,2,'Febrero',1,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (8,'2026-09-26',26,9,'Septiembre',3,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (9,'2025-10-24',24,10,'Octubre',4,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (10,'2026-01-09',9,1,'Enero',1,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (11,'2025-03-15',15,3,'Marzo',1,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (12,'2026-07-25',25,7,'Julio',3,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (13,'2025-11-20',20,11,'Noviembre',4,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (14,'2025-11-19',19,11,'Noviembre',4,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (15,'2025-05-27',27,5,'Mayo',2,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (16,'2026-08-21',21,8,'Agosto',3,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (17,'2025-02-18',18,2,'Febrero',1,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (18,'2026-09-03',3,9,'Septiembre',3,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (19,'2025-04-28',28,4,'Abril',2,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (20,'2026-04-10',10,4,'Abril',2,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (21,'2025-11-02',2,11,'Noviembre',4,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (22,'2026-06-28',28,6,'Junio',2,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (23,'2025-11-11',11,11,'Noviembre',4,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (24,'2026-05-13',13,5,'Mayo',2,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (25,'2026-07-17',17,7,'Julio',3,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (26,'2026-07-07',7,7,'Julio',3,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (27,'2026-03-25',25,3,'Marzo',1,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (28,'2026-08-26',26,8,'Agosto',3,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (29,'2025-03-02',2,3,'Marzo',1,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (30,'2026-04-30',30,4,'Abril',2,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (31,'2026-03-18',18,3,'Marzo',1,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (32,'2025-04-11',11,4,'Abril',2,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (33,'2026-04-05',5,4,'Abril',2,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (34,'2025-03-19',19,3,'Marzo',1,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (35,'2025-01-16',16,1,'Enero',1,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (36,'2026-02-15',15,2,'Febrero',1,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (37,'2026-04-11',11,4,'Abril',2,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (38,'2025-03-01',1,3,'Marzo',1,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (39,'2026-08-22',22,8,'Agosto',3,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (40,'2025-07-10',10,7,'Julio',3,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (41,'2026-08-07',7,8,'Agosto',3,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (42,'2025-09-02',2,9,'Septiembre',3,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (43,'2025-03-16',16,3,'Marzo',1,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (44,'2025-09-29',29,9,'Septiembre',3,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (45,'2026-07-11',11,7,'Julio',3,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (46,'2025-04-17',17,4,'Abril',2,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (47,'2025-10-16',16,10,'Octubre',4,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (48,'2025-02-15',15,2,'Febrero',1,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (49,'2026-03-29',29,3,'Marzo',1,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (50,'2025-06-02',2,6,'Junio',2,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (51,'2025-02-12',12,2,'Febrero',1,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (52,'2025-04-16',16,4,'Abril',2,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (53,'2025-08-31',31,8,'Agosto',3,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (54,'2025-12-07',7,12,'Diciembre',4,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (55,'2026-01-27',27,1,'Enero',1,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (56,'2025-12-25',25,12,'Diciembre',4,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (57,'2025-12-03',3,12,'Diciembre',4,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (58,'2026-07-04',4,7,'Julio',3,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (59,'2026-03-23',23,3,'Marzo',1,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (60,'2025-07-21',21,7,'Julio',3,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (61,'2025-05-08',8,5,'Mayo',2,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (62,'2025-10-30',30,10,'Octubre',4,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (63,'2025-06-28',28,6,'Junio',2,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (64,'2025-10-21',21,10,'Octubre',4,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (65,'2025-08-07',7,8,'Agosto',3,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (66,'2026-09-27',27,9,'Septiembre',3,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (67,'2025-05-31',31,5,'Mayo',2,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (68,'2026-04-12',12,4,'Abril',2,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (69,'2026-02-14',14,2,'Febrero',1,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (70,'2026-06-15',15,6,'Junio',2,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (71,'2025-05-17',17,5,'Mayo',2,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (72,'2026-09-20',20,9,'Septiembre',3,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (73,'2026-05-02',2,5,'Mayo',2,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (74,'2026-05-12',12,5,'Mayo',2,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (75,'2025-12-10',10,12,'Diciembre',4,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (76,'2025-06-06',6,6,'Junio',2,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (77,'2025-03-05',5,3,'Marzo',1,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (78,'2025-01-21',21,1,'Enero',1,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (79,'2026-02-04',4,2,'Febrero',1,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (80,'2025-10-07',7,10,'Octubre',4,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (81,'2026-02-19',19,2,'Febrero',1,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (82,'2026-02-08',8,2,'Febrero',1,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (83,'2026-04-18',18,4,'Abril',2,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (84,'2025-12-12',12,12,'Diciembre',4,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (85,'2025-02-11',11,2,'Febrero',1,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (86,'2025-06-21',21,6,'Junio',2,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (87,'2025-01-27',27,1,'Enero',1,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (88,'2026-08-30',30,8,'Agosto',3,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (89,'2026-08-03',3,8,'Agosto',3,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (90,'2025-12-16',16,12,'Diciembre',4,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (91,'2026-04-16',16,4,'Abril',2,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (92,'2026-05-11',11,5,'Mayo',2,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (93,'2025-03-30',30,3,'Marzo',1,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (94,'2025-12-11',11,12,'Diciembre',4,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (95,'2025-09-22',22,9,'Septiembre',3,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (96,'2026-06-14',14,6,'Junio',2,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (97,'2025-09-04',4,9,'Septiembre',3,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (98,'2025-08-15',15,8,'Agosto',3,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (99,'2026-07-21',21,7,'Julio',3,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (100,'2025-05-03',3,5,'Mayo',2,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (101,'2026-08-27',27,8,'Agosto',3,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (102,'2026-01-05',5,1,'Enero',1,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (103,'2025-02-25',25,2,'Febrero',1,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (104,'2025-01-13',13,1,'Enero',1,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (105,'2025-02-22',22,2,'Febrero',1,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (106,'2025-03-17',17,3,'Marzo',1,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (107,'2025-11-08',8,11,'Noviembre',4,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (108,'2025-08-20',20,8,'Agosto',3,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (109,'2026-03-16',16,3,'Marzo',1,2026);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (110,'2025-08-01',1,8,'Agosto',3,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (111,'2025-06-10',10,6,'Junio',2,2025);
INSERT INTO `Tiempo` (`id_tiempo`, `fecha`, `dia`, `mes`, `nombre_mes`, `trimestre`, `anio`) VALUES (112,'2025-10-17',17,10,'Octubre',4,2025);
INSERT INTO `Paciente` (`id_paciente`, `id_paciente_fuente`, `sexo_paciente`, `grupo_edad`, `municipio_paciente`) VALUES (1,1,'Femenino','18-30','Puebla');
INSERT INTO `Paciente` (`id_paciente`, `id_paciente_fuente`, `sexo_paciente`, `grupo_edad`, `municipio_paciente`) VALUES (2,2,'Masculino','31-45','Puebla');
INSERT INTO `Paciente` (`id_paciente`, `id_paciente_fuente`, `sexo_paciente`, `grupo_edad`, `municipio_paciente`) VALUES (3,10,'Masculino','31-45','Puebla');
INSERT INTO `Paciente` (`id_paciente`, `id_paciente_fuente`, `sexo_paciente`, `grupo_edad`, `municipio_paciente`) VALUES (4,4,'Masculino','18-30','Atlixco');
INSERT INTO `Paciente` (`id_paciente`, `id_paciente_fuente`, `sexo_paciente`, `grupo_edad`, `municipio_paciente`) VALUES (5,7,'Femenino','31-45','Atlixco');
INSERT INTO `Paciente` (`id_paciente`, `id_paciente_fuente`, `sexo_paciente`, `grupo_edad`, `municipio_paciente`) VALUES (6,8,'Masculino','61+','Puebla');
INSERT INTO `Paciente` (`id_paciente`, `id_paciente_fuente`, `sexo_paciente`, `grupo_edad`, `municipio_paciente`) VALUES (7,6,'Masculino','46-60','Cholula');
INSERT INTO `Paciente` (`id_paciente`, `id_paciente_fuente`, `sexo_paciente`, `grupo_edad`, `municipio_paciente`) VALUES (8,3,'Femenino','46-60','Cholula');
INSERT INTO `Paciente` (`id_paciente`, `id_paciente_fuente`, `sexo_paciente`, `grupo_edad`, `municipio_paciente`) VALUES (9,5,'Femenino','61+','Puebla');
INSERT INTO `Paciente` (`id_paciente`, `id_paciente_fuente`, `sexo_paciente`, `grupo_edad`, `municipio_paciente`) VALUES (10,9,'Femenino','18-30','Cholula');
INSERT INTO `Hospital` (`id_hospital`, `id_hospital_fuente`, `hospital`, `ciudad_hospital`, `tipo_hospital`) VALUES (1,3,'Hospital del Sur','Puebla','Privado');
INSERT INTO `Hospital` (`id_hospital`, `id_hospital_fuente`, `hospital`, `ciudad_hospital`, `tipo_hospital`) VALUES (2,4,'Hospital Atlixco','Atlixco','Público');
INSERT INTO `Hospital` (`id_hospital`, `id_hospital_fuente`, `hospital`, `ciudad_hospital`, `tipo_hospital`) VALUES (3,5,'Hospital San Ángel','Cholula','Privado');
INSERT INTO `Hospital` (`id_hospital`, `id_hospital_fuente`, `hospital`, `ciudad_hospital`, `tipo_hospital`) VALUES (4,1,'Hospital General Puebla','Puebla','Público');
INSERT INTO `Hospital` (`id_hospital`, `id_hospital_fuente`, `hospital`, `ciudad_hospital`, `tipo_hospital`) VALUES (5,2,'Hospital Regional Cholula','Cholula','Público');
INSERT INTO `Diagnostico` (`id_diagnostico`, `id_diagnostico_fuente`, `diagnostico`, `categoria_diagnostico`) VALUES (1,4,'Asma','Respiratoria');
INSERT INTO `Diagnostico` (`id_diagnostico`, `id_diagnostico_fuente`, `diagnostico`, `categoria_diagnostico`) VALUES (2,3,'Neumonía','Respiratoria');
INSERT INTO `Diagnostico` (`id_diagnostico`, `id_diagnostico_fuente`, `diagnostico`, `categoria_diagnostico`) VALUES (3,1,'Hipertensión','Cardiovascular');
INSERT INTO `Diagnostico` (`id_diagnostico`, `id_diagnostico_fuente`, `diagnostico`, `categoria_diagnostico`) VALUES (4,5,'Migraña','Neurológica');
INSERT INTO `Diagnostico` (`id_diagnostico`, `id_diagnostico_fuente`, `diagnostico`, `categoria_diagnostico`) VALUES (5,2,'Diabetes tipo 2','Metabólica');
INSERT INTO `Diagnostico` (`id_diagnostico`, `id_diagnostico_fuente`, `diagnostico`, `categoria_diagnostico`) VALUES (6,7,'COVID-19','Infecciosa');
INSERT INTO `Diagnostico` (`id_diagnostico`, `id_diagnostico_fuente`, `diagnostico`, `categoria_diagnostico`) VALUES (7,6,'Gastritis','Digestiva');
INSERT INTO `Diagnostico` (`id_diagnostico`, `id_diagnostico_fuente`, `diagnostico`, `categoria_diagnostico`) VALUES (8,8,'Obesidad','Metabólica');
INSERT INTO `Medico` (`id_medico`, `id_medico_fuente`, `especialidad`) VALUES (1,6,'Urgencias');
INSERT INTO `Medico` (`id_medico`, `id_medico_fuente`, `especialidad`) VALUES (2,5,'Neumología');
INSERT INTO `Medico` (`id_medico`, `id_medico_fuente`, `especialidad`) VALUES (3,1,'Medicina General');
INSERT INTO `Medico` (`id_medico`, `id_medico_fuente`, `especialidad`) VALUES (4,4,'Neurología');
INSERT INTO `Medico` (`id_medico`, `id_medico_fuente`, `especialidad`) VALUES (5,3,'Pediatría');
INSERT INTO `Medico` (`id_medico`, `id_medico_fuente`, `especialidad`) VALUES (6,7,'Endocrinología');
INSERT INTO `Medico` (`id_medico`, `id_medico_fuente`, `especialidad`) VALUES (7,2,'Cardiología');
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (1,1,1,1,1,1,1,1,20.0,2325.65);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (2,2,2,2,2,2,2,1,16.6,784.23);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (3,3,3,3,3,3,3,1,35.1,2513.05);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (4,4,4,3,4,4,4,1,38.3,914.95);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (5,5,5,1,5,5,5,1,17.5,2656.04);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (6,6,2,4,6,4,4,1,61.6,1284.84);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (7,7,6,4,7,1,2,1,19.3,881.13);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (8,8,7,5,8,6,2,1,18.8,1359.64);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (9,9,2,5,9,5,6,1,35.9,1089.43);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (10,10,8,1,10,5,5,1,33.5,2514.19);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (11,11,3,5,11,1,1,1,17.4,1683.02);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (12,12,4,1,12,2,1,1,20.3,1057.78);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (13,13,5,4,13,5,5,1,65.2,1237.33);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (14,14,4,2,14,7,1,1,49.8,2157.13);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (15,15,9,5,15,3,7,1,56.1,1056.96);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (16,16,5,5,16,5,5,1,43.0,618.18);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (17,17,2,5,17,3,7,1,47.8,1000.20);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (18,18,6,1,18,6,2,1,40.1,926.41);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (19,19,10,1,19,8,6,1,13.9,1899.96);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (20,20,1,1,20,1,1,1,32.8,1191.54);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (21,21,10,5,21,2,2,1,35.6,710.01);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (22,22,1,1,22,1,2,1,10.7,3036.93);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (23,23,4,5,23,8,3,1,67.1,611.35);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (24,24,2,3,24,5,6,1,14.5,1993.15);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (25,25,8,3,25,1,5,1,24.8,1387.14);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (26,26,4,1,26,7,1,1,54.8,2169.78);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (27,27,10,4,27,4,4,1,27.4,939.51);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (28,28,10,3,28,3,7,1,10.3,2528.03);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (29,29,4,4,29,7,3,1,18.9,809.41);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (30,30,4,5,24,6,2,1,66.5,1242.36);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (31,31,4,2,30,8,6,1,25.5,626.01);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (32,32,7,2,31,4,4,1,62.5,570.42);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (33,33,1,1,32,4,4,1,18.7,1337.48);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (34,34,8,5,33,4,4,1,40.4,1636.83);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (35,35,6,3,34,5,6,1,11.8,3198.35);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (36,36,2,5,35,5,6,1,37.4,1125.77);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (37,37,1,2,36,3,7,1,69.2,844.76);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (38,38,9,3,37,4,4,1,15.4,1582.43);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (39,39,3,3,38,2,1,1,43.7,1102.90);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (40,40,6,3,39,2,2,1,12.0,2068.01);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (41,41,2,4,40,6,2,1,62.4,1024.91);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (42,42,4,3,41,2,2,1,31.7,1864.22);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (43,43,3,1,16,1,2,1,17.1,2547.24);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (44,44,9,5,42,4,4,1,40.1,1707.72);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (45,45,1,3,43,4,4,1,12.6,1390.25);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (46,46,8,4,44,5,5,1,35.3,705.07);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (47,47,9,3,45,2,2,1,33.4,2175.59);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (48,48,8,4,46,5,5,1,55.8,702.08);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (49,49,3,1,47,3,7,1,34.1,2861.70);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (50,50,6,4,3,5,5,1,49.9,1578.15);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (51,51,1,5,48,1,5,1,68.9,710.06);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (52,52,10,2,49,2,1,1,15.0,2701.09);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (53,53,10,1,50,8,3,1,29.3,1888.51);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (54,54,9,4,51,2,5,1,26.6,824.39);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (55,55,7,3,52,8,6,1,44.1,2623.80);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (56,56,8,5,53,8,6,1,16.4,1457.53);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (57,57,5,5,54,8,6,1,23.8,1411.66);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (58,58,1,2,55,5,6,1,26.0,1693.99);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (59,59,9,5,56,5,6,1,16.3,751.07);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (60,60,9,4,57,8,6,1,34.3,1162.23);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (61,61,7,4,58,7,3,1,24.8,1751.29);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (62,62,1,3,44,7,3,1,22.1,2708.78);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (63,63,3,4,59,1,2,1,64.5,747.10);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (64,64,5,3,48,8,3,1,34.0,3062.61);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (65,65,7,4,60,4,4,1,49.3,1362.40);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (66,66,9,1,61,6,2,1,24.3,1825.52);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (67,67,10,5,62,3,7,1,51.6,992.89);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (68,68,3,1,63,1,2,1,29.2,900.93);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (69,69,4,3,64,4,4,1,26.3,1916.97);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (70,70,10,5,65,4,4,1,30.6,1363.01);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (71,71,7,5,66,8,3,1,32.1,1548.53);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (72,72,1,5,67,7,3,1,48.6,1499.04);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (73,73,5,3,68,1,1,1,42.3,1691.16);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (74,74,4,4,69,3,7,1,57.8,784.49);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (75,75,6,3,70,3,3,1,42.1,1179.12);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (76,76,6,3,71,6,1,1,52.8,2604.57);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (77,77,10,3,72,4,4,1,41.4,2610.41);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (78,78,6,5,73,1,5,1,30.3,1510.98);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (79,79,4,2,74,5,5,1,54.2,804.84);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (80,80,7,4,75,2,2,1,23.3,997.95);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (81,81,4,2,76,7,3,1,33.2,1105.70);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (82,82,4,2,77,8,6,1,64.8,1259.30);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (83,83,3,2,78,4,4,1,66.9,888.20);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (84,84,5,3,79,6,2,1,41.4,2022.93);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (85,85,5,4,80,4,4,1,33.5,1382.88);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (86,86,8,2,81,5,6,1,68.9,1194.36);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (87,87,3,4,82,2,2,1,50.4,676.41);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (88,88,8,1,83,7,3,1,21.5,1945.81);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (89,89,5,2,84,2,5,1,60.9,1111.40);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (90,90,1,5,26,1,5,1,18.8,1744.47);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (91,91,1,5,85,3,7,1,49.2,810.11);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (92,92,2,5,30,1,2,1,53.5,1496.97);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (93,93,3,4,86,2,2,1,68.1,640.53);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (94,94,9,2,87,1,2,1,66.8,757.83);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (95,95,4,1,88,8,3,1,31.0,1178.43);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (96,96,1,3,89,2,5,1,33.2,1058.60);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (97,97,1,2,90,8,6,1,20.8,1749.02);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (98,98,8,5,91,4,4,1,48.9,1695.50);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (99,99,6,3,92,4,4,1,21.3,1464.64);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (100,100,9,5,93,4,4,1,46.3,1368.65);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (101,101,1,1,94,4,4,1,27.1,1716.10);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (102,102,7,3,95,1,5,1,40.8,2178.32);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (103,103,4,5,96,8,3,1,37.4,1221.73);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (104,104,6,2,97,7,1,1,45.7,1167.50);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (105,105,5,5,98,6,1,1,39.9,1664.24);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (106,106,10,2,99,1,5,1,45.3,957.35);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (107,107,9,1,20,5,5,1,14.2,1342.94);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (108,108,10,5,100,5,6,1,26.9,1129.46);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (109,109,10,1,101,2,2,1,39.1,1581.37);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (110,110,8,4,102,1,5,1,44.4,856.60);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (111,111,10,5,103,1,5,1,62.8,1138.14);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (112,112,3,2,104,2,5,1,39.2,739.67);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (113,113,9,2,105,5,6,1,60.2,1020.92);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (114,114,3,4,106,1,1,1,16.7,2013.11);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (115,115,2,4,107,3,7,1,48.3,1527.96);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (116,116,10,2,108,4,4,1,31.4,1265.08);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (117,117,9,3,109,2,2,1,31.3,2602.21);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (118,118,4,4,110,5,5,1,28.2,1217.59);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (119,119,1,2,111,4,4,1,31.0,800.92);
INSERT INTO `Hechos_Atencion` (`id_hecho`, `id_atencion_fuente`, `id_paciente`, `id_hospital`, `id_tiempo`, `id_diagnostico`, `id_medico`, `num_consultas`, `tiempo_espera_min`, `costo_atencion`) VALUES (120,120,6,5,112,7,3,1,58.3,1312.58);
