-- Procedimiento para validar si la fecha de entrada NO ha superado la fecha de vencimiento para un token_correo
DELIMITER $$
CREATE PROCEDURE validar_token_no_expirado (
    IN p_correo VARCHAR(80),
    IN p_fecha TIMESTAMP,
    OUT p_valido BOOLEAN
)
BEGIN
    DECLARE v_fecha_vencimiento TIMESTAMP;

    -- Obtener la fecha de vencimiento del token correspondiente al correo
    SELECT token_fecha_vencimiento
    INTO v_fecha_vencimiento
    FROM tbl_token
    WHERE token_correo = p_correo;

    -- Validar si la fecha de entrada no ha superado la fecha de vencimiento
    IF p_fecha <= v_fecha_vencimiento THEN
        SET p_valido = TRUE; -- Fecha válida
    ELSE
        SET p_valido = FALSE; -- Fecha no válida
    END IF;
END$$
DELIMITER ;


-- Procedimiento para actualizar la contraseña y el salt
DELIMITER $$
CREATE PROCEDURE actualizar_contrasena (
    IN p_correo VARCHAR(80),
    IN p_nueva_contrasena TEXT,
    IN p_nuevo_salt TEXT
)
BEGIN
    -- Actualizar la contraseña y el salt para el correo proporcionado
    UPDATE tbl_usuarios
    SET usu_contrasena = p_nueva_contrasena,
        usu_salt = p_nuevo_salt
    WHERE usu_correo = p_correo;
END$$
DELIMITER ;

-- Procedimiento para verificar si un correo existe
DELIMITER $$
CREATE PROCEDURE verificar_correo_existe (
    IN p_correo VARCHAR(80),
    OUT p_existe BOOLEAN
)
BEGIN
    DECLARE v_count INT;

    -- Contar las coincidencias del correo en la tabla
    SELECT COUNT(*)
    INTO v_count
    FROM tbl_usuarios
    WHERE usu_correo = p_correo;

    -- Determinar si el correo existe
    IF v_count > 0 THEN
        SET p_existe = TRUE; -- El correo existe
    ELSE
        SET p_existe = FALSE; -- El correo no existe
    END IF;
END$$
DELIMITER ;