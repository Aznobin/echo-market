package com.echomarket.entity;

import lombok.Data;

@Data
// 举报信息实体类
public class Report {
    private Integer id;
        private Integer reporterId;
        private Integer targetType;
        private Integer targetId;
        private String reason;
        private Integer handleStatus;
        private Integer status;
        private java.sql.Timestamp createTime;
        private String reporterName;
        private String targetTitle;
}
