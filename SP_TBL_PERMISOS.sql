------------------------- INSERTAR 
DELIMITER //
CREATE PROCEDURE spInsertPermission(
    IN p_nombre VARCHAR(45),
    IN p_descripcion VARCHAR(80)
)
BEGIN
    INSERT INTO tbl_permisos (per_nombre, per_descripcion) 
    VALUES (p_nombre, p_descripcion);
END//
DELIMITER ;

------------------------- UPDATE
DELIMITER //
CREATE PROCEDURE spUpdatePermission(
    IN p_id INT,
    IN p_nombre VARCHAR(45),
    IN p_descripcion VARCHAR(80)
)
BEGIN
    UPDATE tbl_permisos 
    SET per_nombre = p_nombre, per_descripcion = p_descripcion
    WHERE per_id = p_id;
END//
DELIMITER ;

------------------------- DELETE
DELIMITER //
CREATE PROCEDURE spDeletePermission(
    IN p_id INT
)
BEGIN
    DELETE FROM tbl_permisos 
    WHERE per_id = p_id;
END//
DELIMITER ;

-------------------------------------SELECT
DELIMITER //
CREATE PROCEDURE spSelectPermission()
BEGIN
    SELECT * 
    FROM tbl_permisos;
END//
DELIMITER ;

-------------------------------------SELECT by ID
DELIMITER //
CREATE PROCEDURE spSelectPermissionById(
    IN p_id INT
)
BEGIN
    SELECT * 
    FROM tbl_permisos 
    WHERE per_id = p_id;
END//
DELIMITER ;

--------------------------------------------SELECT DDL
DELIMITER //
CREATE PROCEDURE spSelectPermissionDDL()
BEGIN
    SELECT per_id, per_nombre
    FROM tbl_permisos;
END//
DELIMITER ;
