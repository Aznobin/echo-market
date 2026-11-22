<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Echo Market - 确认订单</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/orderbuyerinfo.css">
</head>
<body>
<main class="checkout-container">
    <div class="checkout-topbar">
        <a class="back-link" href="${pageContext.request.contextPath}/productdetail?id=${product.id}">← 返回商品详情</a>
        <div class="step-indicator">
            <span class="step done">1. 选择商品</span>
            <span class="step-sep">›</span>
            <span class="step active">2. 填写交易信息</span>
            <span class="step-sep">›</span>
            <span class="step">3. 立即购买</span>
        </div>
    </div>

    <c:if test="${not empty msg}">
        <div class="alert-msg">${msg}</div>
    </c:if>

    <c:choose>
        <c:when test="${not empty product}">
            <form class="checkout-layout" id="orderForm" action="${pageContext.request.contextPath}/orderadd" method="post">
                <input type="hidden" name="productId" value="${product.id}">

                <!-- 左侧：交易与收货信息填写区 -->
                <div class="checkout-main">
                    <section class="panel">
                        <div class="panel-header">
                            <h2 class="panel-title">交接与收货信息</h2>
                        </div>

                        <div class="form-group">
                            <label class="form-label">交易方式 <span class="req">*</span></label>
                            <div class="radio-cards">
                                <label class="radio-card">
                                    <input type="radio" name="deliveryType" value="meetup" checked>
                                    <span class="radio-card-body">
                                        <strong>校内当面交易</strong>
                                        <small>约定教学楼、图书馆或食堂门口验货交接</small>
                                    </span>
                                </label>
                                <label class="radio-card">
                                    <input type="radio" name="deliveryType" value="dorm">
                                    <span class="radio-card-body">
                                        <strong>送货到宿舍楼下</strong>
                                        <small>由卖家配送至指定宿舍楼栋门禁处</small>
                                    </span>
                                </label>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label" for="receiverName">联系人称呼 <span class="req">*</span></label>
                                <input class="form-input"
                                       id="receiverName"
                                       type="text"
                                       name="receiverName"
                                       required
                                       maxlength="30"
                                       value="${sessionScope.user.username}"
                                       placeholder="请输入联系人姓名或昵称">
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="phone">联系电话 / 微信号 <span class="req">*</span></label>
                                <input class="form-input"
                                       id="phone"
                                       type="text"
                                       name="phone"
                                       required
                                       maxlength="30"
                                       placeholder="方便卖家联系交接（必填）">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="address">校内交接 / 收货地址 <span class="req">*</span></label>
                            <input class="form-input"
                                   id="address"
                                   type="text"
                                   name="address"
                                   required
                                   maxlength="120"
                                   placeholder="例如：南校区竹园 3 栋楼下 / 图书馆一楼大厅（必填）">
                        </div>
                    </section>

                    <section class="panel">
                        <div class="panel-header">
                            <h2 class="panel-title">支付方式与补充说明</h2>
                        </div>

                        <div class="form-group">
                            <label class="form-label">支付方式 <span class="req">*</span></label>
                            <div class="radio-inline-group">
                                <label class="radio-pill">
                                    <input type="radio" name="payMethod" value="online" checked>
                                    <span>在线担保支付</span>
                                </label>
                                <label class="radio-pill">
                                    <input type="radio" name="payMethod" value="cod">
                                    <span>当面验货付款</span>
                                </label>
                            </div>
                        </div>

                        <div class="form-group no-margin">
                            <label class="form-label" for="remark">订单备注（选填）</label>
                            <textarea class="form-textarea"
                                      id="remark"
                                      name="remark"
                                      rows="3"
                                      maxlength="200"
                                      placeholder="填写方便交接的时间段或其他补充说明..."></textarea>
                        </div>
                    </section>
                </div>

                <!-- 右侧：商品清单与结算汇总栏 -->
                <aside class="checkout-sidebar">
                    <div class="summary-card">
                        <h2 class="summary-title">订单商品清单</h2>

                        <div class="summary-product">
                            <c:choose>
                                <c:when test="${not empty product.image}">
                                    <img class="summary-thumb"
                                         src="${pageContext.request.contextPath}/images/${product.image}"
                                         alt="${product.title}">
                                </c:when>
                                <c:otherwise>
                                    <div class="summary-thumb-empty">无图</div>
                                </c:otherwise>
                            </c:choose>

                            <div class="summary-product-meta">
                                <div class="summary-product-name" title="${product.title}">${product.title}</div>
                                <div class="summary-product-sub">商品编号：#${product.id}</div>
                                <div class="summary-product-sub">卖家 ID：#${product.sellerId}</div>
                            </div>
                        </div>

                        <div class="summary-divider"></div>

                        <div class="fee-list">
                            <div class="fee-row">
                                <span>商品单价</span>
                                <span>¥ ${product.price}</span>
                            </div>
                            <div class="fee-row">
                                <span>购买数量</span>
                                <span>× 1</span>
                            </div>
                            <div class="fee-row">
                                <span>校内配送 / 交接费</span>
                                <span class="fee-free">¥ 0.00</span>
                            </div>
                        </div>

                        <div class="summary-divider"></div>

                        <div class="total-row">
                            <span class="total-label">应付总额</span>
                            <span class="total-amount">¥ ${product.price}</span>
                        </div>

                        <div class="summary-actions">
                            <c:choose>
                                <c:when test="${product.status == 0}">
                                    <button class="btn btn-primary btn-block" type="button" onclick="showConfirm()">立即购买</button>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-disabled btn-block" type="button" disabled>商品已售出或下架</button>
                                </c:otherwise>
                            </c:choose>
                            <a class="btn btn-secondary btn-block" href="${pageContext.request.contextPath}/products">取消并返回列表</a>
                        </div>

                        <p class="safety-note">提示：请尽量在校园公共区域当面验货后确认交易。</p>
                    </div>
                </aside>
            </form>
        </c:when>
        <c:otherwise>
            <div class="empty-box">
                <p class="empty-msg">未找到可购买的商品信息。</p>
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/products">返回商品列表</a>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<div class="confirm-mask" id="confirmMask">
    <div class="confirm-box">
        <h3 class="confirm-title">确认购买</h3>
        <p class="confirm-text">确认以 ¥ ${product.price} 立即购买「${product.title}」吗？</p>
        <div class="confirm-actions">
            <button class="btn btn-plain" type="button" onclick="hideConfirm()">再想想</button>
            <button class="btn btn-primary" type="button" onclick="doSubmit()">确认购买</button>
        </div>
    </div>
</div>

<script>
    function showConfirm() {
        document.getElementById("confirmMask").style.display = "flex";
    }

    function hideConfirm() {
        document.getElementById("confirmMask").style.display = "none";
    }

    function doSubmit() {
        document.getElementById("orderForm").submit();
    }
</script>
</body>
</html>