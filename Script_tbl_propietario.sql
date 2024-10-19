-- Insertar un nuevo propietario
DELIMITER //
CREATE PROCEDURE spInsertOwner(
	IN p_name VARCHAR(45),
	IN p_phone VARCHAR(45),
	IN p_fkusers INT)
BEGIN
	INSERT INTO tbl_propietario(
	pro_nombre, 
	pro_telefono,  
	tbl_usuarios_usu_id)
    VALUES(p_name, p_phone, p_fkusers);
END//
DELIMITER ;


-- Actualizar un propietario existente
DELIMITER //
CREATE PROCEDURE spUpdateOwner(
		IN p_pro_id INT,
		IN p_name VARCHAR(45),
		IN p_phone VARCHAR(45),
		IN p_fkusers INT)
BEGIN
	UPDATE tbl_propietario
	SET 
        pro_nombre = p_name, 
		pro_telefono = p_phone, 
		tbl_usuarios_usu_id = p_fkusers
    WHERE pro_id = p_pro_id;
END//
DELIMITER ;


-- Mostrar (seleccionar) todos los propietarios
DELIMITER //
CREATE PROCEDURE spSelectOwner()
BEGIN
	SELECT
		pro_id,
		pro_nombre, 
		pro_telefono, 
		tbl_usuarios_usu_id, tbl_usuarios.usu_documento
	FROM tbl_propietario
	INNER JOIN tbl_usuarios
	ON tbl_propietario.tbl_usuarios_usu_id = tbl_usuarios.usu_id;
END//
DELIMITER ;


-- Seleccionar unicamente el id y el nombre de los propietarios
DELIMITER // 
CREATE PROCEDURE spSelectOwnerDDL() 
BEGIN 
	SELECT
		pro_id,
		pro_nombre
	FROM tbl_propietario;
END// 
DELIMITER ; 


-- Eliminar un propietario
DELIMITER //
CREATE PROCEDURE spDeleteOwner(
	IN p_pro_id INT)
BEGIN
	DELETE FROM tbl_propietario 
    WHERE pro_id = p_pro_id;
END//
DELIMITER ;