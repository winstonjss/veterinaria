------------------------------ INSERT
DELIMITER //

CREATE PROCEDURE spInsertDiagnosis (
    IN p_diag_clasificacion VARCHAR(255),
    IN p_diag_cod VARCHAR(50),
    IN p_tbl_anamnesis_anam_id INT
)
BEGIN
    INSERT INTO veterinaria.tbl_diagnosticos (diag_clasificación, diag_cod, tbl_anamnesis_anam_id)
    VALUES (p_diag_clasificacion, p_diag_cod, p_tbl_anamnesis_anam_id);
END //

DELIMITER ;

------------------------------ UPDATE
DELIMITER //

CREATE PROCEDURE spUpdateDiagnosis (
    IN p_diag_id INT,
    IN p_diag_clasificacion VARCHAR(255),
    IN p_diag_cod VARCHAR(50),
    IN p_tbl_anamnesis_anam_id INT
)
BEGIN
    UPDATE veterinaria.tbl_diagnosticos
    SET diag_clasificación = p_diag_clasificacion,
        diag_cod = p_diag_cod,
        tbl_anamnesis_anam_id = p_tbl_anamnesis_anam_id
    WHERE diag_id = p_diag_id;
END //

DELIMITER ;

------------------------------ DELETE
DELIMITER //

CREATE PROCEDURE spDeleteDiagnosis (
    IN p_diag_id INT
)
BEGIN
    DELETE FROM veterinaria.tbl_diagnosticos
    WHERE diag_id = p_diag_id;
END //

DELIMITER ;

------------------------------ SELECT id
DELIMITER //

CREATE PROCEDURE spSelectDiagnosisId (
    IN p_diag_id INT
)
BEGIN
    SELECT * FROM veterinaria.tbl_diagnosticos
    WHERE diag_id = p_diag_id;
END //

DELIMITER ;

------------------------------ SELECT
DELIMITER //

CREATE PROCEDURE spSelectDiagnosis (
    
)
BEGIN
    SELECT * FROM veterinaria.tbl_diagnosticos;
END //

DELIMITER ;
