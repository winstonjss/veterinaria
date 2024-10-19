-- Insertar un nuevo horario de veterinario
DELIMITER //
CREATE PROCEDURE spInsertVeterinaryHours(
	IN p_start_date DATE,
    IN p_end_date DATE,
	IN p_start_time TIME,
	IN p_final_time TIME,
	IN p_fkveterinarian INT)
BEGIN
	INSERT INTO tbl_horarios_veterinario(
	hor_vet_fecha_inicio, 
    hor_vet_fecha_final,
	hor_vet_hora_inicio, 
	hor_vet_hora_final, 
	tbl_veterinario_vet_id)
    VALUES(p_start_date, p_end_date, p_start_time, p_final_time, p_fkveterinarian);
END//
DELIMITER ;


-- Actualizar un horario del veterinario existente
DELIMITER //
CREATE PROCEDURE spUpdateVeterinaryHours(
		IN p_hor_vet_id INT,
		IN p_start_date DATE,
        IN p_end_date DATE,
		IN p_start_time TIME,
		IN p_final_time TIME,
		IN p_fkveterinarian INT)
BEGIN
	UPDATE tbl_horarios_veterinario
	SET 
		hor_vet_fecha_inicio = p_start_date,
        hor_vet_fecha_final = p_end_date,
		hor_vet_hora_inicio = p_start_time, 
		hor_vet_hora_final = p_final_time, 
		tbl_veterinario_vet_id = p_fkveterinarian
	WHERE hor_vet_id = p_hor_vet_id;
END//
DELIMITER ;


-- Mostrar (seleccionar) todos los horarios de veterinario
DELIMITER //
CREATE PROCEDURE spSelectVeterinaryHours()
BEGIN
	SELECT
		hor_vet_id,
        hor_vet_fecha_inicio,
        hor_vet_fecha_final,
		hor_vet_hora_inicio, 
		hor_vet_hora_final, 
		tbl_veterinario_vet_id, tbl_veterinario.vet_nombre
	FROM tbl_horarios_veterinario
	INNER JOIN tbl_veterinario
	ON tbl_horarios_veterinario.tbl_veterinario_vet_id = tbl_veterinario.vet_id;
END//
DELIMITER ;


-- Eliminar un horario de veterinario
DELIMITER //
CREATE PROCEDURE spDeleteVeterinaryHours(
	IN p_hor_vet_id INT)
BEGIN
	DELETE FROM tbl_horarios_veterinario 
    WHERE hor_vet_id = p_hor_vet_id;
END//
DELIMITER ;