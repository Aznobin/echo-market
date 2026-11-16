package com.echomarket.entity;

/** 用户：id、用户名、密码、创建日期、状态 */
public class User {

    private int id;
    private String username;
    private String password;
    private String createTime;
    private int status;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getCreateTime() { return createTime; }
    public void setCreateTime(String createTime) { this.createTime = createTime; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }
}
