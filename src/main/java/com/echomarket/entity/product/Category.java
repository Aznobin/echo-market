package com.echomarket.entity.product;

import lombok.Data;

@Data
// 商品分类实体类
public class Category {
    private Integer id;
        private String name;
        private Integer parentId;
        private Integer sort;
        private Integer status;
}
