package com.echomarket.entity;

import lombok.Data;

@Data
// 添加收藏的实体类
public class Favorite {
    private Integer id;
        private Integer userId;
        private Integer productId;
        private Integer status;
        private java.sql.Timestamp createTime;
        private String productTitle;
        private java.math.BigDecimal productPrice;
        private String productImage;
        private Integer productStatus;
}
