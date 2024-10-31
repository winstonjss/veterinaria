--Procedimientos para la tabla Roles y permisos
---------------------------------------------------INSERTAR
DELIMITER //
CREATE PROCEDURE spInsertRole_Permission(
    IN p_rol_id INT,
    IN p_permiso_id INT
)
BEGIN
    INSERT INTO tbl_rol_has_tbl_permisos (tbl_rol_rol_id, tbl_permisos_per_id) 
    VALUES (p_rol_id, p_permiso_id);
END//
DELIMITER ;

---------------------------------------------------DELETE
DELIMITER //
CREATE PROCEDURE spDeleteRole_Permission(
    IN p_rol_id INT,
    IN p_permiso_id INT
)
BEGIN
    DELETE FROM tbl_rol_has_tbl_permisos 
    WHERE tbl_rol_rol_id = p_rol_id AND tbl_permisos_per_id = p_permiso_id;
END//
DELIMITER ;

------------------------------------------------SELECT PERMISSION by ROL 
DELIMITER //
CREATE PROCEDURE spSelectPermisionByRol(
    IN p_rol_id INT
)
BEGIN
    SELECT tbl_permisos.per_id, tbl_permisos.per_nombre, tbl_permisos.per_descripcion
    FROM tbl_rol_has_tbl_permisos
    INNER JOIN tbl_permisos ON tbl_rol_has_tbl_permisos.tbl_permisos_per_id = tbl_permisos.per_id
    WHERE tbl_rol_has_tbl_permisos.tbl_rol_rol_id = p_rol_id;
END//
DELIMITER ;

------------------------------------------------SELECT ROLES by permission
DELIMITER //
CREATE PROCEDURE spSelectRolesByPermiso(
    IN p_permiso_id INT
)
BEGIN
    SELECT tbl_rol.rol_id, tbl_rol.rol_nombre, tbl_rol.rol_descripcion
    FROM tbl_rol_has_tbl_permisos
    INNER JOIN tbl_rol ON tbl_rol_has_tbl_permisos.tbl_rol_rol_id = tbl_rol.rol_id
    WHERE tbl_rol_has_tbl_permisos.tbl_permisos_per_id = p_permiso_id;
END//
DELIMITER ;

-----------------------------------------------------UPDATE 
DELIMITER //
CREATE PROCEDURE spUpdateRoles_Permission(
    IN old_rol_id INT,
    IN old_permiso_id INT,
    IN new_rol_id INT,
    IN new_permiso_id INT
)
BEGIN
    UPDATE tbl_rol_has_tbl_permisos
    SET tbl_rol_rol_id = new_rol_id, tbl_permisos_per_id = new_permiso_id
    WHERE tbl_rol_rol_id = old_rol_id AND tbl_permisos_per_id = old_permiso_id;
END//
DELIMITER ;

-----------------------------------------------------SELECT_ALL
DELIMITER //
CREATE PROCEDURE spSelectRoles_Permission()
BEGIN
    SELECT 
		r.rol_id AS rol_id,
        r.rol_nombre AS rol_nombre,
        p.per_id AS per_id,
        p.per_nombre AS per_nombre
    FROM 
        tbl_rol_has_tbl_permisos rp
    INNER JOIN 
        tbl_rol r ON rp.tbl_rol_rol_id = r.rol_id
    INNER JOIN 
        tbl_permisos p ON rp.tbl_permisos_per_id = p.per_id;
END
DELIMITER ;
