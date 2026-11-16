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
