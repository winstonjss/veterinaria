-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: veterinaria
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `tbl_citas`
--

DROP TABLE IF EXISTS `tbl_citas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_citas` (
  `cit_id` int NOT NULL AUTO_INCREMENT,
  `cit_fecha` datetime NOT NULL,
  `cit_valor_cita` decimal(10,0) NOT NULL,
  `cit_motivo` varchar(45) NOT NULL,
  `tbl_animales_anim_id` int NOT NULL,
  `tbl_veterinario_vet_id` int NOT NULL,
  `tbl_propietario_pro_id` int NOT NULL,
  PRIMARY KEY (`cit_id`,`tbl_animales_anim_id`,`tbl_veterinario_vet_id`,`tbl_propietario_pro_id`),
  KEY `fk_tbl_citas_tbl_animales1_idx` (`tbl_animales_anim_id`),
  KEY `fk_tbl_citas_tbl_veterinario1_idx` (`tbl_veterinario_vet_id`),
  KEY `fk_tbl_citas_tbl_propietario1_idx` (`tbl_propietario_pro_id`),
  CONSTRAINT `fk_tbl_citas_tbl_animales1` FOREIGN KEY (`tbl_animales_anim_id`) REFERENCES `tbl_animales` (`anim_id`),
  CONSTRAINT `fk_tbl_citas_tbl_propietario1` FOREIGN KEY (`tbl_propietario_pro_id`) REFERENCES `tbl_propietario` (`pro_id`),
  CONSTRAINT `fk_tbl_citas_tbl_veterinario1` FOREIGN KEY (`tbl_veterinario_vet_id`) REFERENCES `tbl_veterinario` (`vet_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_citas`
--

LOCK TABLES `tbl_citas` WRITE;
/*!40000 ALTER TABLE `tbl_citas` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbl_citas` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-09-26 19:20:13
