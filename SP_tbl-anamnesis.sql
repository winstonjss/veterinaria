------------------------------ INSERT
DELIMITER //

CREATE PROCEDURE spInsertAnamnesis (
    IN p_anam_descripcion VARCHAR(255),
    IN p_tbl_citas_cit_id INT
)
BEGIN
    INSERT INTO veterinaria.tbl_anamnesis (anam_descripcion, tbl_citas_cit_id)
    VALUES (p_anam_descripcion, p_tbl_citas_cit_id);
END //

DELIMITER ;

------------------------------ UPDATE
DELIMITER //

CREATE PROCEDURE spUpdateAnamnesis (
    IN p_anam_id INT,
    IN p_anam_descripcion VARCHAR(255),
    IN p_tbl_citas_cit_id INT
)
BEGIN
    UPDATE veterinaria.tbl_anamnesis
    SET anam_descripcion = p_anam_descripcion,
        tbl_citas_cit_id = p_tbl_citas_cit_id
    WHERE anam_id = p_anam_id;
END //

DELIMITER ;

------------------------------ DELETE
DELIMITER //

CREATE PROCEDURE spDeleteAnamnesis (
    IN p_anam_id INT
)
BEGIN
    DELETE FROM veterinaria.tbl_anamnesis
    WHERE anam_id = p_anam_id;
END //

DELIMITER ;

------------------------------ SELECT id
DELIMITER //

CREATE PROCEDURE spSelectAnamnesisId (
    IN p_anam_id INT
)
BEGIN
    SELECT * FROM veterinaria.tbl_anamnesis
    WHERE anam_id = p_anam_id;
END //

DELIMITER ;

------------------------------ SELECT
DELIMITER //

CREATE PROCEDURE spSelectAnamnesis (
    
)
BEGIN
    SELECT * FROM veterinaria.tbl_anamnesis;
END //

DELIMITER ;

