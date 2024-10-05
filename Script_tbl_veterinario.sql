-- Insertar un nuevo veterinario
DELIMITER //
CREATE PROCEDURE spInsertVeterinarian(
	IN p_name VARCHAR(45),
	IN p_phone VARCHAR(45),
    IN p_fkusers INT,
    IN p_fkoffice INT)
BEGIN
	INSERT INTO tbl_veterinario(
	vet_nombre, 
	vet_telefono, 
	tbl_usuarios_usu_id,
    tbl_consultorio_con_id)
    VALUES(p_name, p_phone, p_fkusers, p_fkoffice);
END//
DELIMITER ;


-- Actualizar un veterinario existente
DELIMITER //
DELIMITER //
CREATE PROCEDURE spUpdateVeterinarian(
	IN p_vet_id INT,
	IN p_name VARCHAR(45),
	IN p_phone VARCHAR(45),
	IN p_fkusers INT,
        IN p_fkoffice INT)
BEGIN
	UPDATE tbl_veterinario
	SET 
		vet_nombre = p_name, 
		vet_telefono = p_phone,  
		tbl_usuarios_usu_id = p_fkusers,
        tbl_consultorio_con_id = p_fkoffice
    WHERE vet_id = p_vet_id;
END//
DELIMITER ;


-- Mostrar (seleccionar) todos los veterinarios
DELIMITER //
CREATE PROCEDURE spSelectVeterinarian()
BEGIN
	SELECT
		vet_id,
		vet_nombre, 
		vet_telefono, 
		tbl_usuarios_usu_id, tbl_usuarios.usu_documento
		tbl_consultorio_con_id, tbl_consultorio.con_num_consultario
	FROM tbl_veterinario
	INNER JOIN tbl_usuarios
	ON tbl_veterinario.tbl_usuarios_usu_id = tbl_usuarios.usu_id
    	INNER JOIN tbl_consultorio
	ON tbl_veterinario.tbl_consultorio_con_id = tbl_consultorio.con_id;
END//
DELIMITER ;


-- Eliminar un veterinario
DELIMITER //
CREATE PROCEDURE spDeleteVeterinarian(
	IN p_vet_id INT)
BEGIN
	DELETE FROM tbl_veterinario 
    WHERE vet_id = p_vet_id;
END//
DELIMITER ;