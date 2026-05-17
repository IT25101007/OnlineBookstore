<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - Online Bookstore</title>
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
                        <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/cart"><i class="fas fa-shopping-cart me-1"></i>Cart</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/orders"><i class="fas fa-truck me-1"></i>Orders</a></li>
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
    <h2 class="page-title fade-in-up"><i class="fas fa-shopping-cart me-3"></i>Your Shopping Cart</h2>

    <c:if test="${empty cartItems}">
        <div class="empty-state reveal">
            <div class="empty-state-icon"><i class="fas fa-shopping-cart"></i></div>
            <h4>Your cart is empty</h4>
            <p>Browse our collection and add some books to your cart!</p>
            <a href="${pageContext.request.contextPath}/books" class="btn btn-primary-custom mt-3"><i class="fas fa-search me-2"></i>Browse Books</a>
        </div>
    </c:if>

    <c:if test="${not empty cartItems}">
        <div class="row">
            <div class="col-lg-8 mb-4">
                <div class="card shadow-sm border-0 reveal">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table align-middle mb-0">
                                <thead class="table-light">
                                    <tr><th>Book</th><th>Price</th><th>Quantity</th><th>Subtotal</th><th></th></tr>
                                </thead>
                                <tbody>
                                <c:forEach var="item" items="${cartItems}">
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="book-cover-area me-3" style="width:50px;height:50px;border-radius:var(--r-sm);flex-shrink:0;">
                                                    <i class="fas fa-book" style="font-size:1.2rem;"></i>
                                                </div>
                                                <div>
                                                    <strong>${item.book.title}</strong><br>
                                                    <small class="text-muted">by ${item.book.author}</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="fw-bold">$${item.book.price}</td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/cart/update" method="post" class="d-inline">
                                                <input type="hidden" name="cartID" value="${item.cart.cartID}">
                                                <div class="quantity-stepper">
                                                    <button type="button" onclick="updateQuantity(this, -1)">-</button>
                                                    <input type="number" name="quantity" class="quantity-input text-center" value="${item.cart.quantity}" min="1" max="${item.book.stock}" onchange="this.form.submit()">
                                                    <button type="button" onclick="updateQuantity(this, 1)">+</button>
                                                </div>
                                            </form>
                                        </td>
                                        <td class="fw-bold price">$${item.subtotal}</td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/cart/remove" method="post">
                                                <input type="hidden" name="cartID" value="${item.cart.cartID}">
                                                <button type="submit" class="btn btn-sm btn-danger" data-confirm="Remove this item from cart?"><i class="fas fa-trash"></i></button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="mt-3">
                    <a href="${pageContext.request.contextPath}/books" class="btn-back d-inline-flex">
                        <i class="fas fa-arrow-left"></i> Continue Shopping
                    </a>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="cart-summary reveal">
                    <h5 class="mb-3"><i class="fas fa-receipt me-2"></i>Order Summary</h5>
                    <hr style="opacity:0.2;">
                    <div class="d-flex justify-content-between mb-2"><span>Subtotal:</span><strong>$${cartTotal}</strong></div>
                    <div class="d-flex justify-content-between mb-2"><span>Shipping:</span><strong>Free</strong></div>
                    <hr style="opacity:0.2;">
                    <div class="d-flex justify-content-between mb-4"><span class="fs-5">Total:</span><strong class="fs-4">$${cartTotal}</strong></div>
                    <form action="${pageContext.request.contextPath}/order/place" method="post" data-loading="true">
                        <button type="submit" class="btn w-100 fw-bold py-2" style="background:linear-gradient(135deg,#6c63ff,#a78bfa);color:#fff;border:none;border-radius:10px;box-shadow:0 4px 16px rgba(99,102,241,0.35);">
                            <i class="fas fa-credit-card me-2"></i>Proceed to Checkout
                        </button>
                    </form>
                    <small class="text-muted mt-3 d-block text-center">
                        <i class="fas fa-shield-alt me-1"></i>Secure checkout &nbsp;
                        <i class="fas fa-lock me-1"></i>SSL Encrypted
                    </small>
                </div>

            </div>
        </div>
    </c:if>
</main>

<footer class="footer">
    <div class="container">
        <p>&copy; 2024 Online Bookstore Management System | SE1020 Project</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/bookstore.js"></script>
</body>
</html>