# 回响市集 EchoMarket

回响市集是一个面向校园的 C2C 二手交易课程项目。买卖双方可以发布和浏览闲置商品、通过站内消息沟通，并记录下单到成交的过程。

## 已实现功能

| 模块 | 功能 |
| --- | --- |
| 账号 | 注册、登录、退出登录 |
| 资料 | 修改昵称、手机号和密码，上传头像 |
| 商品 | 选择分类、上传图片并发布闲置商品；浏览在售商品、查看详情，卖家可编辑或下架自己发布的商品 |
| 收藏 | 收藏、取消收藏和查看收藏列表 |
| 私信 | 围绕商品发起会话、发送消息、查看消息列表及已读状态 |
| 订单 | 下单，选择校内面交或宿舍配送；按买家和卖家分别查看、按状态筛选订单；买家确认支付、卖家发货、确认收货和取消订单 |
| 评价 | 交易完成后买卖双方互评，浏览用户评价与评分 |
| 举报 | 提交并查看自己的举报；管理员可标记处理或驳回，并填写处理说明 |

订单页面用于演示支付确认与状态流转，不涉及真实资金交易。

## 示例数据

初始化脚本分两部分：[`init.sql`](database/init.sql) 只建表，[`seed.sql`](database/seed.sql) 写入示例数据。示例数据包含 50 件商品、20 余笔订单、消息、评价和举报记录，账号有 `admin`（管理员）、`d`、`testuser` 三个，密码与用户名相同。商品图片来自公开商品示例接口，统一存放在 [`src/main/webapp/images/seed/`](src/main/webapp/images/seed)，名称和价格已整理为中文校园闲置风格。

## 技术栈与结构

- Java 21、Maven Wrapper、Tomcat 10.1，打包为 `echo-market.war`
- Jakarta Servlet 6、JSP 3.1、EL、JSTL 3；页面由服务端渲染
- MySQL 8、c3p0 连接池、Apache Commons DbUtils

```text
├── database/init.sql            # 建表脚本（空库结构）
├── database/seed.sql            # 示例数据
├── src/main/java/com/echomarket/
│   ├── servlet/                 # 路由、表单处理与页面跳转
│   ├── filter/                  # 登录检查
│   ├── dao/                     # 数据库访问与下单事务
│   └── entity/                  # 用户、商品、订单等实体
├── src/main/resources/          # 数据库连接配置模板
└── src/main/webapp/
    ├── index.jsp                # 新版市集入口
    ├── WEB-INF/views/           # 按业务划分的 JSP 视图（market/ 为新版市集）
    ├── WEB-INF/web.xml          # JSP 路径映射
    ├── css/                     # 页面样式
    ├── js/market/               # 新版交互与接口适配
    └── images/                  # 商品图片与演示素材
```

浏览器请求由 Servlet 接收。Servlet 通过 DAO 读写 MySQL，再把页面数据交给 JSP 渲染。下单时，数据库事务把检查商品状态、标记商品和创建订单放在一起，防止同一件商品被重复购买。

## 页面入口

部署 WAR 后从 `http://localhost:8080/echo-market/` 进入市集首页，[入口 JSP](src/main/webapp/index.jsp) 转发到市集视图。右上角可在亮色与暗色之间切换，主题选择保存在浏览器中。各业务页面需要登录后访问，登录页地址为 `http://localhost:8080/echo-market/login.jsp`。

## 本地运行

1. 准备 JDK 21、Tomcat 10.1 和 MySQL 8。
2. 把 [`database/init.sql`](database/init.sql) 和 [`database/seed.sql`](database/seed.sql) 依次导入本地演示库，再将 [`c3p0.properties.example`](src/main/resources/c3p0.properties.example) 复制为同目录下的 `c3p0.properties`，填写连接信息。脚本会重建 `echo_market` 下的同名表，不要用于已有业务数据的环境。
3. 在 Windows 运行 `mvnw.cmd clean package`，在 macOS 或 Linux 运行 `./mvnw clean package`。将生成的 `target/echo-market.war` 部署到 Tomcat 后，访问 `http://localhost:8080/echo-market/`（使用默认端口和部署路径时）。

## 许可证

[MIT License](LICENSE) · Copyright (c) 2026 Aznobin
