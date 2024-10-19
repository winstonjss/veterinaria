--Procedimientos para la tabla roles 
------------------------- INSERTAR 
DELIMITER //
CREATE PROCEDURE spInsertRole(
    IN p_nombre VARCHAR(45),
    IN p_descripcion VARCHAR(80)
)
BEGIN
    INSERT INTO tbl_rol (rol_nombre, rol_descripcion) 
    VALUES (p_nombre, p_descripcion);
END//
DELIMITER ;

----------------------------------------UPDATE
DELIMITER //
CREATE PROCEDURE spUpdateRol(
    IN p_id INT,
    IN p_nombre VARCHAR(45),
    IN p_descripcion VARCHAR(80)
)
BEGIN
    UPDATE tbl_rol 
    SET rol_nombre = p_nombre, rol_descripcion = p_descripcion
    WHERE rol_id = p_id;
END//
DELIMITER ;

-------------------------------------------DELETE
DELIMITER //
CREATE PROCEDURE spDeleteRole(
    IN p_id INT
)
BEGIN
    DELETE FROM tbl_rol 
    WHERE rol_id = p_id;
END//
DELIMITER ;

--------------------------------------------SELECT
DELIMITER //
CREATE PROCEDURE spSelectRoles()
BEGIN
    SELECT * 
    FROM tbl_rol;
END//
DELIMITER ;

--------------------------------------------SELECT by ID
DELIMITER //
CREATE PROCEDURE spSelectRolesById(
    IN p_id INT
)
BEGIN
    SELECT * 
    FROM tbl_rol 
    WHERE rol_id = p_id;
END//
DELIMITER ;


--------------------------------------------SELECT DDL
DELIMITER //
CREATE PROCEDURE spSelectRolesDDL()
BEGIN
    SELECT rol_id, rol_nombre 
    FROM tbl_rol;
END//
DELIMITER ;