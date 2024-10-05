-- Insertar una cita
DELIMITER //
create procedure spInsertCita(
    IN p_animal_id INT,
    IN p_veterinario_documento VARCHAR(15),
    IN p_fecha DATE,
    IN p_hora_inicio TIME,
    IN p_hora_fin TIME
)
BEGIN
    DECLARE v_vet_id INT;
    DECLARE v_horario_disponible INT;
    DECLARE v_cita_existente INT;

    -- Obtener el ID del veterinario a partir de su documento
    SELECT vet_id INTO v_vet_id
    FROM tbl_veterinario v
    JOIN tbl_usuarios u ON v.tbl_usuarios_usu_id = u.usu_id
    WHERE u.usu_documento = p_veterinario_documento;

    IF v_vet_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Veterinario no encontrado';
    END IF;

    -- Verificar si el veterinario está disponible en el horario agendado
    SELECT COUNT(*) INTO v_horario_disponible
    FROM tbl_horarios_veterinario
    WHERE tbl_veterinario_vet_id = v_vet_id
    AND hor_vet_fecha = p_fecha
    AND p_hora_inicio >= hor_vet_hora_inicio
    AND p_hora_fin <= hor_vet_hora_final;

    IF v_horario_disponible = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El veterinario no está disponible en este horario';
    END IF;

    -- Verificar si ya existe una cita agendada en el mismo horario
    SELECT COUNT(*) INTO v_cita_existente
    FROM tbl_citas
    WHERE cit_fecha = p_fecha
    AND tbl_veterinario_vet_id = v_vet_id
    AND (p_hora_inicio BETWEEN cit_hora_inicio AND cit_hora_fin
         OR p_hora_fin BETWEEN cit_hora_inicio AND cit_hora_fin
         OR cit_hora_inicio BETWEEN p_hora_inicio AND p_hora_fin);

    IF v_cita_existente > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya existe una cita agendada en este horario';
    END IF;

    -- Insertar la cita
    INSERT INTO tbl_citas (cit_fecha, cit_hora_inicio, cit_hora_fin, tbl_animales_anim_id, tbl_veterinario_vet_id)
    VALUES (p_fecha, p_hora_inicio, p_hora_fin, p_animal_id, v_vet_id);

END //
DELIMITER ;


-- Editar cita
DELIMITER //

CREATE PROCEDURE spUpdateCita(
    IN p_cita_id INT,
    IN p_animal_id INT,
    IN p_veterinario_documento VARCHAR(15),
    IN p_nueva_fecha DATE,
    IN p_nueva_hora_inicio TIME,
    IN p_nueva_hora_fin TIME
)
BEGIN
    DECLARE v_vet_id INT;
    DECLARE v_horario_disponible INT;
    DECLARE v_cita_existente INT;

    -- Obtener el ID del veterinario a partir de su documento
    SELECT vet_id INTO v_vet_id
    FROM tbl_veterinario v
    JOIN tbl_usuarios u ON v.tbl_usuarios_usu_id = u.usu_id
    WHERE u.usu_documento = p_veterinario_documento;

    IF v_vet_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Veterinario no encontrado';
    END IF;

    -- Verificar si el veterinario está disponible en el nuevo horario agendado
    SELECT COUNT(*) INTO v_horario_disponible
    FROM tbl_horarios_veterinario
    WHERE tbl_veterinario_vet_id = v_vet_id
    AND hor_vet_fecha = p_nueva_fecha
    AND p_nueva_hora_inicio >= hor_vet_hora_inicio
    AND p_nueva_hora_fin <= hor_vet_hora_final;

    IF v_horario_disponible = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El veterinario no está disponible en el nuevo horario';
    END IF;

    -- Verificar si ya existe una cita agendada en el nuevo horario
    SELECT COUNT(*) INTO v_cita_existente
    FROM tbl_citas
    WHERE cit_fecha = p_nueva_fecha
    AND tbl_veterinario_vet_id = v_vet_id
    AND cit_id != p_cita_id  -- Excluir la cita actual
    AND (p_nueva_hora_inicio BETWEEN cit_hora_inicio AND cit_hora_fin
         OR p_nueva_hora_fin BETWEEN cit_hora_inicio AND cit_hora_fin
         OR cit_hora_inicio BETWEEN p_nueva_hora_inicio AND p_nueva_hora_fin);

    IF v_cita_existente > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya existe una cita agendada en este nuevo horario';
    END IF;

    -- Actualizar la cita
    UPDATE tbl_citas
    SET cit_fecha = p_nueva_fecha,
        cit_hora_inicio = p_nueva_hora_inicio,
        cit_hora_fin = p_nueva_hora_fin,
        tbl_animales_anim_id = p_animal_id,
        tbl_veterinario_vet_id = v_vet_id
    WHERE cit_id = p_cita_id;

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
