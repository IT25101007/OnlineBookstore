<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Invoice - Online Bookstore</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@700;800;900&family=Plus+Jakarta+Sans:ital,wght@0,400;0,500;0,600;0,700;1,400&family=Noto+Sans+Sinhala:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark fixed-top no-print">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/"><i class="fas fa-book-open me-2"></i>Online Bookstore</a>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/orders"><i class="fas fa-truck me-1"></i>Orders</a></li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown"><i class="fas fa-user-circle me-1"></i>${sessionScope.user.name}</a>
                    <ul class="dropdown-menu dropdown-menu-end"><li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li></ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div style="height: 76px;" class="no-print"></div>

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow-xl border-0 fade-in-up" style="border-radius:var(--r-xl);overflow:hidden;">
                <div class="invoice-header">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <div class="invoice-number">PAYMENT RECEIPT</div>
                            <h2 class="fw-bold mt-1 mb-0"><i class="fas fa-book-open me-2"></i>Online Bookstore</h2>
                        </div>
                        <div class="text-end">
                            <div class="invoice-number">PAYMENT ID</div>
                            <code style="color:rgba(255,255,255,0.9);font-size:0.85rem;">${payment.paymentID}</code>
                        </div>
                    </div>
                    <div class="invoice-total mt-4">${{ payment.amount != null ? "$" : "" }}${payment.amount}</div>
                    <div class="mt-1 opacity-75">Total Amount Paid</div>
                </div>

                <div class="card-body p-4">
                    <c:if test="${not empty sessionScope.paymentMessage}">
                        <div class="alert alert-success text-center mb-4"><i class="fas fa-check-circle me-2"></i><strong>${sessionScope.paymentMessage}</strong></div>
                        <% session.removeAttribute("paymentMessage"); %>
                    </c:if>

                    <div class="row mb-4">
                        <div class="col-md-6">
                            <p class="text-muted small mb-1">PAYMENT ID</p>
                            <p class="fw-bold"><code>${payment.paymentID}</code></p>
                            <p class="text-muted small mb-1">ORDER ID</p>
                            <p class="fw-bold"><code>${payment.orderID}</code></p>
                        </div>
                        <div class="col-md-6 text-md-end">
                            <p class="text-muted small mb-1">DATE</p>
                            <p class="fw-bold">${payment.date}</p>
                            <p class="text-muted small mb-1">STATUS</p>
                            <p><span class="badge-confirmed px-3 py-2">${payment.status}</span></p>
                        </div>
                    </div>

                    <div class="glass-card p-4 mb-4">
                        <h5 class="mb-3"><i class="fas fa-credit-card me-2 text-primary"></i>Payment Details</h5>
                        <table class="table table-borderless mb-0">
                            <tr><th style="width:40%;">Amount Paid:</th><td class="price fs-3">$${payment.amount}</td></tr>
                            <tr><th>Payment Method:</th><td><i class="fas ${payment.method == 'CREDIT_CARD' ? 'fa-credit-card' : 'fa-paypal'} me-2"></i>${payment.method}</td></tr>
                            <c:if test="${payment.method == 'CREDIT_CARD'}"><tr><th>Card Last Four:</th><td><strong>**** **** **** ${payment.cardLastFour}</strong></td></tr></c:if>
                            <c:if test="${payment.method == 'PAYPAL'}"><tr><th>PayPal Email:</th><td>${payment.paypalEmail}</td></tr></c:if>
                        </table>
                    </div>

                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i><strong>Confirmation: </strong>
                        <c:choose>
                            <c:when test="${payment.method == 'CREDIT_CARD'}">Processing credit card ending in ${payment.cardLastFour}</c:when>
                            <c:otherwise>Processing PayPal payment for ${payment.paypalEmail}</c:otherwise>
                        </c:choose>
                    </div>

                    <div class="d-flex gap-3 justify-content-between mt-4">
                        <button onclick="window.print()" class="btn btn-primary-custom no-print"><i class="fas fa-print me-2"></i>Print Receipt</button>
                        <a href="${pageContext.request.contextPath}/orders" class="btn btn-secondary no-print"><i class="fas fa-arrow-left me-2"></i>Back to Orders</a>
                    </div>

                    <hr class="mt-4">
                    <p class="text-center text-muted small mt-3">
                        <i class="fas fa-shield-alt me-1"></i>Computer-generated receipt. No signature required.<br>
                        For inquiries: support@onlinebookstore.com
                    </p>
                </div>
            </div>
        </div>
    </div>
</main>

<footer class="footer no-print">
    <div class="container"><p>&copy; 2024 Online Bookstore Management System | SE1020 Project</p></div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/bookstore.js"></script>
</body>
</html>