-- 1. Calcular el promedio ponderado de evaluaciones de un camper.
DELIMITER $$

CREATE FUNCTION CalcularPromedioPonderado(documento_camper VARCHAR(12), id_modulo DECIMAL(5,0)) 
RETURNS DECIMAL(5,2) DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);

    SELECT (evaluacion_teorica * 0.3 + evaluacion_practica * 0.5 + trabajos_quizzes * 0.2)
    INTO promedio
    FROM Evaluaciones
    WHERE documento_camper = documento_camper AND id_modulo = id_modulo;

    RETURN promedio;
END $$

DELIMITER ;

-- 2. Determinar si un camper aprueba o no un módulo específico.
DELIMITER $$

CREATE FUNCTION CamperApruebaModulo(documento_camper VARCHAR(12), id_modulo DECIMAL(5,0)) 
RETURNS BOOLEAN DETERMINISTIC
BEGIN
    DECLARE nota_final DECIMAL(5,2);
    
    SELECT nota_final INTO nota_final
    FROM Evaluaciones
    WHERE documento_camper = documento_camper AND id_modulo = id_modulo;

    RETURN nota_final >= 60;
END $$

DELIMITER ;

-- 3. Evaluar el nivel de riesgo de un camper según su rendimiento promedio.
DELIMITER $$

CREATE FUNCTION EvaluarNivelRiesgo(documento_camper VARCHAR(12)) 
RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);
    
    SELECT AVG(nota_final) INTO promedio
    FROM Evaluaciones
    WHERE documento_camper = documento_camper;

    IF promedio >= 80 THEN
        RETURN 'Alto';
    ELSEIF promedio >= 60 THEN
        RETURN 'Medio';
    ELSE
        RETURN 'Bajo';
    END IF;
END $$

DELIMITER ;

-- 4. Obtener el total de campers asignados a una ruta específica.
DELIMITER $$

CREATE FUNCTION TotalCampersRuta(id_ruta DECIMAL(3,0)) 
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(*) INTO total
    FROM CampersGrupo cg
    JOIN Grupos g ON cg.id_grupo = g.id_grupo
    WHERE g.id_ruta = id_ruta;

    RETURN total;
END $$

DELIMITER ;

-- 5. Consultar la cantidad de módulos que ha aprobado un camper.
DELIMITER $$

CREATE FUNCTION ModulosAprobadosCamper(documento_camper VARCHAR(12)) 
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE cantidad INT;

    SELECT COUNT(*) INTO cantidad
    FROM Evaluaciones
    WHERE documento_camper = documento_camper AND nota_final >= 60;

    RETURN cantidad;
END $$

DELIMITER ;

-- 6. Validar si hay cupos disponibles en una determinada área.
DELIMITER $$

CREATE FUNCTION HayCuposDisponibles(id_area DECIMAL(3,0)) 
RETURNS BOOLEAN DETERMINISTIC
BEGIN
    DECLARE cupos_disponibles INT;

    SELECT (capacidad_maxima - COUNT(cg.documento_camper)) INTO cupos_disponibles
    FROM AreasEntrenamiento a
    LEFT JOIN Grupos g ON a.id_area = g.id_area
    LEFT JOIN CampersGrupo cg ON g.id_grupo = cg.id_grupo
    WHERE a.id_area = id_area
    GROUP BY a.capacidad_maxima;

    RETURN cupos_disponibles > 0;
END $$

DELIMITER ;

-- 7. Calcular el porcentaje de ocupación de un área de entrenamiento.
DELIMITER $$

CREATE FUNCTION PorcentajeOcupacionArea(id_area DECIMAL(3,0)) 
RETURNS DECIMAL(5,2) DETERMINISTIC
BEGIN
    DECLARE ocupacion DECIMAL(5,2);

    SELECT (COUNT(cg.documento_camper) / capacidad_maxima) * 100 INTO ocupacion
    FROM AreasEntrenamiento a
    LEFT JOIN Grupos g ON a.id_area = g.id_area
    LEFT JOIN CampersGrupo cg ON g.id_grupo = cg.id_grupo
    WHERE a.id_area = id_area
    GROUP BY a.capacidad_maxima;

    RETURN IFNULL(ocupacion, 0);
END $$

DELIMITER ;

-- 8. Determinar la nota más alta obtenida en un módulo.
DELIMITER $$

CREATE FUNCTION NotaMasAltaModulo(id_modulo DECIMAL(5,0)) 
RETURNS DECIMAL(5,2) DETERMINISTIC
BEGIN
    DECLARE max_nota DECIMAL(5,2);

    SELECT MAX(nota_final) INTO max_nota
    FROM Evaluaciones
    WHERE id_modulo = id_modulo;

    RETURN IFNULL(max_nota, 0);
END $$

DELIMITER ;

-- 9. Calcular la tasa de aprobación de una ruta.
DELIMITER $$

CREATE FUNCTION TasaAprobacionRuta(id_ruta DECIMAL(3,0)) 
RETURNS DECIMAL(5,2) DETERMINISTIC
BEGIN
    DECLARE aprobados INT;
    DECLARE total INT;

    SELECT COUNT(*) INTO aprobados
    FROM Evaluaciones e
    JOIN CampersGrupo cg ON e.documento_camper = cg.documento_camper
    JOIN Grupos g ON cg.id_grupo = g.id_grupo
    WHERE g.id_ruta = id_ruta AND e.nota_final >= 60;

    SELECT COUNT(*) INTO total
    FROM Evaluaciones e
    JOIN CampersGrupo cg ON e.documento_camper = cg.documento_camper
    JOIN Grupos g ON cg.id_grupo = g.id_grupo
    WHERE g.id_ruta = id_ruta;

    RETURN IFNULL((aprobados / total) * 100, 0);
END $$

DELIMITER ;

-- 10. Verificar si un trainer tiene horario disponible.
DELIMITER $$

CREATE FUNCTION TrainerDisponible(documento_trainer VARCHAR(12), p_hora_inicio TIME, p_hora_fin TIME) 
RETURNS BOOLEAN DETERMINISTIC
BEGIN
    DECLARE ocupado INT;

    SELECT COUNT(*) INTO ocupado
    FROM Grupos
    WHERE documento_trainer = documento_trainer 
    AND ((p_hora_inicio BETWEEN hora_inicio AND hora_fin) 
    OR (p_hora_fin BETWEEN hora_inicio AND hora_fin));

    RETURN ocupado = 0;
END $$

DELIMITER ;

-- 11. Obtener el promedio de notas por ruta.
DELIMITER $$

CREATE FUNCTION PromedioNotasRuta(id_ruta DECIMAL(3,0)) 
RETURNS DECIMAL(5,2) DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);

    SELECT AVG(nota_final) INTO promedio
    FROM Evaluaciones e
    JOIN CampersGrupo cg ON e.documento_camper = cg.documento_camper
    JOIN Grupos g ON cg.id_grupo = g.id_grupo
    WHERE g.id_ruta = id_ruta;

    RETURN IFNULL(promedio, 0);
END $$

DELIMITER ;

-- 12. Calcular cuántas rutas tiene asignadas un trainer.
DELIMITER $$

CREATE FUNCTION RutasPorTrainer(documento_trainer VARCHAR(12)) 
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(DISTINCT id_ruta) INTO total
    FROM Grupos
    WHERE documento_trainer = documento_trainer;

    RETURN total;
END $$

DELIMITER ;

-- 13. Verificar si un camper puede ser graduado.
DELIMITER $$

CREATE FUNCTION PuedeSerGraduado(documento_camper VARCHAR(12)) 
RETURNS BOOLEAN DETERMINISTIC
BEGIN
    DECLARE total_modulos INT;
    DECLARE aprobados INT;

    SELECT COUNT(*) INTO total_modulos
    FROM ModulosRuta mr
    JOIN CampersGrupo cg ON mr.id_ruta = cg.id_grupo
    WHERE cg.documento_camper = documento_camper;

    SELECT COUNT(*) INTO aprobados
    FROM Evaluaciones
    WHERE documento_camper = documento_camper AND nota_final >= 60;

    RETURN aprobados = total_modulos;
END $$

DELIMITER ;

-- 14. Obtener el estado actual de un camper en función de sus evaluaciones.
DELIMITER $$

CREATE FUNCTION EstadoActualCamper(documento_camper VARCHAR(12)) 
RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);

    SELECT AVG(nota_final) INTO promedio
    FROM Evaluaciones
    WHERE documento_camper = documento_camper;

    IF promedio IS NULL THEN
        RETURN 'Inscrito';
    ELSEIF promedio >= 60 THEN
        RETURN 'En curso';
    ELSE
        RETURN 'Bajo rendimiento';
    END IF;
END $$

DELIMITER ;

-- 15. Calcular la carga horaria semanal de un trainer.
DELIMITER $$

CREATE FUNCTION CargaHorariaTrainer(documento_trainer VARCHAR(12)) 
RETURNS DECIMAL(5,2) DETERMINISTIC
BEGIN
    DECLARE total_horas DECIMAL(5,2);

    SELECT SUM(TIMESTAMPDIFF(HOUR, hora_inicio, hora_fin)) INTO total_horas
    FROM Grupos
    WHERE documento_trainer = documento_trainer;

    RETURN IFNULL(total_horas, 0);
END $$

DELIMITER ;

-- 16. Determinar si una ruta tiene módulos pendientes por evaluación.
DELIMITER $$

CREATE FUNCTION ModulosPendientesEvaluacion(id_ruta DECIMAL(3,0)) 
RETURNS BOOLEAN DETERMINISTIC
BEGIN
    DECLARE pendientes INT;

    SELECT COUNT(*) INTO pendientes
    FROM ModulosRuta mr
    LEFT JOIN Evaluaciones e ON mr.id_modulo = e.id_modulo
    WHERE mr.id_ruta = id_ruta AND e.id_evaluacion IS NULL;

    RETURN pendientes > 0;
END $$

DELIMITER ;

-- 17. Calcular el promedio general del programa.
DELIMITER $$

CREATE FUNCTION PromedioGeneralPrograma() 
RETURNS DECIMAL(5,2) DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);

    SELECT AVG(nota_final) INTO promedio
    FROM Evaluaciones;

    RETURN IFNULL(promedio, 0);
END $$

DELIMITER ;

-- 18. Verificar si un horario choca con otros entrenadores en el área.
DELIMITER $$

CREATE FUNCTION HorarioChocaConTrainer(id_area DECIMAL(3,0), p_hora_inicio TIME, p_hora_fin TIME) 
RETURNS BOOLEAN DETERMINISTIC
BEGIN
    DECLARE conflictos INT;

    SELECT COUNT(*) INTO conflictos
    FROM Grupos
    WHERE id_area = id_area 
    AND ((p_hora_inicio BETWEEN hora_inicio AND hora_fin) OR 
         (p_hora_fin BETWEEN hora_inicio AND hora_fin));

    RETURN conflictos > 0;
END $$

DELIMITER ;

-- 19. Calcular cuántos campers están en riesgo en una ruta específica.
DELIMITER $$

CREATE FUNCTION CampersEnRiesgoRuta(id_ruta DECIMAL(3,0)) 
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE cantidad INT;
    SELECT COUNT(*) INTO cantidad
    FROM CampersGrupo cg
    JOIN Campers c ON cg.documento_camper = c.documento_camper
    JOIN Grupos g ON cg.id_grupo = g.id_grupo
    WHERE g.id_ruta = id_ruta AND c.nivel_riesgo = 'Alto';

    RETURN cantidad;
END $$

DELIMITER ;

-- 20. Consultar el número de módulos evaluados por un camper.
DELIMITER $$

CREATE FUNCTION ModulosEvaluadosCamper(documento_camper VARCHAR(12)) 
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE cantidad INT;

    SELECT COUNT(DISTINCT id_modulo) INTO cantidad
    FROM Evaluaciones
    WHERE documento_camper = documento_camper;

    RETURN cantidad;
END $$

DELIMITER ;

