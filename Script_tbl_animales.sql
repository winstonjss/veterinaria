-- Insertar un nuevo animal
DELIMITER //
CREATE PROCEDURE spInsertAnimals(
	IN p_name VARCHAR(45),
	IN p_species VARCHAR(45),
	IN p_race VARCHAR(45),
	IN p_date_birth DATE,
	IN p_sex VARCHAR(45),
	IN p_weight FLOAT,
	IN p_color VARCHAR(30),
	IN p_fkowner INT)
BEGIN
	INSERT INTO tbl_animales(
	anim_nombre, 
	anim_especie, 
	anim_raza, 
	anim_fecha_nacimiento, 
	anim_sexo, 
	anim_peso,
    anim_color,
	tbl_propietario_pro_id)
    VALUES(p_name, p_species, p_race, p_date_birth, p_sex, p_weight, p_color, p_fkowner);
END//
DELIMITER ;


-- Actualizar un animal existente
DELIMITER //
CREATE PROCEDURE spUpdateAnimals(
		IN p_anim_id INT,
		IN p_name VARCHAR(45),
		IN p_species VARCHAR(45),
		IN p_race VARCHAR(45),
		IN p_date_birth DATE,
		IN p_sex VARCHAR(45),
		IN p_weight FLOAT,
        IN p_color VARCHAR(30),
		IN p_fkowner INT)
BEGIN
	UPDATE tbl_animales
    SET 
		anim_nombre = p_name, 
		anim_especie = p_species, 
		anim_raza = p_race, 
		anim_fecha_nacimiento = p_date_birth, 
		anim_sexo = p_sex, 
		anim_peso = p_weight,
        anim_color = p_color,
		tbl_propietario_pro_id = p_fkowner
    WHERE anim_id = p_anim_id;
END//
DELIMITER ;


-- Mostrar (seleccionar) todos los animales
DELIMITER //
CREATE PROCEDURE spSelectAnimals()
BEGIN
	SELECT
		anim_id,
        anim_nombre, 
		anim_especie, 
		anim_raza, 
		anim_fecha_nacimiento, 
		anim_sexo, 
		anim_peso,
        anim_color,
		tbl_propietario_pro_id, tbl_propietario.pro_nombre
	FROM tbl_animales
	INNER JOIN tbl_propietario
	ON tbl_animales.tbl_propietario_pro_id = tbl_propietario.pro_id;
END//
DELIMITER ;


-- Eliminar un animal
DELIMITER //
CREATE PROCEDURE spDeleteAnimals(
	IN p_anim_id INT)
BEGIN
	DELETE FROM tbl_animales 
    WHERE anim_id = p_anim_id;
END//
DELIMITER ;