-- Habilitar el Event Scheduler en MySQL
SET GLOBAL event_scheduler = ON;

-- 1. Evento para actualizar estado de campers a 'Cursando' si están 'Inscritos' y ya pasaron 7 días
CREATE EVENT ActualizarEstadoCampers
ON SCHEDULE EVERY 1 DAY
DO
UPDATE Campers SET estado_actual = 'Cursando' WHERE estado_actual = 'Inscrito' AND DATEDIFF(NOW(), (SELECT MIN(fecha_cambio) FROM HistorialEstadosCampers WHERE documento_camper = Campers.documento_camper)) >= 7;

-- 2. Evento para eliminar registros de asistencia con más de 1 año de antigüedad
CREATE EVENT LimpiarAsistenciaAntigua
ON SCHEDULE EVERY 1 MONTH
DO
DELETE FROM Asistencia WHERE fecha < DATE_SUB(NOW(), INTERVAL 1 YEAR);

-- 3. Evento para verificar campers retirados y actualizar su estado
CREATE EVENT MarcarCampersRetirados
ON SCHEDULE EVERY 1 WEEK
DO
UPDATE Campers SET estado_actual = 'Retirado' WHERE estado_actual = 'Cursando' AND nivel_riesgo = 'Alto';

-- 4. Evento para calcular promedio de notas cada semana
CREATE EVENT CalcularPromedios
ON SCHEDULE EVERY 1 WEEK
DO
UPDATE Evaluaciones SET nota_final = (evaluacion_teorica * 0.4 + evaluacion_practica * 0.4 + trabajos_quizzes * 0.2);

-- 5. Evento para registrar campers graduados automáticamente
CREATE EVENT GraduarCampers
ON SCHEDULE EVERY 1 MONTH
DO
INSERT INTO Egresados (documento_camper, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, id_ruta, fecha_graduacion)
SELECT documento_camper, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, (SELECT id_ruta FROM Grupos WHERE id_grupo = (SELECT id_grupo FROM CampersGrupo WHERE documento_camper = Campers.documento_camper)) AS id_ruta, NOW()
FROM Campers WHERE estado_actual = 'Graduado';

-- 6. Evento para limpiar registros antiguos del historial de estados
CREATE EVENT LimpiarHistorialEstados
ON SCHEDULE EVERY 3 MONTH
DO
DELETE FROM HistorialEstadosCampers WHERE fecha_cambio < DATE_SUB(NOW(), INTERVAL 2 YEAR);

-- 7. Evento para asignar campers automáticamente a grupos disponibles
CREATE EVENT AsignarCampersAGrupos
ON SCHEDULE EVERY 1 WEEK
DO
UPDATE CampersGrupo SET id_grupo = (SELECT id_grupo FROM Grupos WHERE cupos_disponibles > 0 LIMIT 1)
WHERE documento_camper IN (SELECT documento_camper FROM Campers WHERE estado_actual = 'Cursando');

-- 8. Evento para notificar a trainers sobre evaluaciones pendientes
CREATE EVENT NotificarTrainersEvaluaciones
ON SCHEDULE EVERY 1 WEEK
DO
UPDATE Trainers SET id_telefono = id_telefono WHERE documento_trainer IN (SELECT documento_trainer FROM TrainersModulos WHERE id_modulo IN (SELECT id_modulo FROM Evaluaciones WHERE nota_final IS NULL));

-- 9. Evento para cerrar evaluaciones pendientes después de 30 días
CREATE EVENT CerrarEvaluacionesPendientes
ON SCHEDULE EVERY 1 MONTH
DO
UPDATE Evaluaciones SET nota_final = 0 WHERE nota_final IS NULL AND DATEDIFF(NOW(), (SELECT MAX(fecha_cambio) FROM HistorialEstadosCampers WHERE documento_camper = Evaluaciones.documento_camper)) >= 30;

-- 10. Evento para actualizar disponibilidad de grupos
CREATE EVENT ActualizarCuposGrupos
ON SCHEDULE EVERY 1 DAY
DO
UPDATE Grupos SET cupos_disponibles = cupos_disponibles - (SELECT COUNT(*) FROM CampersGrupo WHERE id_grupo = Grupos.id_grupo);

-- 11. Evento para validar áreas de entrenamiento con sobrecupo
CREATE EVENT ValidarCapacidadAreas
ON SCHEDULE EVERY 1 DAY
DO
UPDATE AreasEntrenamiento SET capacidad_maxima = capacidad_maxima WHERE id_area IN (SELECT id_area FROM Asistencia GROUP BY id_area HAVING COUNT(*) > capacidad_maxima);

-- 12. Evento para registrar cambios de estado en el historial
CREATE EVENT RegistrarCambiosEstados
ON SCHEDULE EVERY 1 DAY
DO
INSERT INTO HistorialEstadosCampers (documento_camper, estado_anterior, estado_nuevo, fecha_cambio)
SELECT documento_camper, estado_actual, 'Cursando', NOW() FROM Campers WHERE estado_actual = 'Inscrito';

-- 13. Evento para desactivar campers inactivos después de 1 año
CREATE EVENT DesactivarCampersInactivos
ON SCHEDULE EVERY 1 YEAR
DO
UPDATE Campers SET estado_actual = 'Retirado' WHERE documento_camper NOT IN (SELECT documento_camper FROM Asistencia WHERE fecha >= DATE_SUB(NOW(), INTERVAL 1 YEAR));

-- 14. Evento para actualizar fechas de entrada/salida en asistencia
CREATE EVENT VerificarHorasAsistencia
ON SCHEDULE EVERY 1 DAY
DO
UPDATE Asistencia SET hora_salida = ADDTIME(hora_entrada, '02:00:00') WHERE hora_salida IS NULL;

-- 15. Evento para generar reportes de graduados cada 6 meses
CREATE EVENT GenerarReporteGraduados
ON SCHEDULE EVERY 6 MONTH
DO
SELECT * FROM Egresados INTO OUTFILE '/var/lib/mysql-files/reporte_graduados.csv' FIELDS TERMINATED BY ',';

-- 16. Evento para verificar documentos duplicados en campers
CREATE EVENT VerificarDuplicados
ON SCHEDULE EVERY 1 DAY
DO
DELETE FROM Campers WHERE documento_camper IN (SELECT documento_camper FROM (SELECT documento_camper, COUNT(*) FROM Campers GROUP BY documento_camper HAVING COUNT(*) > 1) AS duplicados);

-- 17. Evento para asignar trainers a módulos automáticamente
CREATE EVENT AsignarTrainersModulos
ON SCHEDULE EVERY 1 WEEK
DO
UPDATE TrainersModulos SET documento_trainer = (SELECT documento_trainer FROM Trainers ORDER BY RAND() LIMIT 1) WHERE id_modulo IN (SELECT id_modulo FROM Modulos);

-- 18. Evento para limpiar datos de prueba después de 6 meses
CREATE EVENT LimpiarDatosPrueba
ON SCHEDULE EVERY 6 MONTH
DO
DELETE FROM Campers WHERE primer_nombre LIKE 'TEST%';

-- 19. Evento para verificar que todos los campers tengan un acudiente asignado
CREATE EVENT VerificarAcudientes
ON SCHEDULE EVERY 1 WEEK
DO
UPDATE Campers SET documento_acudiente = '000000000' WHERE documento_acudiente IS NULL;

-- 20. Evento para validar evaluaciones de campers antes de la graduación
CREATE EVENT ValidarNotasGraduacion
ON SCHEDULE EVERY 1 MONTH
DO
UPDATE Campers SET estado_actual = 'Aprobado' WHERE estado_actual = 'Cursando' AND documento_camper IN (SELECT documento_camper FROM Evaluaciones GROUP BY documento_camper HAVING AVG(nota_final) >= 7.0);
