-- MySQL dump 10.13  Distrib 8.0.32, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: tpcc
-- ------------------------------------------------------
-- Server version	8.0.32

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
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `c_id` int NOT NULL,
  `c_d_id` int NOT NULL,
  `c_w_id` int NOT NULL,
  `c_first` varchar(16) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `c_middle` char(2) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `c_last` varchar(16) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `c_street_1` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `c_street_2` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `c_city` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `c_state` char(2) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `c_zip` char(9) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `c_phone` char(16) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `c_since` datetime DEFAULT NULL,
  `c_credit` char(2) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `c_credit_lim` decimal(12,2) DEFAULT NULL,
  `c_discount` decimal(4,4) DEFAULT NULL,
  `c_balance` decimal(12,2) DEFAULT NULL,
  `c_ytd_payment` decimal(12,2) DEFAULT NULL,
  `c_payment_cnt` int DEFAULT NULL,
  `c_delivery_cnt` int DEFAULT NULL,
  `c_data` varchar(500) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`c_w_id`,`c_d_id`,`c_id`),
  KEY `c_w_id` (`c_w_id`,`c_d_id`,`c_last`,`c_first`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `district`
--

DROP TABLE IF EXISTS `district`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `district` (
  `d_id` int NOT NULL,
  `d_w_id` int NOT NULL,
  `d_ytd` decimal(12,2) DEFAULT NULL,
  `d_tax` decimal(4,4) DEFAULT NULL,
  `d_next_o_id` int DEFAULT NULL,
  `d_name` varchar(10) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `d_street_1` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `d_street_2` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `d_city` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `d_state` char(2) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `d_zip` char(9) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`d_w_id`,`d_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `history`
--

DROP TABLE IF EXISTS `history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `history` (
  `h_c_id` int DEFAULT NULL,
  `h_c_d_id` int DEFAULT NULL,
  `h_c_w_id` int DEFAULT NULL,
  `h_d_id` int DEFAULT NULL,
  `h_w_id` int DEFAULT NULL,
  `h_date` datetime DEFAULT NULL,
  `h_amount` decimal(6,2) DEFAULT NULL,
  `h_data` varchar(24) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `item`
--

DROP TABLE IF EXISTS `item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item` (
  `i_id` int NOT NULL,
  `i_im_id` int DEFAULT NULL,
  `i_name` varchar(24) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `i_price` decimal(5,2) DEFAULT NULL,
  `i_data` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`i_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `new_order`
--

DROP TABLE IF EXISTS `new_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `new_order` (
  `no_w_id` int NOT NULL,
  `no_d_id` int NOT NULL,
  `no_o_id` int NOT NULL,
  PRIMARY KEY (`no_w_id`,`no_d_id`,`no_o_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_line`
--

DROP TABLE IF EXISTS `order_line`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_line` (
  `ol_w_id` int NOT NULL,
  `ol_d_id` int NOT NULL,
  `ol_o_id` int NOT NULL,
  `ol_number` int NOT NULL,
  `ol_i_id` int DEFAULT NULL,
  `ol_delivery_d` datetime DEFAULT NULL,
  `ol_amount` int DEFAULT NULL,
  `ol_supply_w_id` int DEFAULT NULL,
  `ol_quantity` int DEFAULT NULL,
  `ol_dist_info` char(24) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`ol_w_id`,`ol_d_id`,`ol_o_id`,`ol_number`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `o_id` int NOT NULL,
  `o_w_id` int NOT NULL,
  `o_d_id` int NOT NULL,
  `o_c_id` int DEFAULT NULL,
  `o_carrier_id` int DEFAULT NULL,
  `o_ol_cnt` int DEFAULT NULL,
  `o_all_local` int DEFAULT NULL,
  `o_entry_d` datetime DEFAULT NULL,
  PRIMARY KEY (`o_w_id`,`o_d_id`,`o_id`),
  KEY `o_w_id` (`o_w_id`,`o_d_id`,`o_c_id`,`o_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stock`
--

DROP TABLE IF EXISTS `stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock` (
  `s_i_id` int NOT NULL,
  `s_w_id` int NOT NULL,
  `s_quantity` int DEFAULT NULL,
  `s_dist_01` char(24) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `s_dist_02` char(24) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `s_dist_03` char(24) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `s_dist_04` char(24) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `s_dist_05` char(24) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `s_dist_06` char(24) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `s_dist_07` char(24) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `s_dist_08` char(24) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `s_dist_09` char(24) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `s_dist_10` char(24) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `s_ytd` bigint DEFAULT NULL,
  `s_order_cnt` int DEFAULT NULL,
  `s_remote_cnt` int DEFAULT NULL,
  `s_data` varchar(50) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`s_w_id`,`s_i_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `warehouse`
--

DROP TABLE IF EXISTS `warehouse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `warehouse` (
  `w_id` int NOT NULL,
  `w_ytd` decimal(12,2) DEFAULT NULL,
  `w_tax` decimal(4,4) DEFAULT NULL,
  `w_name` varchar(10) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `w_street_1` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `w_street_2` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `w_city` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `w_state` char(2) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `w_zip` char(9) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`w_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-01-28 20:07:58
