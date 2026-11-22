package com.echomarket.entity.account;

import lombok.Data;

@Data
public class User {
    private int id;
    private String username;
    private String password;
    private String nickname;
    private String phone;
    private String avatar;
    private String createTime;
    private int status;
    private int role;

}
