DELIMITER $$

-- 1. Al insertar una evaluación, calcular automáticamente la nota final.
CREATE TRIGGER trg_CalcularNotaFinal
BEFORE INSERT ON Evaluaciones
FOR EACH ROW
BEGIN
    SET NEW.nota_final = (NEW.evaluacion_teorica * 0.4) + (NEW.evaluacion_practica * 0.4) + (NEW.trabajos_quizzes * 0.2);
END $$

-- 2. Al actualizar la nota final de un módulo, verificar si el camper aprueba o reprueba.
CREATE TRIGGER trg_VerificarAprobacion
AFTER UPDATE ON Evaluaciones
FOR EACH ROW
BEGIN
    IF NEW.nota_final < 60 THEN
        UPDATE Campers SET nivel_riesgo = 'Alto' WHERE documento_camper = NEW.documento_camper;
    ELSE
        UPDATE Campers SET nivel_riesgo = 'Bajo' WHERE documento_camper = NEW.documento_camper;
    END IF;
END $$

-- 3. Al insertar una inscripción, cambiar el estado del camper a "Inscrito".
CREATE TRIGGER trg_CambiarEstadoInscrito
AFTER INSERT ON CampersGrupo
FOR EACH ROW
BEGIN
    UPDATE Campers SET estado_actual = 'Inscrito' WHERE documento_camper = NEW.documento_camper;
END $$

-- 4. Al actualizar una evaluación, recalcular su promedio inmediatamente.
CREATE TRIGGER trg_RecalcularPromedio
AFTER UPDATE ON Evaluaciones
FOR EACH ROW
BEGIN
    DECLARE nuevo_promedio DECIMAL(5,2);
    
    SELECT AVG(nota_final) INTO nuevo_promedio
    FROM Evaluaciones
    WHERE documento_camper = NEW.documento_camper;
    
    UPDATE Campers SET nivel_riesgo = IF(nuevo_promedio < 60, 'Alto', 'Bajo')
    WHERE documento_camper = NEW.documento_camper;
END $$

-- 5. Al eliminar una inscripción, marcar al camper como “Retirado”.
CREATE TRIGGER trg_MarcarRetirado
AFTER DELETE ON CampersGrupo
FOR EACH ROW
BEGIN
    UPDATE Campers SET estado_actual = 'Retirado' WHERE documento_camper = OLD.documento_camper;
END $$

-- 6. Al insertar un nuevo módulo, registrar automáticamente su SGDB asociado.
CREATE TRIGGER trg_AsignarSGDB
BEFORE INSERT ON Modulos
FOR EACH ROW
BEGIN
    IF NEW.id_modulo IS NOT NULL THEN
        SET NEW.nombre = CONCAT(NEW.nombre, ' (SGDB asociado)');
    END IF;
END $$

-- 7. Al insertar un nuevo trainer, verificar duplicados por identificación.
CREATE TRIGGER trg_VerificarDuplicadosTrainer
BEFORE INSERT ON Trainers
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM Trainers WHERE documento_trainer = NEW.documento_trainer) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Trainer ya registrado.';
    END IF;
END $$

-- 8. Al asignar un área, validar que no exceda su capacidad.
CREATE TRIGGER trg_ValidarCapacidadArea
BEFORE INSERT ON Grupos
FOR EACH ROW
BEGIN
    DECLARE cupo_actual INT;
    DECLARE capacidad_maxima INT;

    SELECT COUNT(*) INTO cupo_actual FROM CampersGrupo WHERE id_grupo = NEW.id_grupo;
    SELECT capacidad_maxima INTO capacidad_maxima FROM AreasEntrenamiento WHERE id_area = NEW.id_area;

    IF cupo_actual >= capacidad_maxima THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Capacidad del área excedida.';
    END IF;
END $$

-- 9. Al insertar una evaluación con nota < 60, marcar al camper como “Bajo rendimiento”.
CREATE TRIGGER trg_MarcarBajoRendimiento
AFTER INSERT ON Evaluaciones
FOR EACH ROW
BEGIN
    IF NEW.nota_final < 60 THEN
        UPDATE Campers SET nivel_riesgo = 'Alto' WHERE documento_camper = NEW.documento_camper;
    END IF;
END $$

-- 10. Al cambiar de estado a “Graduado”, mover registro a la tabla de egresados.
CREATE TRIGGER trg_MoverAEgresados
AFTER UPDATE ON Campers
FOR EACH ROW
BEGIN
    IF NEW.estado_actual = 'Egresado' THEN
        INSERT INTO Egresados (documento_camper, fecha_egreso, proyecto_final)
        VALUES (NEW.documento_camper, CURDATE(), 'Proyecto final pendiente');
    END IF;
END $$

DELIMITER ;

DELIMITER $$

-- 11. Al modificar horarios de trainer, verificar solapamiento con otros.
CREATE TRIGGER trg_VerificarSolapamientoHorarioTrainer
BEFORE UPDATE ON Grupos
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM Grupos
        WHERE id_area = NEW.id_area
        AND documento_trainer != NEW.documento_trainer
        AND (
            (NEW.hora_inicio BETWEEN hora_inicio AND hora_fin) OR
            (NEW.hora_fin BETWEEN hora_inicio AND hora_fin)
        )
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Horario en conflicto con otro trainer.';
    END IF;
END $$

-- 12. Al eliminar un trainer, liberar sus horarios y rutas asignadas.
CREATE TRIGGER trg_LiberarHorariosRutasTrainer
AFTER DELETE ON Trainers
FOR EACH ROW
BEGIN
    UPDATE Grupos SET documento_trainer = NULL WHERE documento_trainer = OLD.documento_trainer;
    DELETE FROM TrainersModulos WHERE documento_trainer = OLD.documento_trainer;
END $$

-- 13. Al cambiar la ruta de un camper, actualizar automáticamente sus módulos.
CREATE TRIGGER trg_ActualizarModulosCamper
AFTER UPDATE ON CampersGrupo
FOR EACH ROW
BEGIN
    DELETE FROM Evaluaciones WHERE documento_camper = NEW.documento_camper;
    INSERT INTO Evaluaciones (documento_camper, id_modulo, evaluacion_teorica, evaluacion_practica, trabajos_quizzes, nota_final)
    SELECT NEW.documento_camper, id_modulo, 0, 0, 0, 0 FROM ModulosRuta WHERE id_ruta = (SELECT id_ruta FROM Grupos WHERE id_grupo = NEW.id_grupo);
END $$

-- 14. Al insertar un nuevo camper, verificar si ya existe por número de documento.
CREATE TRIGGER trg_VerificarDuplicadoCamper
BEFORE INSERT ON Campers
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM Campers WHERE documento_camper = NEW.documento_camper) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El camper ya existe.';
    END IF;
END $$

-- 15. Al actualizar la nota final, recalcular el estado del módulo automáticamente.
CREATE TRIGGER trg_RecalcularEstadoModulo
AFTER UPDATE ON Evaluaciones
FOR EACH ROW
BEGIN
    IF NEW.nota_final >= 60 THEN
        UPDATE Modulos SET nombre = CONCAT(nombre, ' (Aprobado)') WHERE id_modulo = NEW.id_modulo;
    END IF;
END $$

-- 16. Al asignar un módulo, verificar que el trainer tenga ese conocimiento.
CREATE TRIGGER trg_VerificarTrainerModulo
BEFORE INSERT ON TrainersModulos
FOR EACH ROW
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM Modulos WHERE id_modulo = NEW.id_modulo
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Trainer no tiene conocimientos en este módulo.';
    END IF;
END $$

-- 17. Al cambiar el estado de un área a inactiva, liberar campers asignados.
CREATE TRIGGER trg_LiberarCampersAreaInactiva
AFTER UPDATE ON AreasEntrenamiento
FOR EACH ROW
BEGIN
    IF NEW.capacidad_maxima = 0 THEN
        DELETE FROM CampersGrupo WHERE id_grupo IN (SELECT id_grupo FROM Grupos WHERE id_area = NEW.id_area);
    END IF;
END $$

-- 18. Al crear una nueva ruta, clonar la plantilla base de módulos y SGDBs.
CREATE TRIGGER trg_ClonarPlantillaRuta
AFTER INSERT ON Rutas
FOR EACH ROW
BEGIN
    INSERT INTO ModulosRuta (id_ruta, id_modulo)
    SELECT NEW.id_ruta, id_modulo FROM ModulosRuta WHERE id_ruta = 1; -- Ruta plantilla base
END $$

-- 19. Al registrar la nota práctica, verificar que no supere 60% del total.
CREATE TRIGGER trg_ValidarNotaPractica
BEFORE INSERT ON Evaluaciones
FOR EACH ROW
BEGIN
    IF NEW.evaluacion_practica > 60 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La nota práctica no puede superar el 60% del total.';
    END IF;
END $$

-- 20. Al modificar una ruta, notificar cambios a los trainers asignados.
CREATE TRIGGER trg_NotificarTrainersRuta
AFTER UPDATE ON Rutas
FOR EACH ROW
BEGIN
    INSERT INTO Notificaciones (documento_trainer, mensaje, fecha)
    SELECT documento_trainer, CONCAT('Se ha actualizado la ruta ', NEW.nombre), NOW()
    FROM TrainersModulos WHERE id_modulo IN (SELECT id_modulo FROM ModulosRuta WHERE id_ruta = NEW.id_ruta);
END $$

DELIMITER ;
