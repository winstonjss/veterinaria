-- Selecciona todos los Permisos Roles
DELIMITER //
CREATE PROCEDURE spSelectRoles_Permission()
BEGIN
	select 
    rol_permiso,
    tbl_rol_rol_id,
    tbl_rol.rol_nombre,
    tbl_permisos.per_id,
    tbl_permisos.per_nombre,
    per_rol_fecha_asignacion
    from tbl_rol_permiso
    inner join tbl_rol
    on tbl_rol.rol_id = tbl_rol_permiso.tbl_rol_rol_id
    inner join tbl_permisos
    on tbl_permisos.per_id = tbl_rol_permiso.tbl_permisos_per_id;
END//
DELIMITER ;

-- Insertar un Permiso Rol
DELIMITER //
CREATE PROCEDURE spInsertRole_Permission(IN p_rol_id INT, p_permiso_id INT,IN p_date DATE)
BEGIN
    insert into tbl_rol_permiso(tbl_rol_rol_id,tbl_permisos_per_id,per_rol_fecha_asignacion) values(p_rol_id,p_permiso_id,p_date);
END//
DELIMITER ;

-- Actualizar un Permiso Rol
DELIMITER //
create procedure spUpdateRoles_Permission(IN p_rol_permiso INT, IN p_fkrol INT,IN p_fkpermiso INT,IN p_date DATE)
begin
	update tbl_rol_permiso
    set tbl_rol_rol_id = p_fkrol, tbl_permisos_per_id = p_fkpermiso, per_rol_fecha_asignacion = p_date
    where rol_permiso = p_rol_permiso;
end//
DELIMITER ;

-- Eliminar un permiso rol
DELIMITER //
create procedure spDeleteRole_Permission(IN p_id INT)
begin
	delete from tbl_rol_permiso where rol_permiso = p_id;
end//
DELIMITER ;

