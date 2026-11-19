# 回响市集 EchoMarket

## 项目介绍

回响市集（echo-market）是一个基于 Servlet + JSP 的 C2C（个人对个人）二手交易平台，旨在帮助用户发布闲置物品、寻找所需商品，让闲置资源得到再次利用。

用户既可以作为卖家发布商品，也可以作为买家浏览商品、提交订单。

## 项目作用

- 为个人闲置物品提供集中展示和交易的平台
- 通过商品分类与搜索，帮助用户查找所需物品
- 通过订单管理，记录买卖双方的交易情况
- 作为 Java Web 学习实践项目，练习 MVC 分层、数据库访问与业务流程设计

## 计划功能

- 用户注册、登录及个人信息管理
- 商品发布、编辑、下架与搜索
- 下单及买卖双方订单管理
- 管理员对用户和商品的基础管理

## 技术架构

采用 MVC 模式，并按职责划分各层：

| 层级 | 技术 | 职责 |
| --- | --- | --- |
| 视图层 | JSP + EL + JSTL | 页面展示与数据渲染 |
| 控制层 | Servlet | 接收请求、调用业务、页面跳转 |
| 业务层 | Service | 处理商品、订单等业务逻辑 |
| 数据访问层 | DAO + commons-dbutils | 执行数据库操作 |
| 连接池 | c3p0 | 数据库连接管理 |
| 数据库 | MySQL | 存储用户、商品和订单数据 |

运行容器采用 Tomcat。

## 版本与依赖

| 项 | 版本 |
| --- | --- |
| JDK | Temurin 25.0.5 |
| 构建工具 | Maven |
| Servlet 容器 | Tomcat 10.1.59 |
| Servlet / JSP | Jakarta Servlet 6.0 / JSP 3.1（Jakarta EE 10） |
| 数据库 | MySQL 8 |
| 连接池 | c3p0 0.9.5.5 |
| 数据访问 | commons-dbutils 1.7 |

工程标识：Group `com.echomarket`，Artifact `echo-market`，打包方式 `war`。

## 目录结构

```text
src/main/
├── java/
│   └── com/echomarket/
│       ├── controller/   # Servlet
│       ├── service/      # 业务逻辑
│       ├── dao/          # 数据库访问
│       └── model/        # 实体类
├── resources/            # 配置文件
└── webapp/
    ├── static/           # CSS、JS、图片
    └── WEB-INF/
        └── views/        # JSP 页面
```

## 请求流程

```text
浏览器 → Servlet → Service → DAO → MySQL
           ↓
       JSP 渲染页面 → 浏览器
```
