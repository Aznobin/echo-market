# 回响市集 EchoMarket

回响市集是一个面向校园的 C2C 二手交易课程项目。买卖双方可以发布和浏览闲置商品、通过站内消息沟通，并记录下单到成交的过程。

## 已实现功能

| 模块 | 功能 |
| --- | --- |
| 账号 | 注册、登录、退出登录 |
| 商品 | 选择分类、上传图片并发布闲置商品；浏览在售商品和查看详情 |
| 收藏 | 收藏、取消收藏和查看收藏列表 |
| 私信 | 围绕商品发起会话、发送消息、查看消息列表及已读状态 |
| 订单 | 下单，选择校内面交或宿舍配送；按买家和卖家分别查看、按状态筛选订单；发货、确认收货和取消订单 |
| 评价 | 交易完成后买卖双方互评，浏览用户评价与评分 |
| 举报 | 提交并查看自己的举报；管理员查看举报并更新处理状态 |

订单页面演示付款和订单状态流转，不涉及真实资金交易。

## 技术栈与结构

- Java 21、Maven Wrapper、Tomcat 10.1，打包为 `echo-market.war`
- Jakarta Servlet 6、JSP 3.1、EL、JSTL 3；页面由服务端渲染
- MySQL 8、c3p0 连接池、Apache Commons DbUtils

```text
├── database/init.sql            # 建表及演示数据
├── src/main/java/com/echomarket/
│   ├── servlet/                 # 路由、表单处理与页面跳转
│   ├── filter/                  # 登录检查
│   ├── dao/                     # 数据库访问与下单事务
│   └── entity/                  # 用户、商品、订单等实体
├── src/main/resources/          # 数据库连接配置模板
└── src/main/webapp/
    ├── WEB-INF/views/           # 按业务划分的 JSP 视图
    ├── WEB-INF/web.xml          # JSP 路径映射
    ├── css/
    └── images/
```

浏览器请求由 Servlet 接收。Servlet 通过 DAO 读写 MySQL，再把页面数据交给 JSP 渲染。下单时，数据库事务把检查商品状态、标记商品和创建订单放在一起，防止同一件商品被重复购买。

## 静态 UI 样板

直接双击仓库根目录的 [`index.html`](index.html) 即可预览全部界面。样板只使用 HTML、CSS、原生 JavaScript 和本地图片，不需要联网、安装依赖或启动 Tomcat。默认是亮色，右上角可切换暗色；浏览器允许本地存储时会记住选择和演示操作。

默认以演示账号 `xiaoman` 浏览。头像菜单可打开举报处理或切换账号；例如用 `tang` 登录后，可以体验示例卖出订单（`xiaoman`）对应的买家视角。登录表单可填写任意示例密码，请不要填写真实凭据或联系方式。样板不连接 Servlet、数据库或支付服务，原 Java 项目不受影响。

示例商品照片来自 [Unsplash](https://unsplash.com/license)，笔记本和明信片图片沿用原项目素材。

## 本地运行

1. 准备 JDK 21、Tomcat 10.1 和 MySQL 8。将 [`database/init.sql`](database/init.sql) 导入独立的本地演示库；脚本会重建 `echo_market` 下的同名表，不要对已有业务数据的环境执行。
2. 将 [`c3p0.properties.example`](src/main/resources/c3p0.properties.example) 复制为同目录下的 `c3p0.properties`，填写本地数据库连接信息。
3. 在 Windows 运行 `mvnw.cmd package`，在 macOS 或 Linux 运行 `./mvnw package`。将生成的 `target/echo-market.war` 部署到 Tomcat 后，访问 `http://localhost:8080/echo-market/`（使用默认端口和部署路径时）。

## 许可证

[MIT License](LICENSE) · Copyright (c) 2026 Aznobin
