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