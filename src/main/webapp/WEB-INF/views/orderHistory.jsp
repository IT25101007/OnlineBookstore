<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - Online Bookstore</title>
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
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
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
    <h2 class="page-title fade-in-up"><i class="fas fa-truck me-3"></i>My Orders</h2>

    <c:if test="${not empty param.success}">
        <div class="alert alert-success alert-dismissible fade show">
            <i class="fas fa-check-circle me-2"></i>Order placed successfully!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${empty orders}">
        <div class="empty-state reveal">
            <div class="empty-state-icon"><i class="fas fa-box-open"></i></div>
            <h4>No orders yet</h4>
            <p>Start shopping to see your orders here!</p>
            <a href="${pageContext.request.contextPath}/books" class="btn btn-primary-custom mt-3">
                <i class="fas fa-search me-2"></i>Browse Books
            </a>
        </div>
    </c:if>

    <c:if test="${not empty orders}">
        <div class="row">
            <c:forEach var="order" items="${orders}" varStatus="status">
                <div class="col-12 mb-4">
                    <div class="card shadow-sm border-0 reveal stagger-${(status.index % 3) + 1}" style="border-radius:var(--r-lg); overflow:hidden;">
                        <div class="card-header bg-white d-flex justify-content-between align-items-center flex-wrap py-3">
                            <div>
                                <i class="fas fa-receipt text-primary me-2"></i>
                                <strong>Order #${order.orderID}</strong>
                                <small class="text-muted ms-2">${order.orderID.substring(3)}</small>
                            </div>
                            <div>
                                <c:choose>
                                    <c:when test="${order.status == 'PENDING'}"><span class="badge-pending"><i class="fas fa-clock me-1"></i>PENDING</span></c:when>
                                    <c:when test="${order.status == 'CONFIRMED'}"><span class="badge-confirmed"><i class="fas fa-check-circle me-1"></i>CONFIRMED</span></c:when>
                                    <c:when test="${order.status == 'CANCELLED'}"><span class="badge-cancelled"><i class="fas fa-times-circle me-1"></i>CANCELLED</span></c:when>
                                    <c:when test="${order.status == 'DELIVERED'}"><span class="badge-delivered"><i class="fas fa-box me-1"></i>DELIVERED</span></c:when>
                                </c:choose>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-3 mb-2">
                                    <small class="text-muted d-block">Book ID</small>
                                    <code>${order.bookID}</code>
                                </div>
                                <div class="col-md-2 mb-2">
                                    <small class="text-muted d-block">Quantity</small>
                                    <strong>x${order.quantity}</strong>
                                </div>
                                <div class="col-md-3 mb-2">
                                    <small class="text-muted d-block">Total Amount</small>
                                    <div class="price">$${order.totalAmount}</div>
                                </div>
                                <div class="col-md-4 mb-2 text-md-end">
                                    <a href="${pageContext.request.contextPath}/order/status?orderID=${order.orderID}"
                                       style="display:inline-block;background:#6c63ff;color:#fff !important;border:none;border-radius:8px;padding:6px 14px;font-weight:600;text-decoration:none;font-size:.875rem;">
                                        <i class="fas fa-eye me-1"></i>View Details
                                    </a>
                                    <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                        <form action="${pageContext.request.contextPath}/order/update" method="post" class="d-inline ms-2">
                                            <input type="hidden" name="orderID" value="${order.orderID}">
                                            <select name="status" class="form-select form-select-sm d-inline w-auto" onchange="this.form.submit()">
                                                <option value="PENDING" ${order.status == 'PENDING' ? 'selected' : ''}>PENDING</option>
                                                <option value="CONFIRMED" ${order.status == 'CONFIRMED' ? 'selected' : ''}>CONFIRMED</option>
                                                <option value="DELIVERED" ${order.status == 'DELIVERED' ? 'selected' : ''}>DELIVERED</option>
                                                <option value="CANCELLED" ${order.status == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                                            </select>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/order/delete" method="post" class="d-inline ms-2" data-confirm="Delete this order permanently?">
                                            <input type="hidden" name="orderID" value="${order.orderID}">
                                            <button type="submit" class="btn btn-sm btn-danger"><i class="fas fa-trash"></i></button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>
</main>

<footer class="footer">
    <div class="container"><p>&copy; 2024 Online Bookstore Management System | SE1020 Project</p></div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/bookstore.js"></script>
</body>
</html>