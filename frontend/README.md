# 回响市集前端接口

A 版挂在 [`src/main/webapp/index.jsp`](../src/main/webapp/index.jsp)，由 Tomcat 渲染 [市集视图](../src/main/webapp/WEB-INF/views/market/home.jsp)。业务数据由浏览器里的模拟适配器提供，不调用真实后端接口。

## 从哪里接入

- [`fixtures.js`](../src/main/webapp/js/market/fixtures.js)：无真实账号的演示数据。
- [`mock-api.js`](../src/main/webapp/js/market/mock-api.js)：本机模拟适配器，管理演示状态；保存失败时继续在内存中运行。它不保存表单密码。
- [`api.js`](../src/main/webapp/js/market/api.js)：检查适配器是否提供当前界面使用的方法。
- [`bootstrap.js`](../src/main/webapp/js/market/bootstrap.js)：唯一装配入口，当前只装配模拟适配器。页面代码通过 `window.echoMarket` 消费接口，不直接读写业务数据。

## 页面依赖的接口

| 模块 | 查询 | 操作 |
| --- | --- | --- |
| 账号 | `currentId()` → 用户标识或 `null`；`find(id)` → `{ username, nickname, avatarUrl?, admin? }` 或 `null` | `login({ username, password })`、`register({ username, nickname, password, confirmPassword })`、`logout()` |
| 商品 | `categories()` → 按分类编号排列的标签；`list({ availableOnly })` / `find(id)` → 商品列表或单件商品 | `publish({ title, price, categoryId, image, description })` → 新商品 |
| 收藏 | `ids()` → 当前账号的商品标识列表 | `toggle(productId)` → 收藏后是否选中 |
| 消息 | `list()` → 当前账号的会话列表；`canOpen(otherId, productId)` → 是否可打开；`open(otherId, productId)` → 会话并处理演示已读 | `send({ otherId, productId, content })` → 新消息 |
| 订单 | `list('buyer' 或 'seller')`、`find(id)` → 当前账号的订单 | `create({ productId, receiverName, phone, address, remark, deliveryType, payMethod })`；`transition(id, 'pay' 或 'ship' 或 'confirm' 或 'cancel')` → 更新后的订单 |
| 评价 | `forUser(id)`、`forOrder(id)` → 评价列表 | `create({ orderId, score, content })` → 新评价 |
| 举报 | `list(admin)` → 当前账号的举报，或管理员处理列表 | `create({ targetType, targetId, reason })`、`handle(id, status)` → 更新后的举报 |

标识符在前端统一为字符串。查询返回值是快照，调用方不修改数据源；会修改业务状态的方法成功时返回 `{ value, persisted }`，失败则抛出带 `code` 的错误。本地 `persisted` 只说明浏览器是否存下了演示状态，不代表服务器写入。订单状态沿用样板的 0 待付款、1 待发货、2 待收货、3 已完成、4 已取消；这里没有真实支付。

以上是**前端调用契约，不是已经存在的 HTTP API**。当前适配器是同步的。接真实后端时，先约定会话、错误、图片上传和分页；把请求放在适配层，并将直接读取的数据改为异步加载或读取已加载缓存。价格、订单权限、会话参与者和管理员权限最终由服务端校验，不能依赖前端模拟校验。头像预留 `avatarUrl`，本轮不做上传。

## 验证

从仓库根目录运行 `node --test tests/frontend/*.test.cjs`。这组测试不启动 Tomcat、不访问数据库，也不使用 CDP；要确认 JSP 和静态资源能从 WAR 载入，应另用 Tomcat 访问项目首页。
