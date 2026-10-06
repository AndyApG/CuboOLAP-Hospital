USE Hospital_DSS;

-- C1. No. de atenciones, espera y costo por hospital y año   (Hospital x Tiempo)
SELECT t.anio, hs.hospital, COUNT(*) AS total_atenciones,
       ROUND(AVG(h.tiempo_espera_min),1) AS espera_prom_min,
       MIN(h.tiempo_espera_min) AS espera_min, MAX(h.tiempo_espera_min) AS espera_max
FROM Hechos_Atencion h
JOIN Tiempo t ON h.id_tiempo = t.id_tiempo
JOIN Hospital hs ON h.id_hospital = hs.id_hospital
GROUP BY t.anio, hs.hospital ORDER BY t.anio, hs.hospital;

-- C2. Tiempo promedio de espera por trimestre y mes   (Tiempo)  -> drill down año > trimestre > mes
SELECT t.anio, t.trimestre, t.mes, t.nombre_mes, ROUND(AVG(h.tiempo_espera_min),1) AS espera_prom_min
FROM Hechos_Atencion h JOIN Tiempo t ON h.id_tiempo = t.id_tiempo
GROUP BY t.anio, t.trimestre, t.mes, t.nombre_mes ORDER BY t.anio, t.trimestre, t.mes;

-- C3. Costo total por categoría de diagnóstico y tipo de hospital   (Diagnóstico x Hospital)
SELECT d.categoria_diagnostico, hs.tipo_hospital, COUNT(*) AS atenciones,
       ROUND(SUM(h.costo_atencion),2) AS costo_total
FROM Hechos_Atencion h
JOIN Diagnostico d ON h.id_diagnostico = d.id_diagnostico
JOIN Hospital hs ON h.id_hospital = hs.id_hospital
GROUP BY d.categoria_diagnostico, hs.tipo_hospital ORDER BY costo_total DESC;

-- C4. Costo promedio por atención según especialidad médica   (Médico)
SELECT m.especialidad, COUNT(*) AS atenciones, ROUND(AVG(h.costo_atencion),2) AS costo_prom
FROM Hechos_Atencion h JOIN Medico m ON h.id_medico = m.id_medico
GROUP BY m.especialidad ORDER BY costo_prom DESC;

-- C5. Índice: % de atenciones con espera > 45 min por municipio y grupo de edad   (Paciente)
--     WITH ROLLUP = ROLL UP en SQL: agrega subtotales por municipio y el total general
SELECT p.municipio_paciente, p.grupo_edad, COUNT(*) AS atenciones,
       ROUND(100*AVG(h.tiempo_espera_min > 45),1) AS pct_espera_larga
FROM Hechos_Atencion h JOIN Paciente p ON h.id_paciente = p.id_paciente
GROUP BY p.municipio_paciente, p.grupo_edad WITH ROLLUP;
