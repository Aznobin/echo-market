
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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
