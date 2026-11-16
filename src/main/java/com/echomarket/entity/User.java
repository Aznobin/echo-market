package com.echomarket.entity;

import lombok.Data;

// 用户实体层：id、用户名、密码、创建日期、状态
@Data
public class User {

    private int id;
    private String username;
    private String password;
    private String createTime;
    private int status;

}
