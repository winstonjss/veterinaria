-- INSERTAR Vacuna

DELIMITER //

CREATE PROCEDURE spInsertVacuna (
    IN p_vac_nombre VARCHAR(80),
    IN p_vac_tipo VARCHAR(45),
    IN p_vac_cantidad DECIMAL(10,0),
    IN p_tbl_diagnosticos_diag_id INT
)
BEGIN
    INSERT INTO tbl_vacunas (vac_nombre, vac_tipo, vac_cantidad, tbl_diagnosticos_diag_id)
    VALUES (p_vac_nombre, p_vac_tipo, p_vac_cantidad, p_tbl_diagnosticos_diag_id);
END //

DELIMITER ;

-- EDITAR Vacuna
DELIMITER //

CREATE PROCEDURE spUpdateVacuna (
    IN p_vac_id INT,
    IN p_vac_nombre VARCHAR(80),
    IN p_vac_tipo VARCHAR(45),
    IN p_vac_cantidad DECIMAL(10,0),
    IN p_tbl_diagnosticos_diag_id INT
)
BEGIN
    UPDATE tbl_vacunas
    SET 
        vac_nombre = p_vac_nombre,
        vac_tipo = p_vac_tipo,
        vac_cantidad = p_vac_cantidad,
        tbl_diagnosticos_diag_id = p_tbl_diagnosticos_diag_id
    WHERE vac_id = p_vac_id;
END //

DELIMITER ;

-- ELIMINAR Vacuna

DELIMITER //

CREATE PROCEDURE spDeleteVacuna (
    IN p_vac_id INT
)
BEGIN
    DELETE FROM tbl_vacunas
    WHERE vac_id = p_vac_id;
END //

DELIMITER ;

-- CONSULTAR Vacunas

DELIMITER //

CREATE PROCEDURE spSelectVacunas ()
BEGIN
    SELECT * FROM tbl_vacunas;
END //

DELIMITER ;
