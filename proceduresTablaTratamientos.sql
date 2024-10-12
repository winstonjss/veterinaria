-- INSERTAR  Tratamiento

DELIMITER // 

CREATE PROCEDURE spInsertTratamiento (
    IN p_trat_nombre VARCHAR(80),
    IN p_trat_descripcion TEXT,
    IN p_trat_fecha_inicio DATE,
    IN p_trat_fecha_fin DATE,
    IN p_tbl_diagnosticos_diag_id INT
)
BEGIN
    INSERT INTO tbl_tratamientos (trat_nombre, trat_descripcion, trat_fecha_inicio, trat_fecha_fin, tbl_diagnosticos_diag_id)
    VALUES (p_trat_nombre, p_trat_descripcion, p_trat_fecha_inicio, p_trat_fecha_fin, p_tbl_diagnosticos_diag_id);
END //

DELIMITER ;

-- EDITAR Tratamiento

DELIMITER //

CREATE PROCEDURE spUpdateTratamiento (
    IN p_trat_id INT,
    IN p_trat_nombre VARCHAR(80),
    IN p_trat_descripcion TEXT,
    IN p_trat_fecha_inicio DATE,
    IN p_trat_fecha_fin DATE,
    IN p_tbl_diagnosticos_diag_id INT
)
BEGIN
    UPDATE tbl_tratamientos 
    SET 
        trat_nombre = p_trat_nombre,
        trat_descripcion = p_trat_descripcion,
        trat_fecha_inicio = p_trat_fecha_inicio,
        p_trat_fecha_fin = p_trat_fecha_fin,
        tbl_diagnosticos_diag_id = p_tbl_diagnosticos_diag_id
    WHERE 
        trat_id = p_trat_id;
END //

DELIMITER ;

-- ELIMINAR Tratamiento

DELIMITER //

CREATE PROCEDURE spDeleteTratamiento (
    IN p_trat_id INT
)
BEGIN
    DELETE FROM tbl_tratamientos WHERE trat_id = p_trat_id;
END //

DELIMITER ;

-- CONSULTAR Tratamiento
DELIMITER //

CREATE PROCEDURE spSelectTratamiento (
    IN p_trat_id INT
)
BEGIN
    SELECT * FROM tbl_tratamientos WHERE trat_id = p_trat_id;
END //

DELIMITER ;



