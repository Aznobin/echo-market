package com.echomarket.entity;

import lombok.Data;

@Data
// 订单实体类
public class Order {
    private Integer id;
        private String orderNo;
        private Integer productId;
        private Integer buyerId;
        private Integer sellerId;
        private java.math.BigDecimal amount;
        private String deliveryType;
        private String payMethod;
        private String receiverName;
        private String phone;
        private String address;
        private String remark;
        private Integer status;
        private java.time.LocalDateTime updateTime;
        private String productTitle;
        private String productImage;
        private String buyerName;
        private String sellerName;
}
