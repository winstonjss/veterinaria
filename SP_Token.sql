DELIMITER $$

CREATE PROCEDURE spInsertToken(
    IN p_token_hash TEXT,
    IN p_token_correo VARCHAR(80),
    IN p_token_fecha_generacion TIMESTAMP,
    IN p_token_fecha_vencimiento TIMESTAMP
)
BEGIN
    -- Inserta un nuevo registro en la tabla tbl_token
    INSERT INTO tbl_token (token_hash, token_correo, token_fecha_generacion, token_fecha_vencimiento)
    VALUES (p_token_hash, p_token_correo, p_token_fecha_generacion, p_token_fecha_vencimiento);
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE spShowTokenByHash(
    IN p_token_hash TEXT
)
BEGIN
    -- Selecciona los registros de tbl_token donde token_hash coincide con el valor proporcionado
    SELECT token_id, token_hash, token_correo, token_fecha_generacion, token_fecha_vencimiento
    FROM tbl_token
    WHERE token_hash = p_token_hash;
END$$

DELIMITER ;

-- Procedimiento para validar si la fecha de entrada NO ha superado la fecha de vencimiento para un token_correo

DELIMITER $$

CREATE PROCEDURE spValidateTokenExpiration(
    IN p_token_hash TEXT,
    IN p_fecha_comparacion TIMESTAMP,  -- Fecha proporcionada por el usuario para la comparación
    OUT p_is_expired INT
)
BEGIN
    -- Declarar una variable para la fecha de vencimiento del token
    DECLARE token_vencido TIMESTAMP;

    -- Obtener la fecha de vencimiento del token
    SELECT token_fecha_vencimiento INTO token_vencido
    FROM tbl_token
    WHERE token_hash = p_token_hash
    LIMIT 1;

    -- Si se encuentra el token, comparar la fecha de vencimiento con la fecha proporcionada
    IF token_vencido IS NOT NULL THEN
        IF token_vencido < p_fecha_comparacion THEN
            -- Si la fecha de vencimiento es menor que la fecha proporcionada, el token ha expirado
            SET p_is_expired = 1;
        ELSE
            -- Si la fecha de vencimiento no ha pasado, el token no ha expirado
            SET p_is_expired = 0;
        END IF;
    ELSE
        -- Si no se encuentra el token en la base de datos, se considera que no existe
        SET p_is_expired = 0;
    END IF;
END$$

DELIMITER ;

-- Procedimiento para actualizar la contraseña y el salt
DELIMITER $$
CREATE PROCEDURE spActualizarContrasena (
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

CREATE PROCEDURE spVerificarCorreoExistente (
    IN p_correo VARCHAR(80),
    OUT p_existe INT
)
BEGIN
    DECLARE v_count INT;

    -- Contar las coincidencias del correo en la tabla
    SELECT COUNT(*)
    INTO v_count
    FROM tbl_usuarios
    WHERE usu_correo = p_correo;

    -- Determinar si el correo existe y asignar el valor entero
    IF v_count > 0 THEN
        SET p_existe = 1; -- El correo existe
    ELSE
        SET p_existe = 0; -- El correo no existe
    END IF;
END$$

DELIMITER ;
