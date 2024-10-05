--Procedimientos tabla consultorio
---------------------------------------------------INSERTAR
DELIMITER $$
CREATE PROCEDURE spInsertOffice(
    IN p_num_consultorio VARCHAR(10)
)
BEGIN
    INSERT INTO tbl_consultorio (con_num_consultorio)
    VALUES (p_num_consultorio);
END$$

DELIMITER ;

-------------------------------------------------------UPDATE
DELIMITER $$

CREATE PROCEDURE spUpdateOffice(
    IN p_id INT,
    IN p_num_consultorio VARCHAR(10)
)
BEGIN
    UPDATE tbl_consultorio
    SET con_num_consultorio = p_num_consultorio
    WHERE con_id = p_id;
END$$

DELIMITER ;

--------------------------------------------------------DELETE
DELIMITER $$

CREATE PROCEDURE spDeleteOffice(
    IN p_id INT
)
BEGIN
    DELETE FROM tbl_consultorio
    WHERE con_id = p_id;
END$$

DELIMITER ;

------------------------------------------------------SELECT
DELIMITER $$

CREATE PROCEDURE spSelectOffice()
BEGIN
    SELECT con_id, con_num_consultorio
    FROM tbl_consultorio;
END $$

DELIMITER ;
