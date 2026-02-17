-- MySQL dump 10.13  Distrib 8.0.45, for Linux (aarch64)
--
-- Host: mysql    Database: laravel
-- ------------------------------------------------------
-- Server version	8.4.8

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_locks_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `checkins`
--

DROP TABLE IF EXISTS `checkins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `checkins` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `player_id` bigint unsigned NOT NULL,
  `event_id` bigint unsigned NOT NULL,
  `checked_in_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `checkins_player_id_foreign` (`player_id`),
  KEY `checkins_event_id_foreign` (`event_id`),
  CONSTRAINT `checkins_event_id_foreign` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE,
  CONSTRAINT `checkins_player_id_foreign` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `checkins`
--

LOCK TABLES `checkins` WRITE;
/*!40000 ALTER TABLE `checkins` DISABLE KEYS */;
INSERT INTO `checkins` VALUES (9,8,6,'2026-02-14 16:57:25','2026-02-16 16:57:42','2026-02-16 16:57:42'),(10,48,6,'2026-02-14 16:57:44','2026-02-16 16:58:03','2026-02-16 16:58:03'),(11,13,6,'2026-02-14 16:58:03','2026-02-16 16:58:15','2026-02-16 16:59:55'),(12,27,6,'2026-02-14 16:58:15','2026-02-16 16:58:26','2026-02-16 17:00:05'),(13,28,6,'2026-02-14 16:58:26','2026-02-16 16:58:41','2026-02-16 16:58:41'),(14,6,6,'2026-02-14 16:58:41','2026-02-16 16:58:53','2026-02-16 16:58:53'),(15,35,6,'2026-02-14 16:58:53','2026-02-16 16:59:05','2026-02-16 16:59:05'),(16,10,6,'2026-02-14 16:59:05','2026-02-16 16:59:19','2026-02-16 16:59:19'),(17,4,6,'2026-02-14 16:59:19','2026-02-16 16:59:29','2026-02-16 16:59:29'),(18,5,6,'2026-02-14 16:59:29','2026-02-16 16:59:42','2026-02-16 17:00:10'),(19,47,6,'2026-02-14 17:00:21','2026-02-16 17:00:30','2026-02-16 17:00:30'),(20,14,6,'2026-02-14 17:00:30','2026-02-16 17:00:47','2026-02-16 17:00:47'),(21,26,6,'2026-02-14 17:00:47','2026-02-16 17:01:06','2026-02-16 17:01:22'),(22,42,6,'2026-02-14 17:01:06','2026-02-16 17:01:17','2026-02-16 17:01:27'),(23,8,4,'2026-02-14 17:02:56','2026-02-16 17:03:14','2026-02-16 17:03:14'),(24,48,4,'2026-02-14 17:03:14','2026-02-16 17:03:22','2026-02-16 17:07:39'),(25,6,4,'2026-02-14 17:03:22','2026-02-16 17:03:38','2026-02-16 17:03:38'),(26,10,4,'2026-02-14 17:03:38','2026-02-16 17:03:55','2026-02-16 17:03:55'),(27,4,4,'2026-02-14 17:03:55','2026-02-16 17:04:09','2026-02-16 17:04:09'),(28,5,4,'2026-02-14 17:04:09','2026-02-16 17:04:16','2026-02-16 17:04:16'),(29,47,4,'2026-02-14 17:04:16','2026-02-16 17:04:25','2026-02-16 17:04:25'),(30,14,4,'2026-02-14 17:04:25','2026-02-16 17:04:36','2026-02-16 17:07:43'),(31,7,4,'2026-02-14 17:04:36','2026-02-16 17:04:47','2026-02-16 17:04:47'),(32,26,4,'2026-02-14 17:04:47','2026-02-16 17:04:56','2026-02-16 17:04:56'),(33,8,2,'2026-02-14 17:04:56','2026-02-16 17:05:58','2026-02-16 17:05:58'),(34,48,2,'2026-02-14 17:05:58','2026-02-16 17:06:09','2026-02-16 17:06:09'),(35,13,2,'2026-02-14 17:06:09','2026-02-16 17:06:21','2026-02-16 17:06:21'),(36,27,2,'2026-02-14 17:06:21','2026-02-16 17:06:31','2026-02-16 17:06:31'),(37,28,2,'2026-02-14 17:06:31','2026-02-16 17:06:42','2026-02-16 17:06:42'),(38,42,2,'2026-02-14 17:06:42','2026-02-16 17:06:54','2026-02-16 17:06:54'),(39,11,2,'2026-02-14 17:06:54','2026-02-16 17:07:05','2026-02-16 17:07:05'),(40,6,2,'2026-02-14 17:07:05','2026-02-16 17:07:17','2026-02-16 17:07:17'),(41,26,2,'2026-02-14 17:07:53','2026-02-16 17:08:03','2026-02-16 17:08:03'),(42,10,2,'2026-02-14 17:08:03','2026-02-16 17:08:14','2026-02-16 17:08:14'),(43,4,2,'2026-02-14 17:08:14','2026-02-16 17:08:27','2026-02-16 17:08:27'),(44,5,2,'2026-02-14 17:08:27','2026-02-16 17:08:37','2026-02-16 17:08:37'),(45,47,2,'2026-02-14 17:08:37','2026-02-16 17:08:46','2026-02-16 17:08:46'),(46,14,2,'2026-02-14 17:08:46','2026-02-16 17:09:13','2026-02-16 17:09:13'),(47,35,2,'2026-02-14 17:09:13','2026-02-16 17:09:25','2026-02-16 17:09:25'),(48,52,2,'2026-02-14 17:17:08','2026-02-16 17:17:20','2026-02-16 17:17:20'),(49,16,2,'2026-02-14 17:17:20','2026-02-16 17:17:30','2026-02-16 17:17:41'),(50,4,2,'2026-02-15 17:19:27','2026-02-16 17:19:38','2026-02-16 17:19:38'),(51,52,2,'2026-02-15 17:19:38','2026-02-16 17:24:39','2026-02-16 17:24:39'),(52,13,2,'2026-02-15 17:24:39','2026-02-16 17:24:48','2026-02-16 17:26:08'),(53,26,2,'2026-02-15 17:24:48','2026-02-16 17:25:00','2026-02-16 17:25:00'),(54,16,2,'2026-02-15 17:25:00','2026-02-16 17:25:11','2026-02-16 17:25:11'),(55,8,2,'2026-02-15 17:25:11','2026-02-16 17:25:24','2026-02-16 17:25:24'),(56,28,2,'2026-02-15 17:25:24','2026-02-16 17:25:37','2026-02-16 17:25:37'),(57,35,2,'2026-02-15 17:25:37','2026-02-16 17:25:51','2026-02-16 17:25:51'),(58,32,2,'2026-02-15 17:26:26','2026-02-16 17:26:40','2026-02-16 17:26:40'),(59,5,2,'2026-02-15 17:26:40','2026-02-16 17:26:51','2026-02-16 17:26:51'),(60,19,2,'2026-02-15 17:26:51','2026-02-16 17:27:01','2026-02-16 17:27:01'),(61,37,2,'2026-02-15 17:27:01','2026-02-16 17:27:13','2026-02-16 17:27:13'),(62,31,2,'2026-02-15 17:27:13','2026-02-16 17:27:27','2026-02-16 17:27:27'),(63,51,2,'2026-02-15 17:27:27','2026-02-16 17:27:40','2026-02-16 17:27:40'),(64,47,2,'2026-02-15 23:40:51','2026-02-16 23:41:07','2026-02-16 23:41:07'),(65,34,2,'2026-02-15 23:45:00','2026-02-16 23:45:16','2026-02-16 23:45:16');
/*!40000 ALTER TABLE `checkins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `events` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `points` float NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
INSERT INTO `events` VALUES (1,'Guerra Interserver',1.5,'2026-02-14 14:42:51','2026-02-17 02:47:16'),(2,'Boss da Guilda (Santuário) Lvl 45',0.4,'2026-02-14 14:43:10','2026-02-17 02:50:38'),(3,'Ilha de Sindri',1.2,'2026-02-14 14:43:24','2026-02-17 02:52:11'),(4,'Boss do Vale Ragnarök',0.85,'2026-02-14 14:43:35','2026-02-17 02:53:56'),(5,'Boss do Templo do Caos (P3)',0.7,'2026-02-14 14:43:46','2026-02-17 02:51:19'),(6,'Boss Encruzilhada Ragnarök',0.85,'2026-02-15 04:04:04','2026-02-17 02:53:50'),(7,'Boss do Árvore do Mundo (P4)',0.7,'2026-02-15 04:05:04','2026-02-17 02:51:30'),(8,'Boss da Guilda (Santuário) Lvl 55',0.5,'2026-02-17 02:40:18','2026-02-17 02:50:52');
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'0001_01_01_000000_create_users_table',1),(2,'0001_01_01_000001_create_cache_table',1),(3,'0001_01_01_000002_create_jobs_table',1),(4,'2026_02_14_142237_create_players_table',1),(5,'2026_02_14_143941_create_events_table',2),(6,'2026_02_14_144604_create_checkins_table',3),(7,'2026_02_17_023233_add_discord_to_players_table',4),(8,'2026_02_17_023635_change_points_to_float_in_events_table',5);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `players`
--

DROP TABLE IF EXISTS `players`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `players` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `power` int NOT NULL,
  `discord` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `players`
--

LOCK TABLES `players` WRITE;
/*!40000 ALTER TABLE `players` DISABLE KEYS */;
INSERT INTO `players` VALUES (2,'HeraGaia',68218,NULL,'2026-02-14 15:12:01','2026-02-16 17:14:51'),(4,'JMS',114699,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(5,'20M4T4R',113913,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(6,'kukula',96182,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(7,'RohaBrasil',73806,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(8,'Eykos',116500,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(9,'Bonanz4',108433,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(10,'AlsetZ',104402,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(11,'Tashiba',104407,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(12,'yGratis',102344,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(13,'GodBaldur',104530,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(14,'Divarr',104917,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(15,'Arqueirarlon',93632,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(16,'Vinnie031',94813,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(17,'HADESGOD666',89640,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(18,'Stjf',88629,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(19,'iBoCaT',86131,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(20,'Motocatemato',87955,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(21,'Hirox',85263,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(22,'Tagista',82909,NULL,'2026-02-14 16:01:46','2026-02-14 16:01:46'),(23,'xXVEINHUx',83363,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(24,'zSagax',83427,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(25,'Mirelly',82607,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(26,'Jnrr',83961,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(27,'LILÁ',82835,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(28,'MeiaBunda',79496,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(29,'BerSha',77897,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(30,'Rupture',77261,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(31,'Gahiêll',79884,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(32,'xNefarious',75779,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(33,'uvinha',78214,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(34,'marciovlz',72937,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(35,'DAM4g',68990,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(36,'GinMKD',68091,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(37,'Atilaht',68181,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(38,'Mavona',67211,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(39,'sokinhas',59778,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(40,'Betinaツ',97155,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(41,'KLLER',91062,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(42,'EternalLove愛',91979,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(43,'VIGNOTO',82882,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(44,'RogerioRJ',83112,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(45,'2BEBOOTI',83144,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(46,'Hidreo',78609,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(47,'Akiiira',79228,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(48,'ImatheusI',80986,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(49,'WeakGirl',70597,NULL,'2026-02-14 16:01:46','2026-02-16 17:14:51'),(51,'PandaKill',108938,NULL,'2026-02-14 16:09:10','2026-02-16 17:14:51'),(52,'Taoista',84562,NULL,'2026-02-16 17:14:51','2026-02-16 17:14:51');
/*!40000 ALTER TABLE `players` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES ('oN3xngYmxLfCQCIYkFLEyFNikK7d5lxbGK1Pxre6',1,'192.168.107.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','YTo3OntzOjY6Il90b2tlbiI7czo0MDoiZ0JsVGJwRlRFVVBjSDVLZ1lYdlZKSnU0REVTb2JwMlE4Y1pna1R2WCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzA6Imh0dHA6Ly9sb2NhbGhvc3QvYWRtaW4vcmV3YXJkcyI7czo1OiJyb3V0ZSI7czoyODoiZmlsYW1lbnQuYWRtaW4ucGFnZXMucmV3YXJkcyI7fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjE7czoxNzoicGFzc3dvcmRfaGFzaF93ZWIiO3M6NjQ6IjgyMTQwYzYxN2MwMjllZjc0ZjIyYjdlNGRlNGJiYThjMzY3YWZiYjAyZWQ4YzhmMDcxN2UzZGJkZDZjMzBlNDQiO3M6NjoidGFibGVzIjthOjU6e3M6NDA6ImU3NzlhMjM5ZmU4ZDQzNzRkMjAwMTkyY2M1ZTBiZTE3X2NvbHVtbnMiO2E6NTp7aTowO2E6Nzp7czo0OiJ0eXBlIjtzOjY6ImNvbHVtbiI7czo0OiJuYW1lIjtzOjQ6Im5hbWUiO3M6NToibGFiZWwiO3M6NDoiTmFtZSI7czo4OiJpc0hpZGRlbiI7YjowO3M6OToiaXNUb2dnbGVkIjtiOjE7czoxMjoiaXNUb2dnbGVhYmxlIjtiOjA7czoyNDoiaXNUb2dnbGVkSGlkZGVuQnlEZWZhdWx0IjtOO31pOjE7YTo3OntzOjQ6InR5cGUiO3M6NjoiY29sdW1uIjtzOjQ6Im5hbWUiO3M6NToicG93ZXIiO3M6NToibGFiZWwiO3M6NToiUG93ZXIiO3M6ODoiaXNIaWRkZW4iO2I6MDtzOjk6ImlzVG9nZ2xlZCI7YjoxO3M6MTI6ImlzVG9nZ2xlYWJsZSI7YjowO3M6MjQ6ImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI7Tjt9aToyO2E6Nzp7czo0OiJ0eXBlIjtzOjY6ImNvbHVtbiI7czo0OiJuYW1lIjtzOjc6ImRpc2NvcmQiO3M6NToibGFiZWwiO3M6NzoiRGlzY29yZCI7czo4OiJpc0hpZGRlbiI7YjowO3M6OToiaXNUb2dnbGVkIjtiOjE7czoxMjoiaXNUb2dnbGVhYmxlIjtiOjA7czoyNDoiaXNUb2dnbGVkSGlkZGVuQnlEZWZhdWx0IjtOO31pOjM7YTo3OntzOjQ6InR5cGUiO3M6NjoiY29sdW1uIjtzOjQ6Im5hbWUiO3M6MTA6ImNyZWF0ZWRfYXQiO3M6NToibGFiZWwiO3M6MTA6IkNyZWF0ZWQgYXQiO3M6ODoiaXNIaWRkZW4iO2I6MDtzOjk6ImlzVG9nZ2xlZCI7YjowO3M6MTI6ImlzVG9nZ2xlYWJsZSI7YjoxO3M6MjQ6ImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI7YjoxO31pOjQ7YTo3OntzOjQ6InR5cGUiO3M6NjoiY29sdW1uIjtzOjQ6Im5hbWUiO3M6MTA6InVwZGF0ZWRfYXQiO3M6NToibGFiZWwiO3M6MTA6IlVwZGF0ZWQgYXQiO3M6ODoiaXNIaWRkZW4iO2I6MDtzOjk6ImlzVG9nZ2xlZCI7YjowO3M6MTI6ImlzVG9nZ2xlYWJsZSI7YjoxO3M6MjQ6ImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI7YjoxO319czo0MDoiMzM1YmUwNGY2MjQzYTM5ZjJjNjliYTIzYjY5MjZlZjNfY29sdW1ucyI7YTo1OntpOjA7YTo3OntzOjQ6InR5cGUiO3M6NjoiY29sdW1uIjtzOjQ6Im5hbWUiO3M6MTE6InBsYXllci5uYW1lIjtzOjU6ImxhYmVsIjtzOjY6IlBsYXllciI7czo4OiJpc0hpZGRlbiI7YjowO3M6OToiaXNUb2dnbGVkIjtiOjE7czoxMjoiaXNUb2dnbGVhYmxlIjtiOjA7czoyNDoiaXNUb2dnbGVkSGlkZGVuQnlEZWZhdWx0IjtOO31pOjE7YTo3OntzOjQ6InR5cGUiO3M6NjoiY29sdW1uIjtzOjQ6Im5hbWUiO3M6MTA6ImV2ZW50Lm5hbWUiO3M6NToibGFiZWwiO3M6NToiRXZlbnQiO3M6ODoiaXNIaWRkZW4iO2I6MDtzOjk6ImlzVG9nZ2xlZCI7YjoxO3M6MTI6ImlzVG9nZ2xlYWJsZSI7YjowO3M6MjQ6ImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI7Tjt9aToyO2E6Nzp7czo0OiJ0eXBlIjtzOjY6ImNvbHVtbiI7czo0OiJuYW1lIjtzOjEyOiJldmVudC5wb2ludHMiO3M6NToibGFiZWwiO3M6NjoiUG9pbnRzIjtzOjg6ImlzSGlkZGVuIjtiOjA7czo5OiJpc1RvZ2dsZWQiO2I6MTtzOjEyOiJpc1RvZ2dsZWFibGUiO2I6MDtzOjI0OiJpc1RvZ2dsZWRIaWRkZW5CeURlZmF1bHQiO047fWk6MzthOjc6e3M6NDoidHlwZSI7czo2OiJjb2x1bW4iO3M6NDoibmFtZSI7czoxMzoiY2hlY2tlZF9pbl9hdCI7czo1OiJsYWJlbCI7czoxMzoiQ2hlY2staW4gVGltZSI7czo4OiJpc0hpZGRlbiI7YjowO3M6OToiaXNUb2dnbGVkIjtiOjE7czoxMjoiaXNUb2dnbGVhYmxlIjtiOjA7czoyNDoiaXNUb2dnbGVkSGlkZGVuQnlEZWZhdWx0IjtOO31pOjQ7YTo3OntzOjQ6InR5cGUiO3M6NjoiY29sdW1uIjtzOjQ6Im5hbWUiO3M6MTA6ImNyZWF0ZWRfYXQiO3M6NToibGFiZWwiO3M6MTA6IkNyZWF0ZWQgYXQiO3M6ODoiaXNIaWRkZW4iO2I6MDtzOjk6ImlzVG9nZ2xlZCI7YjowO3M6MTI6ImlzVG9nZ2xlYWJsZSI7YjoxO3M6MjQ6ImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI7YjoxO319czo0MDoiMzA1NDkzYjA4ZWQ0M2EwZjhiMGNiMjE3YjkwODU3OTdfY29sdW1ucyI7YTo0OntpOjA7YTo3OntzOjQ6InR5cGUiO3M6NjoiY29sdW1uIjtzOjQ6Im5hbWUiO3M6NDoibmFtZSI7czo1OiJsYWJlbCI7czo0OiJOYW1lIjtzOjg6ImlzSGlkZGVuIjtiOjA7czo5OiJpc1RvZ2dsZWQiO2I6MTtzOjEyOiJpc1RvZ2dsZWFibGUiO2I6MDtzOjI0OiJpc1RvZ2dsZWRIaWRkZW5CeURlZmF1bHQiO047fWk6MTthOjc6e3M6NDoidHlwZSI7czo2OiJjb2x1bW4iO3M6NDoibmFtZSI7czo2OiJwb2ludHMiO3M6NToibGFiZWwiO3M6NjoiUG9pbnRzIjtzOjg6ImlzSGlkZGVuIjtiOjA7czo5OiJpc1RvZ2dsZWQiO2I6MTtzOjEyOiJpc1RvZ2dsZWFibGUiO2I6MDtzOjI0OiJpc1RvZ2dsZWRIaWRkZW5CeURlZmF1bHQiO047fWk6MjthOjc6e3M6NDoidHlwZSI7czo2OiJjb2x1bW4iO3M6NDoibmFtZSI7czoxMDoiY3JlYXRlZF9hdCI7czo1OiJsYWJlbCI7czoxMDoiQ3JlYXRlZCBhdCI7czo4OiJpc0hpZGRlbiI7YjowO3M6OToiaXNUb2dnbGVkIjtiOjA7czoxMjoiaXNUb2dnbGVhYmxlIjtiOjE7czoyNDoiaXNUb2dnbGVkSGlkZGVuQnlEZWZhdWx0IjtiOjE7fWk6MzthOjc6e3M6NDoidHlwZSI7czo2OiJjb2x1bW4iO3M6NDoibmFtZSI7czoxMDoidXBkYXRlZF9hdCI7czo1OiJsYWJlbCI7czoxMDoiVXBkYXRlZCBhdCI7czo4OiJpc0hpZGRlbiI7YjowO3M6OToiaXNUb2dnbGVkIjtiOjA7czoxMjoiaXNUb2dnbGVhYmxlIjtiOjE7czoyNDoiaXNUb2dnbGVkSGlkZGVuQnlEZWZhdWx0IjtiOjE7fX1zOjQwOiI4M2FhNThlZDAxMzJlZTJlZmI3Y2ZkNjIxMGJjYjQxYV9jb2x1bW5zIjthOjQ6e2k6MDthOjc6e3M6NDoidHlwZSI7czo2OiJjb2x1bW4iO3M6NDoibmFtZSI7czoxMToicGxheWVyX25hbWUiO3M6NToibGFiZWwiO3M6NjoiUGxheWVyIjtzOjg6ImlzSGlkZGVuIjtiOjA7czo5OiJpc1RvZ2dsZWQiO2I6MTtzOjEyOiJpc1RvZ2dsZWFibGUiO2I6MDtzOjI0OiJpc1RvZ2dsZWRIaWRkZW5CeURlZmF1bHQiO047fWk6MTthOjc6e3M6NDoidHlwZSI7czo2OiJjb2x1bW4iO3M6NDoibmFtZSI7czoxMDoicG9pbnRzX3N1bSI7czo1OiJsYWJlbCI7czoxNDoiQ2hlY2tpbiBQb2ludHMiO3M6ODoiaXNIaWRkZW4iO2I6MDtzOjk6ImlzVG9nZ2xlZCI7YjoxO3M6MTI6ImlzVG9nZ2xlYWJsZSI7YjowO3M6MjQ6ImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI7Tjt9aToyO2E6Nzp7czo0OiJ0eXBlIjtzOjY6ImNvbHVtbiI7czo0OiJuYW1lIjtzOjU6InBvd2VyIjtzOjU6ImxhYmVsIjtzOjU6IlBvd2VyIjtzOjg6ImlzSGlkZGVuIjtiOjA7czo5OiJpc1RvZ2dsZWQiO2I6MTtzOjEyOiJpc1RvZ2dsZWFibGUiO2I6MDtzOjI0OiJpc1RvZ2dsZWRIaWRkZW5CeURlZmF1bHQiO047fWk6MzthOjc6e3M6NDoidHlwZSI7czo2OiJjb2x1bW4iO3M6NDoibmFtZSI7czoxNjoicmVkZW1wdGlvbl9zY29yZSI7czo1OiJsYWJlbCI7czo2OiJQb2ludHMiO3M6ODoiaXNIaWRkZW4iO2I6MDtzOjk6ImlzVG9nZ2xlZCI7YjoxO3M6MTI6ImlzVG9nZ2xlYWJsZSI7YjowO3M6MjQ6ImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI7Tjt9fXM6NDE6IjgzYWE1OGVkMDEzMmVlMmVmYjdjZmQ2MjEwYmNiNDFhX3Blcl9wYWdlIjtzOjI6IjUwIjt9czo4OiJmaWxhbWVudCI7YTowOnt9fQ==',1771296988);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','admin@admin.com',NULL,'$2y$12$ffoVc0jXxaP9ZiGc6JsnXOsB5hPd1xdglLs.NS5L6xSGWJlfhPkKa',NULL,'2026-02-14 14:31:34','2026-02-14 14:31:34');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-17  3:13:35
