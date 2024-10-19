------------------------------ INSERT

DELIMITER //

CREATE PROCEDURE spInsertVaccine (
    IN p_vac_nombre VARCHAR(255),
    IN p_vac_tipo VARCHAR(100),
    IN p_vac_cantidad INT,
    IN p_tbl_diagnosticos_diag_id INT
)
BEGIN
    INSERT INTO veterinaria.tbl_vacunas (vac_nombre, vac_tipo, vac_cantidad, tbl_diagnosticos_diag_id)
    VALUES (p_vac_nombre, p_vac_tipo, p_vac_cantidad, p_tbl_diagnosticos_diag_id);
END //

DELIMITER ;

------------------------------ UPDATE

DELIMITER //

CREATE PROCEDURE spUpdateVaccine (
    IN p_vac_id INT,
    IN p_vac_nombre VARCHAR(255),
    IN p_vac_tipo VARCHAR(100),
    IN p_vac_cantidad INT,
    IN p_tbl_diagnosticos_diag_id INT
)
BEGIN
    UPDATE veterinaria.tbl_vacunas
    SET vac_nombre = p_vac_nombre,
        vac_tipo = p_vac_tipo,
        vac_cantidad = p_vac_cantidad,
        tbl_diagnosticos_diag_id = p_tbl_diagnosticos_diag_id
    WHERE vac_id = p_vac_id;
END //

DELIMITER ;

------------------------------ DELETE

DELIMITER //

CREATE PROCEDURE spDeleteVaccine (
    IN p_vac_id INT
)
BEGIN
    DELETE FROM veterinaria.tbl_vacunas
    WHERE vac_id = p_vac_id;
END //

DELIMITER ;

------------------------------ SELECT id

DELIMITER //

CREATE PROCEDURE spSelectVaccineId (
    IN p_vac_id INT
)
BEGIN
    IF p_vac_id IS NOT NULL THEN
        SELECT * FROM veterinaria.tbl_vacunas WHERE vac_id = p_vac_id;
    ELSE
        SELECT * FROM veterinaria.tbl_vacunas;
    END IF;
END //

DELIMITER ;

------------------------------ SELECT

DELIMITER //

CREATE PROCEDURE spSelectVaccine (
    
)
BEGIN
        SELECT * FROM veterinaria.tbl_vacunas;
END //

DELIMITER ;

