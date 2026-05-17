<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${book.title} - Online Bookstore</title>
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
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/books"><i class="fas fa-book me-1"></i>Browse Books</a></li>
                <c:if test="${not empty sessionScope.user}">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/cart"><i class="fas fa-shopping-cart me-1"></i>Cart</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/orders"><i class="fas fa-truck me-1"></i>Orders</a></li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user-circle me-1"></i>${sessionScope.user.name}
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="fas fa-id-card me-2"></i>Profile</a></li>
                            <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-chart-line me-2"></i>Admin</a></li>
                            </c:if>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                        </ul>
                    </li>
                </c:if>
                <c:if test="${empty sessionScope.user}">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/login">Login</a></li>
                </c:if>
            </ul>
        </div>
    </div>
</nav>

<div style="height: 76px;"></div>

<main class="container my-5">

    <a href="${pageContext.request.contextPath}/books" class="btn-back mb-4 d-inline-flex">
        <i class="fas fa-arrow-left"></i> Back to Books
    </a>

    <c:if test="${not empty param.error}">
        <div class="alert alert-danger alert-dismissible fade show">
            <i class="fas fa-exclamation-triangle me-2"></i>
            <c:choose>
                <c:when test="${param.error == 'insufficient_stock'}">Insufficient stock available!</c:when>
                <c:otherwise>An error occurred. Please try again.</c:otherwise>
            </c:choose>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="row">
        <div class="col-lg-4 mb-4">
            <div class="book-cover-area" style="height: 350px; border-radius: var(--r-xl);">
                <i class="fas fa-book fa-5x" style="opacity: 0.9;"></i>
            </div>
        </div>
        <div class="col-lg-8">
            <div class="card shadow-lg border-0 fade-in-up">
                <div class="card-body p-4">
                    <div class="mb-3">
                        <span class="badge ${book.type == 'EBOOK' ? 'badge-ebook' : 'badge-printed'} fs-6 px-3 py-2">
                            <i class="fas ${book.type == 'EBOOK' ? 'fa-download' : 'fa-book'} me-2"></i>${book.type == 'EBOOK' ? 'E-Book' : 'Printed Book'}
                        </span>
                    </div>
                    <h1 class="card-title fw-bold mb-2">${book.title}</h1>
                    <h4 class="text-muted mb-3">by ${book.author}</h4>

                    <p class="text-muted mb-4"><em>No description available for this title.</em></p>

                    <div class="row mb-4">
                        <div class="col-md-6">
                            <p><i class="fas fa-tag text-primary me-2"></i><strong>Category:</strong> ${book.category}</p>
                            <p><i class="fas fa-dollar-sign text-success me-2"></i><strong>Price:</strong> <span class="price">$<fmt:formatNumber value="${book.price}" minFractionDigits="2" maxFractionDigits="2"/></span></p>
                        </div>
                        <div class="col-md-6">
                            <p><i class="fas fa-boxes text-info me-2"></i><strong>Stock:</strong>
                                <span class="${book.stock > 10 ? 'stock-available' : (book.stock > 0 ? 'stock-low' : 'stock-out')}">
                                    <c:choose>
                                        <c:when test="${book.stock > 0}">${book.stock} copies available</c:when>
                                        <c:otherwise>Out of Stock</c:otherwise>
                                    </c:choose>
                                </span>
                            </p>
                            <p><i class="fas ${book.type == 'EBOOK' ? 'fa-cloud-download-alt' : 'fa-shipping-fast'} me-2"></i>
                                <strong>Delivery:</strong> ${book.type == 'EBOOK' ? 'Instant Download' : 'Free Shipping on orders $50+'}
                            </p>
                        </div>
                    </div>

                    <c:if test="${book.type == 'EBOOK'}">
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i>After purchase, you'll receive a download link via email.
                        </div>
                    </c:if>

                    <c:if test="${not empty sessionScope.user && book.stock > 0}">
                        <form action="${pageContext.request.contextPath}/cart/add" method="post" class="mt-3">
                            <input type="hidden" name="bookID" value="${book.bookID}">
                            <div class="row g-3 align-items-end">
                                <div class="col-auto">
                                    <label class="form-label fw-bold">Quantity:</label>
                                    <div class="quantity-stepper">
                                        <button type="button" onclick="updateQuantity(this, -1)">-</button>
                                        <input type="number" id="quantity" name="quantity" class="quantity-input text-center" value="1" min="1" max="${book.stock}">
                                        <button type="button" onclick="updateQuantity(this, 1)">+</button>
                                    </div>
                                </div>
                                <div class="col-auto">
                                    <button type="submit" class="btn btn-primary-custom btn-lg">
                                        <i class="fas fa-cart-plus me-2"></i>Add to Cart
                                    </button>
                                </div>
                            </div>
                        </form>
                    </c:if>

                    <c:if test="${empty sessionScope.user && book.stock > 0}">
                        <div class="alert alert-info mt-3">
                            <i class="fas fa-sign-in-alt me-2"></i>Please <a href="${pageContext.request.contextPath}/login">login</a> to purchase this book.
                        </div>
                    </c:if>
                </div>
                <div class="card-footer bg-white d-flex justify-content-between">
                    <a href="${pageContext.request.contextPath}/books" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Back to Books
                    </a>
                    <c:if test="${sessionScope.user.role == 'ADMIN'}">
                        <div>
                            <a href="${pageContext.request.contextPath}/book/edit?bookID=${book.bookID}" class="btn btn-warning">
                                <i class="fas fa-edit me-2"></i>Edit
                            </a>
                            <form action="${pageContext.request.contextPath}/book/delete" method="post" style="display:inline;" data-confirm="Delete this book permanently?">
                                <input type="hidden" name="bookID" value="${book.bookID}">
                                <button type="submit" class="btn btn-danger ms-2">
                                    <i class="fas fa-trash me-2"></i>Delete
                                </button>
                            </form>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
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
