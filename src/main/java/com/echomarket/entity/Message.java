package com.echomarket.entity;

import lombok.Data;

@Data
// 商品消息实体类
public class Message {
    private Integer id;
        private Integer fromId;
        private Integer toId;
        private Integer productId;
        private String content;
        private Integer isRead;
        private Integer status;
        private java.sql.Timestamp createTime;
        private String fromName;
        private String toName;
        private String productTitle;
        private Integer otherId;
        private String otherName;
}
