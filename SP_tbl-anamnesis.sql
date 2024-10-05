-- INSERTAR  Anamnesis
DELIMITER //

CREATE PROCEDURE spInsertAnamnesis(
    IN p_anam_descripcion TEXT,
    IN p_tbl_citas_cit_id INT
)
BEGIN
    INSERT INTO tbl_anamnesis (anam_descripcion, tbl_citas_cit_id)
    VALUES (p_anam_descripcion, p_tbl_citas_cit_id);
END //

DELIMITER ;

-- EDITAR Anamnesis

DELIMITER //

CREATE PROCEDURE spUpdateAnamnesis(
    IN p_anam_id INT,
    IN p_anam_descripcion TEXT,
    IN p_tbl_citas_cit_id INT
)
BEGIN
    UPDATE tbl_anamnesis
    SET 
        anam_descripcion = p_anam_descripcion,
        tbl_citas_cit_id = p_tbl_citas_cit_id
    WHERE anam_id = p_anam_id;
END //

DELIMITER ;

-- ELIMINAR Anamnesis

DELIMITER //

CREATE PROCEDURE spDeleteAnamnesis(
    IN p_anam_id INT
)
BEGIN
    DELETE FROM tbl_anamnesis
    WHERE anam_id = p_anam_id;
END //

DELIMITER ;

-- CONSULTAR Anamnesis

DELIMITER //

CREATE PROCEDURE spSelectAnamnesis(
    IN p_anam_id INT
)
BEGIN
    IF p_anam_id IS NULL THEN
        -- Si no se proporciona un ID, consulta todos los registros
        SELECT * FROM tbl_anamnesis;
    ELSE
        -- Si se proporciona un ID, consulta un registro específico
        SELECT * FROM tbl_anamnesis
        WHERE anam_id = p_anam_id;
    END IF;
END //

DELIMITER ;

