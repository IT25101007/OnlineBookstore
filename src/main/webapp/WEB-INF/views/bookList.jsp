<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Books - Online Bookstore</title>
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
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/register">Register</a></li>
                </c:if>
            </ul>
        </div>
    </div>
</nav>

<div style="height: 76px;"></div>

<main class="container my-5">

    <!-- Search Header -->
    <div class="search-header reveal mb-4">
        <div class="row align-items-center">
            <div class="col-md-6 mb-3 mb-md-0">
                <h2 class="mb-1 fw-bold"><i class="fas fa-book-open me-2"></i>Our Library</h2>
                <p class="mb-0 opacity-75">Discover your next great read from our collection</p>
            </div>
            <div class="col-md-6">
                <form action="${pageContext.request.contextPath}/books" method="get">
                    <div class="input-group">
                        <span class="input-group-text border-0" style="background:rgba(255,255,255,0.2)"><i class="fas fa-search text-white"></i></span>
                        <input type="text" name="search" class="search-bar form-control border-0" placeholder="Search by title, author, or category..." value="${param.search}">
                        <button type="submit" class="btn btn-light fw-bold px-4">Search</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Admin Bar -->
    <c:if test="${sessionScope.user.role == 'ADMIN'}">
        <div class="d-flex justify-content-end mb-4">
            <a href="${pageContext.request.contextPath}/book/add" class="btn btn-success shadow-sm">
                <i class="fas fa-plus me-2"></i>Add New Book
            </a>
        </div>
    </c:if>

    <!-- Search Results Info -->
    <c:if test="${not empty param.search}">
        <div class="alert alert-info alert-dismissible fade show">
            <i class="fas fa-search me-2"></i>Showing results for: "<strong>${param.search}</strong>"
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Books Grid -->
    <div class="row g-4">
        <c:forEach var="book" items="${books}" varStatus="status">
            <div class="col-md-6 col-lg-3">
                <div class="book-grid-card reveal stagger-${(status.index % 4) + 1}">
                    <div class="book-cover-area">
                        <i class="fas fa-book fa-4x" style="opacity:0.9;"></i>
                    </div>
                    <div class="book-grid-card-body p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="badge ${book.type == 'EBOOK' ? 'badge-ebook' : 'badge-printed'}">
                                <i class="fas ${book.type == 'EBOOK' ? 'fa-download' : 'fa-book'} me-1"></i>${book.type == 'EBOOK' ? 'E-Book' : 'Printed'}
                            </span>
                            <c:if test="${book.stock <= 0}"><span class="badge bg-danger">Out of Stock</span></c:if>
                        </div>
                        <h5 class="card-title fw-bold mb-1">${book.title}</h5>
                        <h6 class="text-muted small mb-2"><i class="fas fa-user-edit me-1"></i>${book.author}</h6>
                        <p class="small mb-2">
                            <i class="fas fa-tag me-1 text-primary"></i>${book.category} &nbsp;
                            <span class="${book.stock > 10 ? 'stock-available' : (book.stock > 0 ? 'stock-low' : 'stock-out')}">
                                <c:choose>
                                    <c:when test="${book.stock > 0}">${book.stock} in stock</c:when>
                                    <c:otherwise>Unavailable</c:otherwise>
                                </c:choose>
                            </span>
                        </p>
                        <div class="price mb-3">$<fmt:formatNumber value="${book.price}" minFractionDigits="2" maxFractionDigits="2"/></div>
                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/book/detail?bookID=${book.bookID}"
                               style="display:block;text-align:center;padding:6px 12px;border-radius:8px;border:2px solid #6c63ff;color:#6c63ff !important;background:#f3f0ff;font-weight:600;font-size:.875rem;text-decoration:none;">
                                <i class="fas fa-info-circle me-1"></i>View Details
                            </a>
                            <c:if test="${not empty sessionScope.user && book.stock > 0}">
                                <form action="${pageContext.request.contextPath}/cart/add" method="post">
                                    <input type="hidden" name="bookID" value="${book.bookID}">
                                    <input type="hidden" name="quantity" value="1">
                                    <button type="submit" style="display:block;width:100%;padding:6px 12px;border-radius:8px;border:none;background:linear-gradient(135deg,#6c63ff,#a78bfa);color:#fff;font-weight:600;font-size:.875rem;cursor:pointer;">
                                        <i class="fas fa-cart-plus me-1"></i>Add to Cart
                                    </button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>

        <c:if test="${empty books}">
            <div class="col-12">
                <div class="empty-state">
                    <div class="empty-state-icon"><i class="fas fa-book-open"></i></div>
                    <h4>No books found</h4>
                    <p>Try a different search term or browse our full collection.</p>
                    <a href="${pageContext.request.contextPath}/books" class="btn btn-primary-custom mt-2"><i class="fas fa-sync-alt me-2"></i>Clear Search</a>
                </div>
            </div>
        </c:if>
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