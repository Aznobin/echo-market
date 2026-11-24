
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

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `echo_market` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `echo_market`;
DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(50) NOT NULL COMMENT '分类名称',
  `parent_id` int NOT NULL DEFAULT '0' COMMENT '父分类ID，0 表示一级分类',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序值，越小越靠前',
  `status` int NOT NULL DEFAULT '1' COMMENT '状态：0停用 / 1启用',
  `is_deleted` tinyint NOT NULL DEFAULT '0' COMMENT '软删除标记：0正常 / 1已删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_sort` (`sort`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品分类表';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'教材书籍',0,1,1,0,'2026-11-21 15:33:47','2026-11-21 15:33:47'),(2,'电子数码',0,2,1,0,'2026-11-21 15:33:47','2026-11-21 15:33:47'),(3,'生活用品',0,3,1,0,'2026-11-21 15:33:47','2026-11-21 15:33:47'),(4,'服饰鞋包',0,4,1,0,'2026-11-21 15:33:47','2026-11-21 15:33:47'),(5,'运动器材',0,5,1,0,'2026-11-21 15:33:47','2026-11-21 15:33:47'),(6,'美妆个护',0,6,1,0,'2026-11-21 15:33:47','2026-11-21 15:33:47'),(7,'其他闲置',0,7,1,0,'2026-11-21 15:33:47','2026-11-21 15:33:47');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `favorite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorite` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` int NOT NULL COMMENT '收藏人用户ID',
  `product_id` int NOT NULL COMMENT '被收藏商品ID',
  `status` int NOT NULL DEFAULT '1' COMMENT '状态：0已取消收藏 / 1收藏中',
  `is_deleted` tinyint NOT NULL DEFAULT '0' COMMENT '软删除标记：0正常 / 1已删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_product` (`user_id`,`product_id`),
  KEY `idx_product_id` (`product_id`),
  CONSTRAINT `fk_favorite_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  CONSTRAINT `fk_favorite_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='收藏表';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `favorite` WRITE;
/*!40000 ALTER TABLE `favorite` DISABLE KEYS */;
INSERT INTO `favorite` VALUES (1,3,1,1,0,'2026-11-21 15:34:11','2026-11-21 15:34:11'),(3,1,10,1,0,'2026-11-21 18:21:41','2026-11-21 18:21:41'),(4,1,16,1,0,'2026-11-21 19:02:52','2026-11-21 19:02:52'),(5,1,17,1,0,'2026-11-21 19:38:31','2026-11-21 19:38:31'),(6,1,19,1,0,'2026-11-21 20:04:36','2026-11-21 20:04:36'),(7,1,20,1,0,'2026-11-21 20:15:02','2026-11-21 20:15:02'),(8,1,21,0,0,'2026-11-21 20:58:30','2026-11-21 20:58:34'),(9,3,27,1,0,'2026-11-24 16:06:48','2026-11-24 16:06:54');
/*!40000 ALTER TABLE `favorite` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `message` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `from_id` int NOT NULL COMMENT '发送人用户ID',
  `to_id` int NOT NULL COMMENT '接收人用户ID',
  `product_id` int DEFAULT NULL COMMENT '关联商品ID，系统通知可为空',
  `content` text NOT NULL COMMENT '消息内容',
  `is_read` tinyint NOT NULL DEFAULT '0' COMMENT '读取标记：0未读 / 1已读',
  `status` int NOT NULL DEFAULT '1' COMMENT '状态：0撤回 / 1正常',
  `is_deleted` tinyint NOT NULL DEFAULT '0' COMMENT '软删除标记：0正常 / 1已删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_to_id_read` (`to_id`,`is_read`),
  KEY `idx_from_id` (`from_id`),
  KEY `idx_product_id` (`product_id`),
  CONSTRAINT `fk_message_from` FOREIGN KEY (`from_id`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_message_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  CONSTRAINT `fk_message_to` FOREIGN KEY (`to_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='消息表';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `message` WRITE;
/*!40000 ALTER TABLE `message` DISABLE KEYS */;
INSERT INTO `message` VALUES (1,1,3,10,'同学你好，这个还在吗？我想周末面交。',1,1,0,'2026-11-21 18:22:31','2026-11-24 16:02:44'),(2,1,3,16,'这个配件都齐全吧？价格还能再商量一点吗？',1,1,0,'2026-11-21 19:02:52','2026-11-24 16:03:10'),(3,1,3,19,'方便今晚九点前在宿舍楼下取吗？',1,1,0,'2026-11-21 20:04:36','2026-11-24 16:03:11'),(4,1,3,20,'我拍下了，麻烦明天带一下充电线，谢谢！',1,1,0,'2026-11-21 20:15:02','2026-11-24 16:02:44'),(5,3,1,20,'没问题，明天下午四点在图书馆门口等你。',1,1,0,'2026-11-22 00:40:36','2026-11-24 16:02:44'),(6,6,1,27,'你好，请问这个可以便宜 10 块吗？我今天就能来拿。',1,1,0,'2026-11-24 15:33:32','2026-11-24 16:02:44'),(7,1,6,27,'可以，四点后我都在，到时候给你留着。',0,1,0,'2026-11-24 15:40:36','2026-11-24 16:02:44');
/*!40000 ALTER TABLE `message` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `order_no` varchar(50) NOT NULL COMMENT '订单编号',
  `product_id` int NOT NULL COMMENT '商品ID',
  `buyer_id` int NOT NULL COMMENT '买家用户ID',
  `seller_id` int NOT NULL COMMENT '卖家用户ID',
  `amount` decimal(10,2) NOT NULL COMMENT '订单金额',
  `delivery_type` varchar(20) NOT NULL DEFAULT 'meetup' COMMENT '交易方式：meetup校内面交 / dorm宿舍配送',
  `pay_method` varchar(20) NOT NULL DEFAULT 'online' COMMENT '支付方式：online在线担保支付 / cod当面验货付款',
  `receiver_name` varchar(50) NOT NULL COMMENT '联系人称呼',
  `phone` varchar(20) NOT NULL COMMENT '联系电话或微信号',
  `address` varchar(120) NOT NULL COMMENT '校内交接或收货地址',
  `remark` varchar(200) DEFAULT NULL COMMENT '订单备注',
  `status` int NOT NULL DEFAULT '0' COMMENT '订单状态：0待付款 / 1已付款 / 2已发货 / 3已完成 / 4已取消',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_no` (`order_no`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_buyer_id` (`buyer_id`),
  KEY `idx_seller_id` (`seller_id`),
  CONSTRAINT `fk_orders_buyer` FOREIGN KEY (`buyer_id`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_orders_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  CONSTRAINT `fk_orders_seller` FOREIGN KEY (`seller_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单表';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,'EM202611211409016028',12,1,3,35.00,'meetup','online','管理员','13800001234','图书馆一楼大厅','麻烦提前十分钟发消息',0,'2026-11-24 16:05:36'),(2,'EM202611211409342840',11,1,3,260.00,'dorm','cod','管理员','13800001234','图书馆一楼大厅',NULL,4,'2026-11-24 16:05:36'),(3,'EM202611211417108156',15,3,1,25.00,'dorm','online','小张','13900005678','南食堂门口','麻烦提前十分钟发消息',1,'2026-11-24 16:05:36'),(4,'EM202611211418573026',14,3,1,15.00,'dorm','online','小张','13900005678','南食堂门口','麻烦提前十分钟发消息',0,'2026-11-24 16:05:36'),(5,'EM202611211430064246',13,3,1,39.00,'meetup','cod','小张','13900005678','南食堂门口',NULL,4,'2026-11-24 16:05:36'),(6,'EM202611211823129618',16,1,3,180.00,'meetup','online','管理员','13800001234','图书馆一楼大厅',NULL,3,'2026-11-24 16:05:36'),(7,'EM202611211833177913',16,1,3,180.00,'dorm','cod','管理员','13800001234','图书馆一楼大厅',NULL,4,'2026-11-24 16:05:36'),(8,'EM202611211906039107',16,1,3,180.00,'meetup','cod','管理员','13800001234','图书馆一楼大厅',NULL,3,'2026-11-24 16:05:36'),(9,'EM202611211939165654',18,1,3,35.00,'meetup','online','管理员','13800001234','图书馆一楼大厅',NULL,3,'2026-11-24 16:05:36'),(10,'EM202611212004363465',19,1,3,150.00,'meetup','cod','管理员','13800001234','图书馆一楼大厅',NULL,3,'2026-11-24 16:05:36'),(11,'EM202611212015027873',20,1,3,280.00,'dorm','online','管理员','13800001234','图书馆一楼大厅',NULL,3,'2026-11-24 16:05:36'),(12,'EM202611212015417687',1,1,3,5056.00,'meetup','cod','管理员','13800001234','图书馆一楼大厅','麻烦提前十分钟发消息',1,'2026-11-24 16:05:36'),(13,'EM202611212016526368',21,1,3,19.00,'meetup','cod','管理员','13800001234','图书馆一楼大厅','麻烦提前十分钟发消息',1,'2026-11-24 16:05:36'),(14,'EM202611212100003370',11,1,3,260.00,'meetup','online','管理员','13800001234','图书馆一楼大厅',NULL,2,'2026-11-24 16:05:36'),(15,'EM202611212142493030',9,3,1,120.00,'meetup','online','小张','13900005678','南食堂门口',NULL,4,'2026-11-24 16:05:36'),(16,'EM202611212149152275',9,3,1,120.00,'meetup','online','小张','13900005678','南食堂门口','麻烦提前十分钟发消息',0,'2026-11-24 16:05:36'),(17,'EM202611212150175222',13,3,1,39.00,'meetup','online','小张','13900005678','南食堂门口',NULL,3,'2026-11-24 16:05:36'),(18,'EM202611212207197680',25,1,3,45.00,'meetup','online','管理员','13800001234','图书馆一楼大厅','麻烦提前十分钟发消息',1,'2026-11-24 16:05:36'),(19,'EM202611212214112863',23,1,3,199.00,'meetup','online','管理员','13800001234','图书馆一楼大厅','麻烦提前十分钟发消息',1,'2026-11-24 16:05:36'),(20,'EM202611212218253598',22,1,3,69.00,'meetup','online','管理员','13800001234','图书馆一楼大厅',NULL,3,'2026-11-24 16:05:36'),(21,'EM202611241607415071',27,3,1,12.00,'dorm','online','小张','11232123','2栋一楼门卫处','',3,'2026-11-24 16:08:33');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL COMMENT '商品标题',
  `description` text COMMENT '商品描述',
  `price` decimal(10,2) NOT NULL COMMENT '价格',
  `image` varchar(255) DEFAULT NULL COMMENT '图片路径',
  `category_id` int DEFAULT NULL COMMENT '分类ID',
  `seller_id` int NOT NULL COMMENT '卖家ID',
  `status` int DEFAULT '0' COMMENT '0待售 / 1已售 / 2下架',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_seller_status` (`seller_id`,`status`),
  KEY `idx_status_update` (`status`,`update_time`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,'HUAWEI MateBook 14 鸿蒙版','14 英寸轻薄本，电池健康，含原装充电器，可校内验机。',5056.00,'HUAWEI_MateBook_14.png',1,3,1,'2026-11-24 16:05:51'),(9,'二手微波炉','二手微波炉，成色良好，可校内当面验货。',120.00,'HUAWEI_MateBook_14.png',1,1,1,'2026-11-24 16:05:36'),(10,'电热水壶','电热水壶，成色良好，可校内当面验货。',45.00,'HUAWEI_MateBook_14.png',3,1,0,'2026-11-24 16:05:36'),(11,'机械键盘','机械键盘，成色良好，可校内当面验货。',260.00,'HUAWEI_MateBook_14.png',1,3,1,'2026-11-24 16:05:36'),(12,'初音未来亚克力立牌','初音未来亚克力立牌，成色良好，可校内当面验货。',35.00,'HUAWEI_MateBook_14.png',3,3,1,'2026-11-24 16:05:36'),(13,'保温杯','保温杯，成色良好，可校内当面验货。',39.00,'HUAWEI_MateBook_14.png',1,1,1,'2026-11-24 16:05:36'),(14,'折叠雨伞','折叠雨伞，成色良好，可校内当面验货。',15.00,'HUAWEI_MateBook_14.png',1,1,1,'2026-11-24 16:05:36'),(15,'学生计算器','学生计算器，成色良好，可校内当面验货。',25.00,'HUAWEI_MateBook_14.png',3,1,1,'2026-11-24 16:05:36'),(16,'蓝牙音箱','蓝牙音箱，成色良好，可校内当面验货。',180.00,'HUAWEI_MateBook_14.png',1,3,1,'2026-11-24 16:05:36'),(17,'二手显示器','二手显示器，成色良好，可校内当面验货。',420.00,'HUAWEI_MateBook_14.png',2,1,0,'2026-11-24 16:05:36'),(18,'二手台灯','二手台灯，成色良好，可校内当面验货。',35.00,'HUAWEI_MateBook_14.png',3,3,1,'2026-11-24 16:04:08'),(19,'折叠书桌','折叠书桌，成色良好，可校内当面验货。',150.00,'HUAWEI_MateBook_14.png',2,3,1,'2026-11-24 16:05:36'),(20,'电脑椅','电脑椅，成色良好，可校内当面验货。',280.00,'HUAWEI_MateBook_14.png',1,3,1,'2026-11-24 16:05:36'),(21,'插线板','插线板，成色良好，可校内当面验货。',19.00,'HUAWEI_MateBook_14.png',4,3,1,'2026-11-24 16:05:36'),(22,'吹风机','吹风机，成色良好，可校内当面验货。',69.00,'115411842_p0.jpg',1,3,1,'2026-11-24 16:05:36'),(23,'行李箱','行李箱，成色良好，可校内当面验货。',199.00,'115411842_p0.jpg',1,3,1,'2026-11-24 16:05:36'),(24,'台历','台历，成色良好，可校内当面验货。',8.00,'139065783_p0_master1200.jpg',1,3,0,'2026-11-24 16:05:36'),(25,'瑜伽垫','瑜伽垫，成色良好，可校内当面验货。',45.00,'139065783_p0_master1200.jpg',1,3,1,'2026-11-24 16:05:36'),(26,'自行车锁','自行车锁，成色良好，可校内当面验货。',22.00,'115411842_p0.jpg',1,1,0,'2026-11-24 16:05:36'),(27,'校园卡套','校园卡套，成色良好，可校内当面验货。',12.00,'115411842_p0.jpg',5,1,1,'2026-11-24 16:07:41'),(28,'睫毛膏','睫毛膏，成色良好，可校内当面验货。',9.99,'seed/seed01.jpg',6,3,0,'2026-11-24 16:04:08'),(29,'带镜眼影盘','带镜眼影盘，成色良好，可校内当面验货。',19.99,'seed/seed02.jpg',6,3,0,'2026-11-24 16:04:08'),(30,'散粉','散粉，成色良好，可校内当面验货。',14.99,'seed/seed03.jpg',6,3,0,'2026-11-24 16:04:08'),(31,'红色口红','红色口红，成色良好，可校内当面验货。',12.99,'seed/seed04.jpg',6,3,0,'2026-11-24 16:04:08'),(32,'红色指甲油','红色指甲油，成色良好，可校内当面验货。',8.99,'seed/seed05.jpg',6,3,0,'2026-11-24 16:04:08'),(33,'CK One 香水','CK One 香水，成色良好，可校内当面验货。',49.99,'seed/seed06.jpg',6,3,0,'2026-11-24 16:04:08'),(34,'香奈儿可可小姐香水','香奈儿可可小姐香水，成色良好，可校内当面验货。',129.99,'seed/seed07.jpg',6,3,0,'2026-11-24 16:04:08'),(35,'迪奥真我香水','迪奥真我香水，成色良好，可校内当面验货。',89.99,'seed/seed08.jpg',6,3,0,'2026-11-24 16:04:08'),(36,'杜嘉班纳亮采香水','杜嘉班纳亮采香水，成色良好，可校内当面验货。',69.99,'seed/seed09.jpg',6,3,0,'2026-11-24 16:04:08'),(37,'古驰花悦香水','古驰花悦香水，成色良好，可校内当面验货。',79.99,'seed/seed10.jpg',6,3,0,'2026-11-24 16:04:08'),(38,'实木双人床','实木双人床，成色良好，可校内当面验货。',1899.99,'seed/seed11.jpg',3,3,0,'2026-11-24 16:04:08'),(39,'布艺沙发','布艺沙发，成色良好，可校内当面验货。',2499.99,'seed/seed12.jpg',3,3,0,'2026-11-24 16:04:08'),(40,'樱桃木床头柜','樱桃木床头柜，成色良好，可校内当面验货。',299.99,'seed/seed13.jpg',3,3,0,'2026-11-24 16:04:08'),(41,'办公椅','办公椅，成色良好，可校内当面验货。',499.99,'seed/seed14.jpg',3,3,0,'2026-11-24 16:04:08'),(42,'浴室镜柜','浴室镜柜，成色良好，可校内当面验货。',799.99,'seed/seed15.jpg',3,3,0,'2026-11-24 16:04:08'),(43,'苹果','苹果，成色良好，可校内当面验货。',1.99,'seed/seed16.jpg',7,3,0,'2026-11-24 16:04:08'),(44,'牛排','牛排，成色良好，可校内当面验货。',12.99,'seed/seed17.jpg',7,3,0,'2026-11-24 16:04:08'),(45,'猫粮','猫粮，成色良好，可校内当面验货。',8.99,'seed/seed18.jpg',7,3,0,'2026-11-24 16:04:08'),(46,'鸡胸肉','鸡胸肉，成色良好，可校内当面验货。',9.99,'seed/seed19.jpg',7,3,0,'2026-11-24 16:04:08'),(47,'食用油','食用油，成色良好，可校内当面验货。',4.99,'seed/seed20.jpg',7,3,0,'2026-11-24 16:04:08'),(48,'黄瓜','黄瓜，成色良好，可校内当面验货。',1.49,'seed/seed21.jpg',7,3,0,'2026-11-24 16:04:08'),(49,'狗粮','狗粮，成色良好，可校内当面验货。',10.99,'seed/seed22.jpg',7,3,0,'2026-11-24 16:04:08'),(50,'鸡蛋','鸡蛋，成色良好，可校内当面验货。',2.99,'seed/seed23.jpg',7,3,0,'2026-11-24 16:04:08'),(51,'鱼排','鱼排，成色良好，可校内当面验货。',14.99,'seed/seed24.jpg',7,3,0,'2026-11-24 16:04:08'),(52,'青椒','青椒，成色良好，可校内当面验货。',1.29,'seed/seed25.jpg',7,3,0,'2026-11-24 16:04:08'),(53,'尖椒','尖椒，成色良好，可校内当面验货。',0.99,'seed/seed26.jpg',7,3,0,'2026-11-24 16:04:08'),(54,'蜂蜜','蜂蜜，成色良好，可校内当面验货。',6.99,'seed/seed27.jpg',7,3,0,'2026-11-24 16:04:08'),(55,'冰淇淋','冰淇淋，成色良好，可校内当面验货。',5.49,'seed/seed28.jpg',7,3,0,'2026-11-24 16:04:08'),(56,'果汁','果汁，成色良好，可校内当面验货。',3.99,'seed/seed29.jpg',7,3,0,'2026-11-24 16:04:08'),(57,'猕猴桃','猕猴桃，成色良好，可校内当面验货。',2.49,'seed/seed30.jpg',7,3,0,'2026-11-24 16:04:08');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `rating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rating` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `order_id` int NOT NULL COMMENT '关联订单ID',
  `from_id` int NOT NULL COMMENT '评价人用户ID',
  `to_id` int NOT NULL COMMENT '被评价人用户ID',
  `score` int NOT NULL DEFAULT '5' COMMENT '评分：1~5 星',
  `content` text COMMENT '评价内容',
  `status` int NOT NULL DEFAULT '1' COMMENT '状态：0隐藏 / 1正常',
  `is_deleted` tinyint NOT NULL DEFAULT '0' COMMENT '软删除标记：0正常 / 1已删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_from` (`order_id`,`from_id`),
  KEY `idx_to_id` (`to_id`),
  KEY `fk_rating_from` (`from_id`),
  CONSTRAINT `fk_rating_from` FOREIGN KEY (`from_id`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_rating_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `fk_rating_to` FOREIGN KEY (`to_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='评价表';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `rating` WRITE;
/*!40000 ALTER TABLE `rating` DISABLE KEYS */;
INSERT INTO `rating` VALUES (1,6,1,3,5,'卖家发货很快，东西和描述一致',1,0,'2026-11-21 18:25:46','2026-11-21 18:25:46'),(2,6,3,1,4,'买家很好沟通',1,0,'2026-11-21 18:25:46','2026-11-21 18:25:46'),(3,8,1,3,4,'收到啦，包装很仔细，谢谢',1,0,'2026-11-21 19:06:03','2026-11-24 16:05:36'),(4,9,1,3,5,'东西不错',1,0,'2026-11-21 19:39:16','2026-11-21 19:39:16'),(5,9,3,1,5,'买家爽快',1,0,'2026-11-21 19:39:16','2026-11-21 19:39:16'),(6,10,1,3,4,'按约定时间到的，东西和描述一致',1,0,'2026-11-21 20:04:36','2026-11-24 16:05:36'),(7,11,1,3,5,'沟通很顺，交易愉快',1,0,'2026-11-21 20:15:02','2026-11-24 16:05:36'),(8,11,3,1,5,'好买家',1,0,'2026-11-21 20:15:02','2026-11-21 20:15:02'),(9,20,1,3,5,'交易顺利，人很好',1,0,'2026-11-21 22:18:25','2026-11-24 16:05:36'),(10,17,3,1,1,'商品有点小瑕疵，卖家提前说明了',1,0,'2026-11-21 23:31:59','2026-11-24 16:05:36');
/*!40000 ALTER TABLE `rating` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `reporter_id` int NOT NULL COMMENT '举报人用户ID',
  `target_type` int NOT NULL COMMENT '举报对象类型：1用户 / 2商品',
  `target_id` int NOT NULL COMMENT '举报对象ID，多态关联（由 target_type 区分）',
  `reason` text NOT NULL COMMENT '举报理由',
  `handle_status` int NOT NULL DEFAULT '0' COMMENT '处理进度：0待处理 / 1已处理 / 2已驳回',
  `status` int NOT NULL DEFAULT '1' COMMENT '状态：0无效 / 1有效',
  `is_deleted` tinyint NOT NULL DEFAULT '0' COMMENT '软删除标记：0正常 / 1已删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `handle_remark` varchar(255) DEFAULT NULL COMMENT '处理说明 / 驳回原因',
  PRIMARY KEY (`id`),
  KEY `idx_target` (`target_type`,`target_id`),
  KEY `idx_handle_status` (`handle_status`),
  KEY `fk_report_user` (`reporter_id`),
  CONSTRAINT `fk_report_user` FOREIGN KEY (`reporter_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='举报表';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `report` WRITE;
/*!40000 ALTER TABLE `report` DISABLE KEYS */;
INSERT INTO `report` VALUES (1,1,2,16,'描述和实物不太一样，想确认一下',1,1,0,'2026-11-21 18:26:58','2026-11-24 16:05:36','已联系双方核实，商品描述已补充'),(2,1,2,16,'收到商品与描述有出入，希望处理',2,1,0,'2026-11-21 19:02:52','2026-11-24 16:05:36','已下架并提醒卖家规范描述'),(3,1,2,18,'图片和实物颜色差距比较大',2,1,0,'2026-11-21 19:39:16','2026-11-24 16:05:36','已提醒卖家更换实拍图'),(4,1,2,19,'卖家一直没回复，申请介入',1,1,0,'2026-11-21 20:04:36','2026-11-24 16:05:36','卖家已回复，交易正常进行'),(5,1,2,20,'商品有明显使用痕迹但没有说明',2,1,0,'2026-11-21 20:15:02','2026-11-24 16:05:36','已要求卖家补充成色说明'),(6,1,2,9,'商品描述里用了不文明的词',2,1,0,'2026-11-21 20:56:19','2026-11-24 16:05:36','已修改描述并警告'),(7,3,2,10,'疑似重复发布了同一件商品',1,1,1,'2026-11-21 23:42:23','2026-11-24 16:05:51','已删除重复发布'),(8,3,2,26,'商品描述含有不当内容',2,1,0,'2026-11-22 00:47:27','2026-11-24 16:05:36','已下架处理'),(9,1,2,27,'商品描述信息不完整',1,1,0,'2026-11-24 15:58:44','2026-11-24 16:05:36','已核实，商品描述已补充'),(10,1,2,26,'举报内容与实物不符',2,1,0,'2026-11-24 15:59:31','2026-11-24 16:05:36','举报内容不成立，已核实');
/*!40000 ALTER TABLE `report` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(32) NOT NULL,
  `password` varchar(64) NOT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` int NOT NULL DEFAULT '1',
  `role` tinyint NOT NULL DEFAULT '0' COMMENT '角色：0普通用户 / 1管理员',
  `nickname` varchar(50) DEFAULT NULL COMMENT '昵称',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像路径',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  UNIQUE KEY `uk_phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'admin','admin','2026-11-17 09:13:28',1,1,'管理员',NULL,NULL),(3,'d','d','2026-11-20 16:46:58',1,0,'小张',NULL,NULL),(5,'testuser','123','2026-11-21 19:24:38',1,0,'小明',NULL,NULL),(6,'aaa','123123','2026-11-24 15:26:40',1,0,'阿乐','13125562424',NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
