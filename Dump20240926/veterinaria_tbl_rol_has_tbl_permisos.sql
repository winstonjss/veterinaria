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
-- Table structure for table `tbl_rol_has_tbl_permisos`
--

DROP TABLE IF EXISTS `tbl_rol_has_tbl_permisos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_rol_has_tbl_permisos` (
  `tbl_rol_rol_id` int NOT NULL,
  `tbl_permisos_per_id` int NOT NULL,
  PRIMARY KEY (`tbl_rol_rol_id`,`tbl_permisos_per_id`),
  KEY `fk_tbl_rol_has_tbl_permisos_tbl_permisos1_idx` (`tbl_permisos_per_id`),
  KEY `fk_tbl_rol_has_tbl_permisos_tbl_rol_idx` (`tbl_rol_rol_id`),
  CONSTRAINT `fk_tbl_rol_has_tbl_permisos_tbl_permisos1` FOREIGN KEY (`tbl_permisos_per_id`) REFERENCES `tbl_permisos` (`per_id`),
  CONSTRAINT `fk_tbl_rol_has_tbl_permisos_tbl_rol` FOREIGN KEY (`tbl_rol_rol_id`) REFERENCES `tbl_rol` (`rol_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_rol_has_tbl_permisos`
--

LOCK TABLES `tbl_rol_has_tbl_permisos` WRITE;
/*!40000 ALTER TABLE `tbl_rol_has_tbl_permisos` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbl_rol_has_tbl_permisos` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-09-26 19:20:12
