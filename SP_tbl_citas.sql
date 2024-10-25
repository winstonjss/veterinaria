-- Insertar una cita
DELIMITER //

CREATE PROCEDURE spInsertCita(
    IN p_cit_fecha DATE,
    IN p_cit_hora_inicio TIME,
    IN p_cit_hora_fin TIME,
    IN p_animal_id INT,
    IN p_veterinario_id INT
)
BEGIN
    -- Variables para validaciones
    DECLARE citas_conflictivas INT;
    DECLARE horario_valido INT;

    -- Verificar si el veterinario tiene disponibilidad en la fecha y hora solicitada
    SELECT COUNT(*)
    INTO horario_valido
    FROM tbl_horarios_veterinario
    WHERE tbl_veterinario_vet_id = p_veterinario_id
      AND p_cit_fecha BETWEEN hor_vet_fecha_inicio AND hor_vet_fecha_final
      AND p_cit_hora_inicio >= hor_vet_hora_inicio
      AND p_cit_hora_fin <= hor_vet_hora_final;

    -- Si el horario no es válido, devolver un error
    IF horario_valido = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El veterinario no tiene disponibilidad en ese horario';
    ELSE
        -- Verificar si hay alguna cita en el mismo rango de fechas y horas
        SELECT COUNT(*)
        INTO citas_conflictivas
        FROM tbl_citas
        WHERE tbl_veterinario_vet_id = p_veterinario_id
          AND cit_fecha = p_cit_fecha
          AND (
                (p_cit_hora_inicio BETWEEN cit_hora_inicio AND cit_hora_fin)
             OR (p_cit_hora_fin BETWEEN cit_hora_inicio AND cit_hora_fin)
             OR (cit_hora_inicio BETWEEN p_cit_hora_inicio AND p_cit_hora_fin)
             OR (cit_hora_fin BETWEEN p_cit_hora_inicio AND p_cit_hora_fin)
          );

        -- Si no hay citas conflictivas, insertar la nueva cita
        IF citas_conflictivas = 0 THEN
            INSERT INTO tbl_citas (cit_fecha, cit_hora_inicio, cit_hora_fin, tbl_animales_anim_id, tbl_veterinario_vet_id)
            VALUES (p_cit_fecha, p_cit_hora_inicio, p_cit_hora_fin, p_animal_id, p_veterinario_id);
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El veterinario ya tiene una cita en ese rango de horas';
        END IF;
    END IF;
    
END //

DELIMITER ;



-- Editar cita
DELIMITER //

CREATE PROCEDURE spUpdateCita(
    IN p_cit_id INT,
    IN p_cit_fecha DATE,
    IN p_cit_hora_inicio TIME,
    IN p_cit_hora_fin TIME,
    IN p_animal_id INT,
    IN p_veterinario_id INT
)
BEGIN
    -- Variables para validaciones
    DECLARE citas_conflictivas INT;
    DECLARE horario_valido INT;

    -- Verificar si el veterinario tiene disponibilidad en la fecha y hora solicitada
    SELECT COUNT(*)
    INTO horario_valido
    FROM tbl_horarios_veterinario
    WHERE tbl_veterinario_vet_id = p_veterinario_id
      AND p_cit_fecha BETWEEN hor_vet_fecha_inicio AND hor_vet_fecha_final
      AND p_cit_hora_inicio >= hor_vet_hora_inicio
      AND p_cit_hora_fin <= hor_vet_hora_final;

    -- Si el horario no es válido, devolver un error
    IF horario_valido = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El veterinario no tiene disponibilidad en ese horario';
    ELSE
        -- Verificar si hay alguna cita en el mismo rango de fechas y horas (excluyendo la cita que se está actualizando)
        SELECT COUNT(*)
        INTO citas_conflictivas
        FROM tbl_citas
        WHERE tbl_veterinario_vet_id = p_veterinario_id
          AND cit_fecha = p_cit_fecha
          AND cit_id != p_cit_id -- Excluir la cita que se está actualizando
          AND (
                (p_cit_hora_inicio BETWEEN cit_hora_inicio AND cit_hora_fin)
             OR (p_cit_hora_fin BETWEEN cit_hora_inicio AND cit_hora_fin)
             OR (cit_hora_inicio BETWEEN p_cit_hora_inicio AND p_cit_hora_fin)
             OR (cit_hora_fin BETWEEN p_cit_hora_inicio AND p_cit_hora_fin)
          );

        -- Si no hay citas conflictivas, actualizar la cita
        IF citas_conflictivas = 0 THEN
            UPDATE tbl_citas
            SET cit_fecha = p_cit_fecha,
                cit_hora_inicio = p_cit_hora_inicio,
                cit_hora_fin = p_cit_hora_fin,
                tbl_animales_anim_id = p_animal_id,
                tbl_veterinario_vet_id = p_veterinario_id
            WHERE cit_id = p_cit_id;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El veterinario ya tiene una cita en ese rango de horas';
        END IF;
    END IF;

END //

DELIMITER ;

-- Consultar citas con un rango de fechas
DELIMITER //

CREATE PROCEDURE spSelectCitasRangoFechas(
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE
)
BEGIN
    SELECT 
	c.cit_id,
        c.cit_fecha,
        c.cit_hora_inicio,
        c.cit_hora_fin,
        v.vet_nombre AS nombre_veterinario,
        a.anim_nombre AS nombre_animal
    FROM tbl_citas c
    JOIN tbl_veterinario v ON c.tbl_veterinario_vet_id = v.vet_id
    JOIN tbl_animales a ON c.tbl_animales_anim_id = a.anim_id
    WHERE c.cit_fecha BETWEEN p_fecha_inicio AND p_fecha_fin
    ORDER BY c.cit_fecha, c.cit_hora_inicio;
END //

DELIMITER ;

-- Consultar citas de un veterinario con rango de fechas
DELIMITER //

CREATE PROCEDURE spSelectCitasVeterinarioRangoFechas(
    IN p_veterinario_documento VARCHAR(15),
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE
)
BEGIN
    SELECT 
	c.cit_id,
        c.cit_fecha,
        c.cit_hora_inicio,
        c.cit_hora_fin,
        v.vet_nombre AS nombre_veterinario,
        a.anim_nombre AS nombre_animal
    FROM tbl_citas c
    JOIN tbl_veterinario v ON c.tbl_veterinario_vet_id = v.vet_id
    JOIN tbl_animales a ON c.tbl_animales_anim_id = a.anim_id
    JOIN tbl_usuarios u ON v.tbl_usuarios_usu_id = u.usu_id
    WHERE u.usu_documento = p_veterinario_documento
    AND c.cit_fecha BETWEEN p_fecha_inicio AND p_fecha_fin
    ORDER BY c.cit_fecha, c.cit_hora_inicio;
END //

DELIMITER ;

-- Consultar citas de un animal con rango de fechas
DELIMITER //

CREATE PROCEDURE spSelectCitasAnimalRangoFechas(
    IN p_animal_id INT,
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE
)
BEGIN
    SELECT 
	c.cit_id,
        c.cit_fecha,
        c.cit_hora_inicio,
        c.cit_hora_fin,
        v.vet_nombre AS nombre_veterinario,
        a.anim_nombre AS nombre_animal
    FROM tbl_citas c
    JOIN tbl_veterinario v ON c.tbl_veterinario_vet_id = v.vet_id
    JOIN tbl_animales a ON c.tbl_animales_anim_id = a.anim_id
    WHERE a.anim_id = p_animal_id
    AND c.cit_fecha BETWEEN p_fecha_inicio AND p_fecha_fin
    ORDER BY c.cit_fecha, c.cit_hora_inicio;
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE spSelectCitasAll(
)
BEGIN
    
        SELECT * FROM tbl_citas;
        
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE spDeleteCita(
    IN p_cit_id INT
)
BEGIN
    DELETE FROM tbl_citas
    WHERE  cit_id=p_cit_id;
END //
DELIMITER ;

DELIMITER //

CREATE PROCEDURE spSelectCitasDDL(    
)
BEGIN    
    SELECT 
		cit_id,
        cit_fecha        
        FROM tbl_citas;
	END //

DELIMITER ;