
-- Insertar historia clinica
DELIMITER //

CREATE PROCEDURE spInsertHistoriaClinica(
    IN p_cit_id INT -- ID de la cita a partir de la cual se generará la historia clínica
)
BEGIN
    DECLARE v_animal_nombre VARCHAR(45);
    DECLARE v_anamnesis_descripcion TEXT;
    DECLARE v_diag_id INT;
    DECLARE v_diag_clasificacion VARCHAR(1000);
    DECLARE v_diag_cod VARCHAR(10);
    DECLARE v_vac_nombre VARCHAR(80);
    DECLARE v_vac_tipo VARCHAR(45);
    DECLARE v_vac_cantidad DECIMAL(10,0);
    DECLARE v_trat_nombre VARCHAR(80);
    DECLARE v_trat_descripcion TEXT;
    DECLARE v_descripcion TEXT;
    DECLARE v_peso DECIMAL(10,0);
    DECLARE v_edad INT;
    DECLARE v_raza VARCHAR(45);
    DECLARE v_fecha_nacimiento DATE;
    DECLARE done INT DEFAULT 0;

    -- Cursor para múltiples diagnósticos
    DECLARE diag_cursor CURSOR FOR
        SELECT d.diag_id, d.diag_clasificación, d.diag_cod
        FROM tbl_diagnosticos d
        JOIN tbl_anamnesis anam ON d.tbl_anamnesis_anam_id = anam.anam_id
        WHERE anam.tbl_citas_cit_id = p_cit_id;

    -- Cursor para vacunas relacionadas con un diagnóstico
    DECLARE vac_cursor CURSOR FOR
        SELECT vac.vac_nombre, vac.vac_tipo, vac.vac_cantidad
        FROM tbl_vacunas vac
        WHERE vac.tbl_diagnosticos_diag_id = v_diag_id;

    -- Cursor para tratamientos relacionados con un diagnóstico
    DECLARE trat_cursor CURSOR FOR
        SELECT trat.trat_nombre, trat.trat_descripcion
        FROM tbl_tratamientos trat
        WHERE trat.tbl_diagnosticos_diag_id = v_diag_id;

    -- Handler para controlar el fin de los cursores
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Obtener el nombre del animal relacionado con la cita
    SELECT a.anim_nombre, a.anim_peso, a.anim_fecha_nacimiento, a.anim_raza
    INTO v_animal_nombre, v_peso, v_fecha_nacimiento, v_raza
    FROM tbl_citas c
    JOIN tbl_animales a ON c.tbl_animales_anim_id = a.anim_id
    WHERE c.cit_id = p_cit_id;	
    
    SET v_edad = TIMESTAMPDIFF(YEAR, v_fecha_nacimiento, CURDATE());
	
    -- Obtener la descripción de la anamnesis relacionada con la cita
    SELECT anam.anam_descripcion
    INTO v_anamnesis_descripcion
    FROM tbl_anamnesis anam
    WHERE anam.tbl_citas_cit_id = p_cit_id;

    -- Inicializar la descripción
    SET v_descripcion = CONCAT('Animal: ', v_animal_nombre, ', Peso del animal: ',v_peso,
    ', Edad del animal: ',v_edad, ', Raza del animal: ',v_raza,
    '\n', 'Anamnesis: ', v_anamnesis_descripcion, '\n');

    -- Abrir cursor de diagnósticos
    OPEN diag_cursor;
    read_diag_loop: LOOP
        FETCH diag_cursor INTO v_diag_id, v_diag_clasificacion, v_diag_cod;
        IF done THEN
            SET done = 0;
            LEAVE read_diag_loop;
        END IF;

        -- Concatenar el diagnóstico a la descripción
        SET v_descripcion = CONCAT(v_descripcion, 'Diagnóstico: Clasificación: ', v_diag_clasificacion, ', Código: ', v_diag_cod, '\n');

        -- Para cada diagnóstico, obtener las vacunas relacionadas
        OPEN vac_cursor;
        vac_loop: LOOP
            FETCH vac_cursor INTO v_vac_nombre, v_vac_tipo, v_vac_cantidad;
            IF done THEN
                SET done = 0;
                LEAVE vac_loop;
            END IF;
            -- Concatenar las vacunas a la descripción
            SET v_descripcion = CONCAT(v_descripcion, 'Vacuna: Nombre: ', v_vac_nombre, ', Tipo: ', v_vac_tipo, ', Cantidad: ', v_vac_cantidad, '\n');
        END LOOP;
        CLOSE vac_cursor;

        -- Para cada diagnóstico, obtener los tratamientos relacionados
        OPEN trat_cursor;
        trat_loop: LOOP
            FETCH trat_cursor INTO v_trat_nombre, v_trat_descripcion;
            IF done THEN
                SET done = 0;
                LEAVE trat_loop;
            END IF;
            -- Concatenar los tratamientos a la descripción
            SET v_descripcion = CONCAT(v_descripcion, 'Tratamiento: Nombre: ', v_trat_nombre, ', Descripción: ', v_trat_descripcion, '\n');
        END LOOP;
        CLOSE trat_cursor;

    END LOOP;
    CLOSE diag_cursor;


    -- Insertar el nuevo registro en tbl_historia_clinica
    INSERT INTO tbl_historia_clinica (
        histo_cli_fecha, 
        histo_cli_descripcion, 
        tbl_citas_cit_id
    )
    VALUES (
        NOW(), -- Fecha y hora actual
        v_descripcion, -- Descripción concatenada
        p_cit_id -- ID de la cita
    );

END //



DELIMITER ;


DELIMITER //

CREATE PROCEDURE spInsertHistoriaClinicaPorFecha(
    IN p_fecha DATE -- Fecha en la cual se buscarán las citas
)
BEGIN
    DECLARE v_cit_id INT;
    DECLARE v_done INT DEFAULT 0;
    DECLARE v_cursor CURSOR FOR
        SELECT cit_id 
        FROM tbl_citas
        WHERE cit_fecha = p_fecha;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;

    -- Abrir el cursor para recorrer todas las citas de la fecha proporcionada
    OPEN v_cursor;

    citas_loop: LOOP
        FETCH v_cursor INTO v_cit_id;
        IF v_done THEN
            LEAVE citas_loop;
        END IF;

        -- Llamar el procedimiento que inserta la historia clínica para cada cita
        CALL spInsertHistoriaClinica(v_cit_id);

    END LOOP citas_loop;

    -- Cerrar el cursor
    CLOSE v_cursor;
END //

DELIMITER ;

-- Consultar historia clinica

DELIMITER //

CREATE PROCEDURE spSelectHistoriaClinicaAnimal (
    IN p_anim_id INT
)
BEGIN
    SELECT hc.histo_cli_descripcion
    FROM tbl_historia_clinica hc
    INNER JOIN tbl_citas c ON hc.tbl_citas_cit_id = c.cit_id
    INNER JOIN tbl_animales a ON c.tbl_animales_anim_id = a.anim_id
    WHERE a.anim_id = p_anim_id;
END //

DELIMITER ;