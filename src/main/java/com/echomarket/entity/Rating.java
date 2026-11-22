package com.echomarket.entity;

import lombok.Data;

@Data
// 订单评价实体类
public class Rating {
    private Integer id;
        private Integer orderId;
        private Integer fromId;
        private Integer toId;
        private Integer score;
        private String content;
        private Integer status;
        private java.sql.Timestamp createTime;
        private String fromName;
        private String toName;
        private String orderNo;
}
