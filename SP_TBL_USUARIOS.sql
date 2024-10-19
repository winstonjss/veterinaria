--Procedimientos para la tabla usuarios
-------------------------------------INSERTAR 
DELIMITER //
CREATE PROCEDURE spInsertUser(
    IN p_documento VARCHAR(15),
    IN p_correo VARCHAR(80),
    IN p_contrasena TEXT,
    IN p_salt TEXT,
    IN p_estado VARCHAR(15),
    IN p_fecha_creacion DATE,
    IN p_rol_id INT,
    IN p_tipo_documento_id INT
)
BEGIN
    INSERT INTO tbl_usuarios (
        usu_documento, 
        usu_correo, 
        usu_contrasena, 
        usu_salt, 
        usu_estado, 
        usu_fecha_creacion, 
        tbl_rol_rol_id, 
        tbl_tipo_documento_tip_doc_id
    ) VALUES (
        p_documento, 
        p_correo, 
        p_contrasena, 
        p_salt, 
        p_estado, 
        p_fecha_creacion, 
        p_rol_id, 
        p_tipo_documento_id
    );
END//
DELIMITER ;

---------------------------------------- UPDATE
DELIMITER //
CREATE PROCEDURE spUpdateUser(
    IN p_usu_id INT,
    IN p_documento VARCHAR(15),
    IN p_correo VARCHAR(80),
    IN p_contrasena TEXT,
    IN p_salt TEXT,
    IN p_estado VARCHAR(15),
    IN p_fecha_creacion DATE,
    IN p_rol_id INT,
    IN p_tipo_documento_id INT
)
BEGIN
    UPDATE tbl_usuarios
    SET 
        usu_documento = p_documento,
        usu_correo = p_correo,
        usu_contrasena = p_contrasena,
        usu_salt = p_salt,
        usu_estado = p_estado,
        usu_fecha_creacion = p_fecha_creacion,
        tbl_rol_rol_id = p_rol_id,
        tbl_tipo_documento_tip_doc_id = p_tipo_documento_id
    WHERE usu_id = p_usu_id;
END//
DELIMITER ;

-------------------------------------------------- DELETE 
DELIMITER //
CREATE PROCEDURE spDeleteUser(
    IN p_usu_id INT
)
BEGIN
    DELETE FROM tbl_usuarios
    WHERE usu_id = p_usu_id;
END//
DELIMITER ;

------------------------------------------------- SELECT
DELIMITER //
CREATE PROCEDURE spSelectUser()
BEGIN
    SELECT 
        u.usu_id, 
        u.usu_documento, 
        u.usu_correo, 
        u.usu_estado, 
        u.usu_fecha_creacion, 
        r.rol_nombre AS rol_nombre, 
        td.tip_doc_descripcion AS tip_doc_descripcion
    FROM tbl_usuarios u
    JOIN tbl_rol r ON u.tbl_rol_rol_id = r.rol_id
    JOIN tbl_tipo_documento td ON u.tbl_tipo_documento_tip_doc_id = td.tip_doc_id;
END//
DELIMITER ;

------------------------------------------------- SELECT DDL
DELIMITER //
CREATE PROCEDURE spSelectUserDDL()
BEGIN
    SELECT 
        usu_id, 
        usu_documento
       
    FROM tbl_usuarios;
    
END//
DELIMITER ;
