--campers

-- 1. Obtener todos los campers inscritos actualmente.
SELECT documento_camper, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, estado_actual
FROM Campers
WHERE estado_actual = 'Inscrito';

-- 2. Listar los campers con estado "Aprobado".
SELECT documento_camper, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, estado_actual
FROM Campers
WHERE estado_actual = 'Aprobado';

-- 3. Mostrar los campers que ya están cursando alguna ruta.
SELECT documento_camper, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, estado_actual
FROM Campers
WHERE estado_actual = 'Cursando';

-- 4. Consultar los campers graduados por cada ruta.
SELECT Egresados.id_ruta, Rutas.nombre AS nombre_ruta, COUNT(Egresados.documento_camper) AS total_graduados
FROM Egresados
JOIN Rutas ON Egresados.id_ruta = Rutas.id_ruta
GROUP BY Egresados.id_ruta, Rutas.nombre;

-- 5. Obtener los campers que se encuentran en estado "Expulsado" o "Retirado".
SELECT documento_camper, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, estado_actual
FROM Campers
WHERE estado_actual IN ('Expulsado', 'Retirado');

-- 6. Listar campers con nivel de riesgo “Alto”.
SELECT documento_camper, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, nivel_riesgo
FROM Campers
WHERE nivel_riesgo = 'Alto';

-- 7. Mostrar el total de campers por cada nivel de riesgo.
SELECT nivel_riesgo, COUNT(documento_camper) AS total_campers
FROM Campers
GROUP BY nivel_riesgo;

-- 8. Obtener campers con más de un número telefónico registrado.
SELECT c.documento_camper, c.primer_nombre, c.primer_apellido, COUNT(tc.id_telefono) AS cantidad_telefonos
FROM Campers c
JOIN TelefonosCamper tc ON c.documento_camper = tc.documento_camper
GROUP BY c.documento_camper, c.primer_nombre, c.primer_apellido
HAVING COUNT(tc.id_telefono) > 1;

-- 9. Listar los campers y sus respectivos acudientes y teléfonos.
SELECT c.documento_camper, c.primer_nombre AS nombre_camper, c.primer_apellido AS apellido_camper,
       a.documento_acudiente, a.primer_nombre AS nombre_acudiente, a.primer_apellido AS apellido_acudiente,
       t.numero_telefono
FROM Campers c
LEFT JOIN Acudientes a ON c.documento_acudiente = a.documento_acudiente
LEFT JOIN TelefonosCamper tc ON c.documento_camper = tc.documento_camper
LEFT JOIN Telefonos t ON tc.id_telefono = t.id_telefono;

-- 10. Mostrar campers que aún no han sido asignados a una ruta.
SELECT c.documento_camper, c.primer_nombre, c.segundo_nombre, c.primer_apellido, c.segundo_apellido, c.estado_actual
FROM Campers c
LEFT JOIN CampersGrupo cg ON c.documento_camper = cg.documento_camper
WHERE cg.id_grupo IS NULL;


--Evaluaciones

-- 1. Obtener las notas teóricas, prácticas y quizzes de cada camper por módulo.
SELECT e.documento_camper, c.primer_nombre, c.primer_apellido, 
       e.id_modulo, m.nombre AS nombre_modulo, 
       e.evaluacion_teorica, e.evaluacion_practica, e.trabajos_quizzes
FROM Evaluaciones e
JOIN Campers c ON e.documento_camper = c.documento_camper
JOIN Modulos m ON e.id_modulo = m.id_modulo;

-- 2. Calcular la nota final de cada camper por módulo.
SELECT e.documento_camper, c.primer_nombre, c.primer_apellido, 
       e.id_modulo, m.nombre AS nombre_modulo, 
       (e.evaluacion_teorica * 0.4 + e.evaluacion_practica * 0.4 + e.trabajos_quizzes * 0.2) AS nota_final
FROM Evaluaciones e
JOIN Campers c ON e.documento_camper = c.documento_camper
JOIN Modulos m ON e.id_modulo = m.id_modulo;

-- 3. Mostrar los campers que reprobaron algún módulo (nota < 60).
SELECT e.documento_camper, c.primer_nombre, c.primer_apellido, 
       e.id_modulo, m.nombre AS nombre_modulo, 
       e.nota_final
FROM Evaluaciones e
JOIN Campers c ON e.documento_camper = c.documento_camper
JOIN Modulos m ON e.id_modulo = m.id_modulo
WHERE e.nota_final < 60;

-- 4. Listar los módulos con más campers en bajo rendimiento (nota < 60).
SELECT e.id_modulo, m.nombre AS nombre_modulo, 
       COUNT(e.documento_camper) AS total_reprobados
FROM Evaluaciones e
JOIN Modulos m ON e.id_modulo = m.id_modulo
WHERE e.nota_final < 60
GROUP BY e.id_modulo, m.nombre
ORDER BY total_reprobados DESC;

-- 5. Obtener el promedio de notas finales por cada módulo.
SELECT e.id_modulo, m.nombre AS nombre_modulo, 
       AVG(e.nota_final) AS promedio_nota_final
FROM Evaluaciones e
JOIN Modulos m ON e.id_modulo = m.id_modulo
GROUP BY e.id_modulo, m.nombre;

-- 6. Consultar el rendimiento general por ruta de entrenamiento.
SELECT r.id_ruta, r.nombre AS nombre_ruta, 
       AVG(e.nota_final) AS promedio_rendimiento
FROM Evaluaciones e
JOIN ModulosRuta mr ON e.id_modulo = mr.id_modulo
JOIN Rutas r ON mr.id_ruta = r.id_ruta
GROUP BY r.id_ruta, r.nombre;

-- 7. Mostrar los trainers responsables de campers con bajo rendimiento.
SELECT DISTINCT t.documento_trainer, t.primer_nombre, t.primer_apellido
FROM Trainers t
JOIN Grupos g ON t.documento_trainer = g.documento_trainer
JOIN CampersGrupo cg ON g.id_grupo = cg.id_grupo
JOIN Evaluaciones e ON cg.documento_camper = e.documento_camper
WHERE e.nota_final < 60;

-- 8. Comparar el promedio de rendimiento por trainer.
SELECT t.documento_trainer, t.primer_nombre, t.primer_apellido, 
       AVG(e.nota_final) AS promedio_rendimiento
FROM Trainers t
JOIN Grupos g ON t.documento_trainer = g.documento_trainer
JOIN CampersGrupo cg ON g.id_grupo = cg.id_grupo
JOIN Evaluaciones e ON cg.documento_camper = e.documento_camper
GROUP BY t.documento_trainer, t.primer_nombre, t.primer_apellido
ORDER BY promedio_rendimiento DESC;

-- 9. Listar los mejores 5 campers por nota final en cada ruta.
SELECT r.id_ruta, r.nombre AS nombre_ruta, 
       e.documento_camper, c.primer_nombre, c.primer_apellido, 
       e.nota_final
FROM Evaluaciones e
JOIN Campers c ON e.documento_camper = c.documento_camper
JOIN ModulosRuta mr ON e.id_modulo = mr.id_modulo
JOIN Rutas r ON mr.id_ruta = r.id_ruta
ORDER BY r.id_ruta, e.nota_final DESC
LIMIT 5;

-- 10. Mostrar cuántos campers pasaron cada módulo por ruta.
SELECT r.id_ruta, r.nombre AS nombre_ruta, 
       e.id_modulo, m.nombre AS nombre_modulo, 
       COUNT(e.documento_camper) AS total_aprobados
FROM Evaluaciones e
JOIN Modulos m ON e.id_modulo = m.id_modulo
JOIN ModulosRuta mr ON e.id_modulo = mr.id_modulo
JOIN Rutas r ON mr.id_ruta = r.id_ruta
WHERE e.nota_final >= 60
GROUP BY r.id_ruta, r.nombre, e.id_modulo, m.nombre;


--Rutas y Áreas de Entrenamiento

-- 1. Mostrar todas las rutas de entrenamiento disponibles.
SELECT id_ruta, nombre 
FROM Rutas;

-- 2. Obtener las rutas con su SGDB principal y alternativo.
SELECT id_ruta, nombre, sgdb_principal, sgdb_secundario 
FROM Rutas;

-- 3. Listar los módulos asociados a cada ruta.
SELECT r.id_ruta, r.nombre AS nombre_ruta, 
       m.id_modulo, m.nombre AS nombre_modulo
FROM ModulosRuta mr
JOIN Rutas r ON mr.id_ruta = r.id_ruta
JOIN Modulos m ON mr.id_modulo = m.id_modulo
ORDER BY r.id_ruta, m.id_modulo;

-- 4. Consultar cuántos campers hay en cada ruta.
SELECT r.id_ruta, r.nombre AS nombre_ruta, 
       COUNT(cg.documento_camper) AS total_campers
FROM CampersGrupo cg
JOIN Grupos g ON cg.id_grupo = g.id_grupo
JOIN Rutas r ON g.id_ruta = r.id_ruta
GROUP BY r.id_ruta, r.nombre;

-- 5. Mostrar las áreas de entrenamiento y su capacidad máxima.
SELECT id_area, nombre, capacidad_maxima 
FROM AreasEntrenamiento;

-- 6. Obtener las áreas que están ocupadas al 100%.
SELECT a.id_area, a.nombre, a.capacidad_maxima, COUNT(cg.documento_camper) AS ocupacion_actual
FROM AreasEntrenamiento a
JOIN Grupos g ON a.id_area = g.id_area
JOIN CampersGrupo cg ON g.id_grupo = cg.id_grupo
GROUP BY a.id_area, a.nombre, a.capacidad_maxima
HAVING COUNT(cg.documento_camper) >= a.capacidad_maxima;

-- 7. Verificar la ocupación actual de cada área.
SELECT a.id_area, a.nombre, a.capacidad_maxima, 
       COUNT(cg.documento_camper) AS ocupacion_actual,
       (COUNT(cg.documento_camper) / a.capacidad_maxima) * 100 AS porcentaje_ocupacion
FROM AreasEntrenamiento a
LEFT JOIN Grupos g ON a.id_area = g.id_area
LEFT JOIN CampersGrupo cg ON g.id_grupo = cg.id_grupo
GROUP BY a.id_area, a.nombre, a.capacidad_maxima;

-- 8. Consultar los horarios disponibles por cada área.
SELECT a.id_area, a.nombre AS nombre_area, 
       g.hora_inicio, g.hora_fin
FROM AreasEntrenamiento a
LEFT JOIN Grupos g ON a.id_area = g.id_area
ORDER BY a.id_area, g.hora_inicio;

-- 9. Mostrar las áreas con más campers asignados.
SELECT a.id_area, a.nombre AS nombre_area, 
       COUNT(cg.documento_camper) AS total_campers
FROM AreasEntrenamiento a
JOIN Grupos g ON a.id_area = g.id_area
JOIN CampersGrupo cg ON g.id_grupo = cg.id_grupo
GROUP BY a.id_area, a.nombre
ORDER BY total_campers DESC;

-- 10. Listar las rutas con sus respectivos trainers y áreas asignadas.
SELECT r.id_ruta, r.nombre AS nombre_ruta, 
       t.documento_trainer, t.primer_nombre, t.primer_apellido,
       a.id_area, a.nombre AS nombre_area
FROM Grupos g
JOIN Rutas r ON g.id_ruta = r.id_ruta
JOIN Trainers t ON g.documento_trainer = t.documento_trainer
JOIN AreasEntrenamiento a ON g.id_area = a.id_area
ORDER BY r.id_ruta, t.documento_trainer;

--Trainers
