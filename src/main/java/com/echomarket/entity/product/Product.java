package com.echomarket.entity.product;

import lombok.Data;

@Data
// 商品实体类
public class Product {
    private Integer id;
        private String title;
        private String description;
        private java.math.BigDecimal price;
        private String image;
        private Integer categoryId;
        private Integer sellerId;
        private Integer status;
        private java.sql.Timestamp updateTime;
}
