create database if not exists echo_market default charset utf8mb4;
use echo_market;

create table if not exists `user` (
  `id`          int          not null auto_increment,
  `username`    varchar(32)  not null,
  `password`    varchar(64)  not null,
  `create_time` datetime     not null default current_timestamp,
  `status`      int          not null default 1,
  primary key (`id`),
  unique key `uk_username` (`username`)
) engine=innodb default charset=utf8mb4;

CREATE TABLE IF NOT EXISTS `product` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(100) NOT NULL COMMENT '商品标题',
    `description` TEXT COMMENT '商品描述',
    `price` DECIMAL(10,2) NOT NULL COMMENT '价格',
    `image` VARCHAR(255) COMMENT '图片路径',
    `category_id` INT COMMENT '分类ID',
    `seller_id` INT NOT NULL COMMENT '卖家ID',
    `status` INT DEFAULT 0 COMMENT '0待售 / 1已售 / 2下架',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `orders` (
                                        `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                                        `order_no` VARCHAR(50) NOT NULL COMMENT '订单编号',
                                        `product_id` INT NOT NULL COMMENT '商品ID',
                                        `buyer_id` INT NOT NULL COMMENT '买家用户ID',
                                        `seller_id` INT NOT NULL COMMENT '卖家用户ID',
                                        `amount` DECIMAL(10, 2) NOT NULL COMMENT '订单金额',
                                        `delivery_type` VARCHAR(20) NOT NULL DEFAULT 'meetup' COMMENT '交易方式：meetup校内面交 / dorm宿舍配送',
                                        `pay_method` VARCHAR(20) NOT NULL DEFAULT 'online' COMMENT '支付方式：online在线担保支付 / cod当面验货付款',
                                        `receiver_name` VARCHAR(50) NOT NULL COMMENT '联系人称呼',
                                        `phone` VARCHAR(20) NOT NULL COMMENT '联系电话或微信号',
                                        `address` VARCHAR(120) NOT NULL COMMENT '校内交接或收货地址',
                                        `remark` VARCHAR(200) DEFAULT NULL COMMENT '订单备注',
                                        `status` INT NOT NULL DEFAULT 0 COMMENT '订单状态：0待付款 / 1已付款 / 2已发货 / 3已完成 / 4已取消',
                                        `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                        PRIMARY KEY (`id`),
                                        UNIQUE KEY `uk_order_no` (`order_no`),
                                        KEY `idx_product_id` (`product_id`),
                                        KEY `idx_buyer_id` (`buyer_id`),
                                        KEY `idx_seller_id` (`seller_id`),
                                        CONSTRAINT `fk_orders_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
                                        CONSTRAINT `fk_orders_buyer` FOREIGN KEY (`buyer_id`) REFERENCES `user` (`id`),
                                        CONSTRAINT `fk_orders_seller` FOREIGN KEY (`seller_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';