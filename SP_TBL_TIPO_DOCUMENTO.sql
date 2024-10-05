SP tbl_tipo_documento
 --------------------------------- INSERTAR
DELIMITER //
CREATE PROCEDURE spInsertDocumentType(
    IN p_descripcion VARCHAR(45)
)
BEGIN
    INSERT INTO tbl_tipo_documento (tip_doc_descripcion) 
    VALUES (p_descripcion);
END//
DELIMITER ;

----------------------------------ACTUALIZAR
DELIMITER //
CREATE PROCEDURE spUpdateDocumentType(
    IN p_id INT,
    IN p_descripcion VARCHAR(45)
)
BEGIN
    UPDATE tbl_tipo_documento 
    SET tip_doc_descripcion = p_descripcion 
    WHERE tip_doc_id = p_id;
END//
DELIMITER ;

-------------------------------------ELIMINAR
DELIMITER //
CREATE PROCEDURE spDeleteDocumentType(
    IN p_id INT
)
BEGIN
    DELETE FROM tbl_tipo_documento 
    WHERE tip_doc_id = p_id;
END//
DELIMITER ;

--------------------------------------SELECCIONAR TODOS 

DELIMITER //
CREATE PROCEDURE spSelectDocumentType()
BEGIN
    SELECT * 
    FROM tbl_tipo_documento;
END//
DELIMITER ;

---------------------------------------SELECIONAR POR ID
DELIMITER //
CREATE PROCEDURE spSelectDocumentTypeById(
    IN p_id INT
)
BEGIN
    SELECT * 
    FROM tbl_tipo_documento 
    WHERE tip_doc_id = p_id;
END//
DELIMITER ;
