-- INSERTAR Diagnostico

DELIMITER //

CREATE PROCEDURE spInsertarDiagnostico (
    IN p_clasificacion VARCHAR(1000),
    IN p_cod VARCHAR(10),
    IN p_anam_id INT
)
BEGIN
    INSERT INTO tbl_diagnosticos (diag_clasificacion, diag_cod, tbl_anamnesis_anam_id)
    VALUES (p_clasificacion, p_cod, p_anam_id);
END //

DELIMITER ;

-- EDITAR Diagnostico

DELIMITER //

CREATE PROCEDURE spEditarDiagnostico (
    IN p_diag_id INT,
    IN p_clasificacion VARCHAR(1000),
    IN p_cod VARCHAR(10),
    IN p_anam_id INT
)
BEGIN
    UPDATE tbl_diagnosticos
    SET diag_clasificacion = p_clasificacion,
        diag_cod = p_cod,
        tbl_anamnesis_anam_id = p_anam_id
    WHERE diag_id = p_diag_id;
END //

DELIMITER ;

-- ELIMINAR Diagnostico

DELIMITER //

CREATE PROCEDURE spEliminarDiagnostico (
    IN p_diag_id INT
)
BEGIN
    DELETE FROM tbl_diagnosticos
    WHERE diag_id = p_diag_id;
END //

DELIMITER ;

-- CONSULTAR Diagnosticos

DELIMITER //

CREATE PROCEDURE spConsultarDiagnosticos ()
BEGIN
    SELECT * FROM tbl_diagnosticos;
END //

DELIMITER ;




