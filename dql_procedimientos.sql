-- 1. Registrar un nuevo camper con toda su información personal y estado inicial.
DELIMITER $$
CREATE PROCEDURE RegistrarNuevoCamper(
    IN p_documento VARCHAR(12),
    IN p_primer_nombre VARCHAR(50),
    IN p_segundo_nombre VARCHAR(50),
    IN p_primer_apellido VARCHAR(50),
    IN p_segundo_apellido VARCHAR(50),
    IN p_id_tipo_documento DECIMAL(4,0),
    IN p_id_direccion INTEGER,
    IN p_documento_acudiente VARCHAR(12),
    IN p_estado_actual VARCHAR(50),
    IN p_nivel_riesgo VARCHAR(50)
)
BEGIN
    INSERT INTO Campers (documento_camper, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, id_tipo_documento, id_direccion, documento_acudiente, estado_actual, nivel_riesgo)
    VALUES (p_documento, p_primer_nombre, p_segundo_nombre, p_primer_apellido, p_segundo_apellido, p_id_tipo_documento, p_id_direccion, p_documento_acudiente, p_estado_actual, p_nivel_riesgo);
END $$
DELIMITER ;

-- 2. Actualizar el estado de un camper luego de completar el proceso de ingreso.
DELIMITER $$
CREATE PROCEDURE ActualizarEstadoCamper(
    IN p_documento VARCHAR(12),
    IN p_nuevo_estado VARCHAR(50)
)
BEGIN
    UPDATE Campers
    SET estado_actual = p_nuevo_estado
    WHERE documento_camper = p_documento;
END $$
DELIMITER ;

-- 3. Procesar la inscripción de un camper a una ruta específica.
DELIMITER $$
CREATE PROCEDURE InscribirCamperRuta(
    IN p_documento_camper VARCHAR(12),
    IN p_id_ruta DECIMAL(3,0)
)
BEGIN
    INSERT INTO CampersGrupo (id_grupo, documento_camper)
    SELECT g.id_grupo, p_documento_camper
    FROM Grupos g
    WHERE g.id_ruta = p_id_ruta AND g.cupos_disponibles > 0
    LIMIT 1;
    
    UPDATE Grupos
    SET cupos_disponibles = cupos_disponibles - 1
    WHERE id_grupo = (SELECT id_grupo FROM CampersGrupo WHERE documento_camper = p_documento_camper LIMIT 1);
END $$
DELIMITER ;

-- 4. Registrar una evaluación completa (teórica, práctica y quizzes) para un camper.
DELIMITER $$
CREATE PROCEDURE RegistrarEvaluacion(
    IN p_documento_camper VARCHAR(12),
    IN p_id_modulo DECIMAL(5,0),
    IN p_evaluacion_teorica DECIMAL(5,2),
    IN p_evaluacion_practica DECIMAL(5,2),
    IN p_trabajos_quizzes DECIMAL(5,2)
)
BEGIN
    INSERT INTO Evaluaciones (documento_camper, id_modulo, evaluacion_teorica, evaluacion_practica, trabajos_quizzes, nota_final)
    VALUES (p_documento_camper, p_id_modulo, p_evaluacion_teorica, p_evaluacion_practica, p_trabajos_quizzes,
            (p_evaluacion_teorica * 0.4 + p_evaluacion_practica * 0.4 + p_trabajos_quizzes * 0.2));
END $$
DELIMITER ;

-- 5. Calcular y registrar automáticamente la nota final de un módulo.
DELIMITER $$
CREATE PROCEDURE CalcularNotaFinal(
    IN p_documento_camper VARCHAR(12),
    IN p_id_modulo DECIMAL(5,0)
)
BEGIN
    UPDATE Evaluaciones
    SET nota_final = (evaluacion_teorica * 0.4 + evaluacion_practica * 0.4 + trabajos_quizzes * 0.2)
    WHERE documento_camper = p_documento_camper AND id_modulo = p_id_modulo;
END $$
DELIMITER ;

-- 6. Asignar campers aprobados a una ruta de acuerdo con la disponibilidad del área.
DELIMITER $$
CREATE PROCEDURE AsignarCamperARuta(
    IN p_documento_camper VARCHAR(12)
)
BEGIN
    DECLARE v_id_ruta DECIMAL(3,0);
    
    SELECT id_ruta INTO v_id_ruta
    FROM Rutas
    WHERE id_ruta NOT IN (
        SELECT id_ruta FROM CampersGrupo WHERE documento_camper = p_documento_camper
    )
    LIMIT 1;
    
    IF v_id_ruta IS NOT NULL THEN
        INSERT INTO CampersGrupo (id_grupo, documento_camper)
        SELECT g.id_grupo, p_documento_camper
        FROM Grupos g
        WHERE g.id_ruta = v_id_ruta AND g.cupos_disponibles > 0
        LIMIT 1;
        
        UPDATE Grupos
        SET cupos_disponibles = cupos_disponibles - 1
        WHERE id_grupo = (SELECT id_grupo FROM CampersGrupo WHERE documento_camper = p_documento_camper LIMIT 1);
    END IF;
END $$
DELIMITER ;

-- 7. Asignar un trainer a una ruta y área específica, validando el horario.
DELIMITER $$
CREATE PROCEDURE AsignarTrainer(
    IN p_documento_trainer VARCHAR(12),
    IN p_id_ruta DECIMAL(3,0),
    IN p_id_area DECIMAL(3,0),
    IN p_hora_inicio TIME,
    IN p_hora_fin TIME
)
BEGIN
    INSERT INTO Grupos (documento_trainer, id_ruta, id_area, hora_inicio, hora_fin, cupos_disponibles)
    VALUES (p_documento_trainer, p_id_ruta, p_id_area, p_hora_inicio, p_hora_fin, 10);
END $$
DELIMITER ;

-- 8. Registrar una nueva ruta con sus módulos y SGDB asociados.
DELIMITER $$
CREATE PROCEDURE RegistrarRuta(
    IN p_id_ruta DECIMAL(3,0),
    IN p_nombre VARCHAR(100),
    IN p_sgdb_principal VARCHAR(100),
    IN p_sgdb_secundario VARCHAR(100)
)
BEGIN
    INSERT INTO Rutas (id_ruta, nombre, sgdb_principal, sgdb_secundario)
    VALUES (p_id_ruta, p_nombre, p_sgdb_principal, p_sgdb_secundario);
END $$
DELIMITER ;

-- 9. Registrar una nueva área de entrenamiento con su capacidad y horarios.
DELIMITER $$

CREATE PROCEDURE RegistrarAreaEntrenamiento(
    IN p_id_area DECIMAL(3,0),
    IN p_nombre VARCHAR(80),
    IN p_capacidad_maxima DECIMAL(2,0)
)
BEGIN
    INSERT INTO AreasEntrenamiento (id_area, nombre, capacidad_maxima)
    VALUES (p_id_area, p_nombre, p_capacidad_maxima);
END $$

DELIMITER ;

-- 10. Consultar disponibilidad de horario en un área determinada.
DELIMITER $$

CREATE PROCEDURE ConsultarDisponibilidadArea(
    IN p_id_area DECIMAL(3,0),
    IN p_fecha DATE
)
BEGIN
    SELECT 
        a.id_area, 
        a.nombre, 
        g.hora_inicio, 
        g.hora_fin, 
        COUNT(cg.documento_camper) AS campers_asignados, 
        a.capacidad_maxima - COUNT(cg.documento_camper) AS cupos_disponibles
    FROM AreasEntrenamiento a
    LEFT JOIN Grupos g ON a.id_area = g.id_area
    LEFT JOIN CampersGrupo cg ON g.id_grupo = cg.id_grupo
    WHERE a.id_area = p_id_area
    GROUP BY a.id_area, a.nombre, g.hora_inicio, g.hora_fin, a.capacidad_maxima;
END $$

DELIMITER ;

-- PROCEDIMIENTO 11: Reasignar a un camper a otra ruta en caso de bajo rendimiento
DELIMITER //
CREATE PROCEDURE ReasignarCamper(
    IN p_documento_camper VARCHAR(12),
    IN p_nueva_ruta DECIMAL(3,0)
)
BEGIN
    DECLARE v_estado_actual VARCHAR(50);
    
    -- Verificar si el camper está en bajo rendimiento
    SELECT estado_actual INTO v_estado_actual
    FROM Campers
    WHERE documento_camper = p_documento_camper;
    
    IF v_estado_actual = 'Bajo Rendimiento' THEN
        -- Actualizar la ruta del camper
        UPDATE CampersGrupo
        SET id_grupo = (
            SELECT id_grupo FROM Grupos WHERE id_ruta = p_nueva_ruta LIMIT 1
        )
        WHERE documento_camper = p_documento_camper;
    END IF;
END //
DELIMITER ;

-- PROCEDIMIENTO 12: Cambiar el estado de un camper a “Graduado” al finalizar todos los módulos
DELIMITER //
CREATE PROCEDURE GraduarCamper(
    IN p_documento_camper VARCHAR(12)
)
BEGIN
    DECLARE v_total_modulos INT;
    DECLARE v_modulos_aprobados INT;
    
    -- Contar total de módulos de la ruta
    SELECT COUNT(*) INTO v_total_modulos
    FROM ModulosRuta
    WHERE id_ruta = (
        SELECT id_ruta FROM CampersGrupo WHERE documento_camper = p_documento_camper
    );
    
    -- Contar módulos aprobados por el camper
    SELECT COUNT(*) INTO v_modulos_aprobados
    FROM Evaluaciones
    WHERE documento_camper = p_documento_camper AND nota_final >= 60;
    
    -- Si ha aprobado todos, cambiar estado a graduado
    IF v_total_modulos = v_modulos_aprobados THEN
        UPDATE Campers
        SET estado_actual = 'Graduado'
        WHERE documento_camper = p_documento_camper;
    END IF;
END //
DELIMITER ;

-- PROCEDIMIENTO 13: Consultar y exportar todos los datos de rendimiento de un camper
DELIMITER //
CREATE PROCEDURE ConsultarRendimientoCamper(
    IN p_documento_camper VARCHAR(12)
)
BEGIN
    SELECT e.id_evaluacion, m.nombre AS modulo, e.evaluacion_teorica, e.evaluacion_practica, e.trabajos_quizzes, e.nota_final
    FROM Evaluaciones e
    JOIN Modulos m ON e.id_modulo = m.id_modulo
    WHERE e.documento_camper = p_documento_camper;
END //
DELIMITER ;

-- PROCEDIMIENTO 14: Registrar la asistencia a clases por área y horario
DELIMITER //
CREATE PROCEDURE RegistrarAsistencia(
    IN p_documento_camper VARCHAR(12),
    IN p_id_area DECIMAL(3,0),
    IN p_fecha DATE,
    IN p_hora_entrada TIME,
    IN p_hora_salida TIME
)
BEGIN
    INSERT INTO Asistencia (documento_camper, id_area, fecha, hora_entrada, hora_salida)
    VALUES (p_documento_camper, p_id_area, p_fecha, p_hora_entrada, p_hora_salida);
END //
DELIMITER ;

-- PROCEDIMIENTO 15: Generar reporte mensual de notas por ruta
DELIMITER //
CREATE PROCEDURE ReporteMensualNotas(
    IN p_mes INT, IN p_anio INT
)
BEGIN
    SELECT r.nombre AS ruta, m.nombre AS modulo, c.documento_camper, c.primer_nombre, c.primer_apellido,
           e.evaluacion_teorica, e.evaluacion_practica, e.trabajos_quizzes, e.nota_final
    FROM Evaluaciones e
    JOIN Campers c ON e.documento_camper = c.documento_camper
    JOIN Modulos m ON e.id_modulo = m.id_modulo
    JOIN ModulosRuta mr ON m.id_modulo = mr.id_modulo
    JOIN Rutas r ON mr.id_ruta = r.id_ruta
    WHERE MONTH(e.fecha) = p_mes AND YEAR(e.fecha) = p_anio;
END //
DELIMITER ;

-- PROCEDIMIENTO 16: Validar y registrar la asignación de un salón a una ruta sin exceder la capacidad
DELIMITER //
CREATE PROCEDURE AsignarSalonRuta(
    IN p_id_area DECIMAL(3,0),
    IN p_id_ruta DECIMAL(3,0)
)
BEGIN
    DECLARE v_capacidad_max DECIMAL(2,0);
    DECLARE v_cupos_usados DECIMAL(2,0);
    
    -- Obtener la capacidad del área
    SELECT capacidad_maxima INTO v_capacidad_max FROM AreasEntrenamiento WHERE id_area = p_id_area;
    
    -- Obtener el número de campers asignados
    SELECT COUNT(*) INTO v_cupos_usados FROM CampersGrupo cg
    JOIN Grupos g ON cg.id_grupo = g.id_grupo
    WHERE g.id_ruta = p_id_ruta AND g.id_area = p_id_area;
    
    -- Validar si hay espacio disponible
    IF v_cupos_usados < v_capacidad_max THEN
        UPDATE Grupos SET id_area = p_id_area WHERE id_ruta = p_id_ruta;
    END IF;
END //
DELIMITER ;

-- PROCEDIMIENTO 17: Registrar cambio de horario de un trainer
DELIMITER //
CREATE PROCEDURE CambiarHorarioTrainer(
    IN p_documento_trainer VARCHAR(12),
    IN p_hora_inicio TIME,
    IN p_hora_fin TIME
)
BEGIN
    UPDATE Grupos
    SET hora_inicio = p_hora_inicio, hora_fin = p_hora_fin
    WHERE documento_trainer = p_documento_trainer;
END //
DELIMITER ;

-- PROCEDIMIENTO 18: Eliminar la inscripción de un camper a una ruta (en caso de retiro)
DELIMITER //
CREATE PROCEDURE EliminarInscripcion(
    IN p_documento_camper VARCHAR(12)
)
BEGIN
    DELETE FROM CampersGrupo WHERE documento_camper = p_documento_camper;
END //
DELIMITER ;

-- PROCEDIMIENTO 19: Recalcular el estado de todos los campers según su rendimiento acumulado
DELIMITER //
CREATE PROCEDURE RecalcularEstadoCampers()
BEGIN
    UPDATE Campers c
    SET c.estado_actual = (
        CASE 
            WHEN (SELECT AVG(e.nota_final) FROM Evaluaciones e WHERE e.documento_camper = c.documento_camper) >= 60 THEN 'Aprobado'
            ELSE 'Bajo Rendimiento'
        END
    );
END //
DELIMITER ;

-- PROCEDIMIENTO 20: Asignar horarios automáticamente a trainers disponibles según sus áreas
DELIMITER //
CREATE PROCEDURE AsignarHorariosTrainers()
BEGIN
    UPDATE Grupos g
    JOIN Trainers t ON g.documento_trainer = t.documento_trainer
    SET g.hora_inicio = '08:00:00', g.hora_fin = '12:00:00'
    WHERE g.hora_inicio IS NULL;
END //
DELIMITER ;
