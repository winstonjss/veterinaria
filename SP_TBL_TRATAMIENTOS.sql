------------------------------ INSERT

DELIMITER //

CREATE PROCEDURE spInsertTreatment (
    IN p_trat_nombre VARCHAR(255),
    IN p_trat_descripcion TEXT,
    IN p_trat_fecha_inicio DATE,
    IN p_trat_fecha_fin DATE,
    IN p_tbl_diagnosticos_diag_id INT
)
BEGIN
    INSERT INTO veterinaria.tbl_tratamientos (trat_nombre, trat_descripcion, trat_fecha_inicio, trat_fecha_fin, tbl_diagnosticos_diag_id)
    VALUES (p_trat_nombre, p_trat_descripcion, p_trat_fecha_inicio, p_trat_fecha_fin, p_tbl_diagnosticos_diag_id);
END //

DELIMITER ;

------------------------------ UPDATE
DELIMITER //

CREATE PROCEDURE spUpdateTreatment (
    IN p_trat_id INT,
    IN p_trat_nombre VARCHAR(255),
    IN p_trat_descripcion TEXT,
    IN p_trat_fecha_inicio DATE,
    IN p_trat_fecha_fin DATE,
    IN p_tbl_diagnosticos_diag_id INT
)
BEGIN
    UPDATE veterinaria.tbl_tratamientos
    SET trat_nombre = p_trat_nombre,
        trat_descripcion = p_trat_descripcion,
        trat_fecha_inicio = p_trat_fecha_inicio,
        trat_fecha_fin = p_trat_fecha_fin,
        tbl_diagnosticos_diag_id = p_tbl_diagnosticos_diag_id
    WHERE trat_id = p_trat_id;
END //

DELIMITER ;


------------------------------ DELETE

DELIMITER //

CREATE PROCEDURE spDeleteTreatment (
    IN p_trat_id INT
)
BEGIN
    DELETE FROM veterinaria.tbl_tratamientos
    WHERE trat_id = p_trat_id;
END //

DELIMITER ;
------------------------------ SELECT id


DELIMITER //

CREATE PROCEDURE spSelectTreatmentId (
    IN p_trat_id INT
)
BEGIN
    SELECT * FROM veterinaria.tbl_tratamientos
    WHERE trat_id = p_trat_id;
END //

DELIMITER ;

------------------------------ SELECT


DELIMITER //

CREATE PROCEDURE spSelectTreatment (
    
)
BEGIN
    SELECT * FROM veterinaria.tbl_tratamientos;
END //

DELIMITER ;


