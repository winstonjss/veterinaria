DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsertHistoriaClinicaByCita`(
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
    DECLARE v_anam_count INT; -- Variable para contar si existe anamnesis
    DECLARE v_vet_nombre VARCHAR(45);
    DECLARE v_cit_fecha DATE;
    DECLARE v_cit_hora_inicio TIME;
    DECLARE v_cit_hora_fin TIME;    
    DECLARE done INT DEFAULT 0;

    -- Cursor para múltiples diagnósticos
    DECLARE diag_cursor CURSOR FOR
        SELECT d.diag_id, d.diag_clasificacion, d.diag_cod
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
    
    SELECT vet.vet_nombre, c.cit_fecha, c.cit_hora_inicio, c.cit_hora_fin
    INTO v_vet_nombre, v_cit_fecha, v_cit_hora_inicio, v_cit_hora_fin
    FROM tbl_citas c
    JOIN tbl_veterinario vet ON c.tbl_veterinario_vet_id = vet.vet_id
    WHERE c.cit_id = p_cit_id;
    
    SET v_edad = TIMESTAMPDIFF(YEAR, v_fecha_nacimiento, CURDATE());
    
    -- Verificar si existe una anamnesis relacionada con la cita
    SELECT COUNT(*)
    INTO v_anam_count
    FROM tbl_anamnesis anam
    WHERE anam.tbl_citas_cit_id = p_cit_id;

    -- Si existe la anamnesis, obtener la descripción; de lo contrario, asignar un valor por defecto
    IF v_anam_count > 0 THEN
        SELECT anam.anam_descripcion
        INTO v_anamnesis_descripcion
        FROM tbl_anamnesis anam
        WHERE anam.tbl_citas_cit_id = p_cit_id;
    ELSE
        SET v_anamnesis_descripcion = 'No hay anamnesis asociada.';
    END IF;

    -- Inicializar la descripción
    SET v_descripcion = CONCAT('Animal: ', v_animal_nombre, ', Peso del animal: ',v_peso,
    ', Edad del animal: ',v_edad, ', Raza del animal: ',v_raza,
    '\n', 'Anamnesis: ', v_anamnesis_descripcion, '\n',
    'Veterinario: ',v_vet_nombre , '\n'
    'Fecha: ',v_cit_fecha,', Hora inicio Cita: ',v_cit_hora_inicio , ', Hora Fin Cita: ',v_cit_hora_fin ,'\n');

    -- Abrir cursor de diagnósticos
    OPEN diag_cursor;
    read_diag_loop: LOOP
        FETCH diag_cursor INTO v_diag_id, v_diag_clasificacion, v_diag_cod;
        IF done THEN
            SET done = 0;
            LEAVE read_diag_loop;
        END IF;

        -- Concatenar el diagnóstico a la descripción
        SET v_descripcion = CONCAT(v_descripcion, 'Diagnóstico: Clasificación: ', IFNULL(v_diag_clasificacion, 'No especificado'), ', Código: ', IFNULL(v_diag_cod, 'No especificado'), '\n');

        -- Para cada diagnóstico, obtener las vacunas relacionadas
        OPEN vac_cursor;
        vac_loop: LOOP
            FETCH vac_cursor INTO v_vac_nombre, v_vac_tipo, v_vac_cantidad;
            IF done THEN
                SET done = 0;
                LEAVE vac_loop;
            END IF;
            -- Concatenar las vacunas a la descripción
            SET v_descripcion = CONCAT(v_descripcion, 'Vacuna: Nombre: ', IFNULL(v_vac_nombre, 'No especificado'), ', Tipo: ', IFNULL(v_vac_tipo, 'No especificado'), ', Cantidad: ', IFNULL(v_vac_cantidad, 0), '\n');
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
            SET v_descripcion = CONCAT(v_descripcion, 'Tratamiento: Nombre: ', IFNULL(v_trat_nombre, 'No especificado'), ', Descripción: ', IFNULL(v_trat_descripcion, 'No especificado'), '\n');
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `spSelectHistoriaClinicaByAnimal`(
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

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `spDeleteHistoriaClinica`(
    IN p_histo_cli_id INT
)
BEGIN
    DELETE FROM tbl_historia_clinica
    WHERE  histo_cli_id=p_histo_cli_id;
END //
DELIMITER ;


DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `spUpdateHistoriaClinica`(
    IN p_histo_cli_id INT,
    IN p_histo_cli_fecha DATE,    
    IN p_cit_id INT
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
    DECLARE v_anam_count INT; -- Variable para contar si existe anamnesis
    DECLARE v_vet_nombre VARCHAR(45);
    DECLARE v_cit_fecha DATE;
    DECLARE v_cit_hora_inicio TIME;
    DECLARE v_cit_hora_fin TIME;    
    DECLARE done INT DEFAULT 0;

    -- Cursor para múltiples diagnósticos
    DECLARE diag_cursor CURSOR FOR
        SELECT d.diag_id, d.diag_clasificacion, d.diag_cod
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
    
    SELECT vet.vet_nombre, c.cit_fecha, c.cit_hora_inicio, c.cit_hora_fin
    INTO v_vet_nombre, v_cit_fecha, v_cit_hora_inicio, v_cit_hora_fin
    FROM tbl_citas c
    JOIN tbl_veterinario vet ON c.tbl_veterinario_vet_id = vet.vet_id
    WHERE c.cit_id = p_cit_id;
    
    SET v_edad = TIMESTAMPDIFF(YEAR, v_fecha_nacimiento, CURDATE());
    
    -- Verificar si existe una anamnesis relacionada con la cita
    SELECT COUNT(*)
    INTO v_anam_count
    FROM tbl_anamnesis anam
    WHERE anam.tbl_citas_cit_id = p_cit_id;

    -- Si existe la anamnesis, obtener la descripción; de lo contrario, asignar un valor por defecto
    IF v_anam_count > 0 THEN
        SELECT anam.anam_descripcion
        INTO v_anamnesis_descripcion
        FROM tbl_anamnesis anam
        WHERE anam.tbl_citas_cit_id = p_cit_id;
    ELSE
        SET v_anamnesis_descripcion = 'No hay anamnesis asociada.';
    END IF;

    -- Inicializar la descripción
    SET v_descripcion = CONCAT('Animal: ', v_animal_nombre, ', Peso del animal: ',v_peso,
    ', Edad del animal: ',v_edad, ', Raza del animal: ',v_raza,
    '\n', 'Anamnesis: ', v_anamnesis_descripcion, '\n',
    'Veterinario: ',v_vet_nombre , '\n'
    'Fecha: ',v_cit_fecha,', Hora inicio Cita: ',v_cit_hora_inicio , ', Hora Fin Cita: ',v_cit_hora_fin ,'\n');

    -- Abrir cursor de diagnósticos
    OPEN diag_cursor;
    read_diag_loop: LOOP
        FETCH diag_cursor INTO v_diag_id, v_diag_clasificacion, v_diag_cod;
        IF done THEN
            SET done = 0;
            LEAVE read_diag_loop;
        END IF;

        -- Concatenar el diagnóstico a la descripción
        SET v_descripcion = CONCAT(v_descripcion, 'Diagnóstico: Clasificación: ', IFNULL(v_diag_clasificacion, 'No especificado'), ', Código: ', IFNULL(v_diag_cod, 'No especificado'), '\n');

        -- Para cada diagnóstico, obtener las vacunas relacionadas
        OPEN vac_cursor;
        vac_loop: LOOP
            FETCH vac_cursor INTO v_vac_nombre, v_vac_tipo, v_vac_cantidad;
            IF done THEN
                SET done = 0;
                LEAVE vac_loop;
            END IF;
            -- Concatenar las vacunas a la descripción
            SET v_descripcion = CONCAT(v_descripcion, 'Vacuna: Nombre: ', IFNULL(v_vac_nombre, 'No especificado'), ', Tipo: ', IFNULL(v_vac_tipo, 'No especificado'), ', Cantidad: ', IFNULL(v_vac_cantidad, 0), '\n');
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
            SET v_descripcion = CONCAT(v_descripcion, 'Tratamiento: Nombre: ', IFNULL(v_trat_nombre, 'No especificado'), ', Descripción: ', IFNULL(v_trat_descripcion, 'No especificado'), '\n');
        END LOOP;
        CLOSE trat_cursor;

    END LOOP;
    CLOSE diag_cursor;

    UPDATE tbl_historia_clinica 
    SET 
        histo_cli_fecha = p_histo_cli_fecha,
        histo_cli_descripcion = v_descripcion,
        tbl_citas_cit_id = p_cit_id        
    WHERE 
        histo_cli_id = p_histo_cli_id;
END //
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `spSelectHistoriaClinicaAll`(

)
BEGIN
    
        SELECT * FROM tbl_historia_clinica;
        
END //
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `spDeleteHistoriaClinica`(
    IN p_histo_cli_id INT
)
BEGIN
    DELETE FROM tbl_tipo_documento 
    WHERE histo_cli_id = p_histo_cli_id;
END //
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `spDeleteHistoriaClinica`(
    IN p_histo_cli_id INT
)
BEGIN
    DELETE FROM tbl_historia_clinica 
    WHERE histo_cli_id = p_histo_cli_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE spSelectHistoriaClinicaAnimal(
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