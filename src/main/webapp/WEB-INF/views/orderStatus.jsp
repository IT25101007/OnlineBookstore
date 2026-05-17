<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Status - Online Bookstore</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@700;800;900&family=Plus+Jakarta+Sans:ital,wght@0,400;0,500;0,600;0,700;1,400&family=Noto+Sans+Sinhala:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark fixed-top">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/"><i class="fas fa-book-open me-2"></i>Online Bookstore</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"><span class="navbar-toggler-icon"></span></button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/"><i class="fas fa-home me-1"></i>Home</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/books"><i class="fas fa-book me-1"></i>Browse Books</a></li>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/cart"><i class="fas fa-shopping-cart me-1"></i>Cart</a></li>
                        <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/orders"><i class="fas fa-truck me-1"></i>Orders</a></li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown"><i class="fas fa-user-circle me-1"></i>${sessionScope.user.name}</a>
                            <ul class="dropdown-menu dropdown-menu-end glass-dark">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="fas fa-id-card me-2"></i>My Profile</a></li>
                                <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-chart-line me-2"></i>Admin Dashboard</a></li>
                                </c:if>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/login"><i class="fas fa-sign-in-alt me-1"></i>Login</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/register"><i class="fas fa-user-plus me-1"></i>Register</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>
<div style="height: 76px;"></div>
<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <h2 class="page-title fade-in-up"><i class="fas fa-chart-line me-3"></i>Order Status</h2>
            <c:if test="${empty order}">
                <div class="alert alert-warning"><i class="fas fa-exclamation-triangle me-2"></i>Order not found.</div>
                <a href="${pageContext.request.contextPath}/orders" class="btn btn-secondary"><i class="fas fa-arrow-left me-2"></i>Back to Orders</a>
            </c:if>
            <c:if test="${not empty order}">
                <div class="card shadow-lg border-0 mb-4 reveal">
                    <div class="card-body p-4">
                        <div class="status-timeline">
                            <div class="timeline-step ${order.status == 'PENDING' ? 'active current' : (order.status != 'CANCELLED' ? 'completed' : '')}">
                                <div class="timeline-icon"><i class="fas fa-shopping-cart"></i></div>
                                <div class="timeline-label">Placed</div>
                            </div>
                            <div class="timeline-line ${order.status == 'CONFIRMED' || order.status == 'DELIVERED' ? 'active' : ''}"></div>
                            <div class="timeline-step ${order.status == 'CONFIRMED' ? 'active current' : (order.status == 'DELIVERED' ? 'completed' : '')}">
                                <div class="timeline-icon"><i class="fas fa-check-circle"></i></div>
                                <div class="timeline-label">Confirmed</div>
                            </div>
                            <div class="timeline-line ${order.status == 'DELIVERED' ? 'active' : ''}"></div>
                            <div class="timeline-step ${order.status == 'DELIVERED' ? 'active current' : ''}">
                                <div class="timeline-icon"><i class="fas fa-box"></i></div>
                                <div class="timeline-label">Delivered</div>
                            </div>
                        </div>
                        <div class="text-center mt-4">
                            <c:choose>
                                <c:when test="${order.status == 'PENDING'}"><span class="badge-pending p-3 fs-6"><i class="fas fa-clock me-2"></i>PENDING — Awaiting Payment</span></c:when>
                                <c:when test="${order.status == 'CONFIRMED'}"><span class="badge-confirmed p-3 fs-6"><i class="fas fa-check-circle me-2"></i>CONFIRMED — Order Confirmed</span></c:when>
                                <c:when test="${order.status == 'DELIVERED'}"><span class="badge-delivered p-3 fs-6"><i class="fas fa-box-open me-2"></i>DELIVERED — Enjoy Your Book!</span></c:when>
                                <c:when test="${order.status == 'CANCELLED'}"><span class="badge-cancelled p-3 fs-6"><i class="fas fa-times-circle me-2"></i>CANCELLED</span></c:when>
                            </c:choose>
                        </div>
                    </div>
                </div>
                <div class="card shadow-lg border-0 reveal">
                    <div class="card-header bg-white"><h5 class="mb-0"><i class="fas fa-receipt me-2 text-primary"></i>Order Details</h5></div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <table class="table table-borderless">
                                    <tr><th style="width:40%;">Order ID:</th><td><code>${order.orderID}</code></td></tr>
                                    <tr><th>Book ID:</th><td>${order.bookID}</td></tr>
                                    <tr><th>Quantity:</th><td><strong>${order.quantity}</strong></td></tr>
                                </table>
                            </div>
                            <div class="col-md-6">
                                <table class="table table-borderless">
                                    <tr><th style="width:40%;">Total Amount:</th><td class="price fs-4">$${order.totalAmount}</td></tr>
                                    <tr><th>Status:</th><td>${order.status}</td></tr>
                                    <tr><th>Order Date:</th><td>${order.orderID.substring(3, 13)}</td></tr>
                                </table>
                            </div>
                        </div>
                        <div class="d-flex gap-3 mt-4">
                            <a href="${pageContext.request.contextPath}/orders" class="btn btn-secondary"><i class="fas fa-arrow-left me-2"></i>Back to Orders</a>
                            <c:if test="${order.status == 'PENDING' && sessionScope.user.role != 'ADMIN'}">
                                <a href="${pageContext.request.contextPath}/payment?orderID=${order.orderID}" class="btn btn-primary-custom"><i class="fas fa-credit-card me-2"></i>Pay Now</a>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</main>
<footer class="footer">
    <div class="container"><p>&copy; 2024 Online Bookstore Management System | SE1020 Project</p></div>
</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/bookstore.js"></script>
</body>
</html>