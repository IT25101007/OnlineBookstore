<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Online Bookstore | Discover Your Next Favorite Book</title>
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
        <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/"><i class="fas fa-home me-1"></i>Home</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/books"><i class="fas fa-book me-1"></i>Browse Books</a></li>
        <c:choose>
          <c:when test="${not empty sessionScope.user}">
            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/cart"><i class="fas fa-shopping-cart me-1"></i>Cart</a></li>
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

  <!-- HERO -->
  <div class="hero-section fade-in-up">
    <h1>Discover Your Next <span class="text-gold">Favorite Book</span></h1>
    <p class="stagger-1 fade-in-up">Browse thousands of books, manage your collection, and enjoy seamless shopping</p>
    <div class="hero-actions mt-4">
      <a href="${pageContext.request.contextPath}/books" class="btn btn-primary-custom btn-lg stagger-2 fade-in-up">
        <i class="fas fa-search me-2"></i>Browse Books
      </a>
      <c:if test="${empty sessionScope.user}">
        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-custom btn-lg stagger-3 fade-in-up">
          <i class="fas fa-sign-in-alt me-2"></i>Login
        </a>
      </c:if>
    </div>
  </div>

  <!-- FEATURES -->
  <div class="row mt-5">
    <div class="col-md-4 mb-4">
      <div class="feature-card reveal stagger-1">
        <div class="feature-icon"><i class="fas fa-layer-group"></i></div>
        <h5>Wide Selection</h5>
        <p>Explore thousands of books across various genres including fiction, non-fiction, technical, and more.</p>
      </div>
    </div>
    <div class="col-md-4 mb-4">
      <div class="feature-card reveal stagger-2">
        <div class="feature-icon"><i class="fas fa-bolt"></i></div>
        <h5>Easy Shopping</h5>
        <p>Add books to your cart, manage quantities, and checkout seamlessly with our intuitive interface.</p>
      </div>
    </div>
    <div class="col-md-4 mb-4">
      <div class="feature-card reveal stagger-3">
        <div class="feature-icon"><i class="fas fa-truck-fast"></i></div>
        <h5>Order Tracking</h5>
        <p>Track your orders in real-time from confirmation to delivery. Get updates on every step.</p>
      </div>
    </div>
  </div>

  <!-- WHY CHOOSE US -->
  <div class="row mt-4">
    <div class="col-12">
      <div class="glass-card p-4 reveal">
        <h5 class="mb-3 text-center"><i class="fas fa-star text-warning me-2"></i>Why Choose Us?</h5>
        <div class="d-flex flex-wrap justify-content-center gap-3">
          <span class="tag-pill"><i class="fas fa-lock me-1"></i> Secure Payments</span>
          <span class="tag-pill"><i class="fas fa-shipping-fast me-1"></i> Fast Delivery</span>
          <span class="tag-pill"><i class="fas fa-headset me-1"></i> 24/7 Support</span>
          <span class="tag-pill"><i class="fas fa-tag me-1"></i> Best Price Guarantee</span>
          <span class="tag-pill"><i class="fas fa-undo me-1"></i> Easy Returns</span>
          <span class="tag-pill"><i class="fas fa-shield-alt me-1"></i> SSL Encrypted</span>
        </div>
      </div>
    </div>
  </div>

  <!-- STATS -->
  <div class="row mt-5 text-center">
    <div class="col-md-3 col-6 mb-3">
      <div class="stat-card stat-primary reveal stagger-1">
        <div class="stat-icon"><i class="fas fa-users"></i></div>
        <div class="stat-value counter-number" data-count="10000" data-suffix="+">10K+</div>
        <div class="stat-label">Happy Readers</div>
      </div>
    </div>
    <div class="col-md-3 col-6 mb-3">
      <div class="stat-card stat-success reveal stagger-2">
        <div class="stat-icon"><i class="fas fa-book"></i></div>
        <div class="stat-value counter-number" data-count="5000" data-suffix="+">5K+</div>
        <div class="stat-label">Books Available</div>
      </div>
    </div>
    <div class="col-md-3 col-6 mb-3">
      <div class="stat-card stat-accent reveal stagger-3">
        <div class="stat-icon"><i class="fas fa-truck"></i></div>
        <div class="stat-value counter-number" data-count="1000" data-suffix="+">1K+</div>
        <div class="stat-label">Orders Delivered</div>
      </div>
    </div>
    <div class="col-md-3 col-6 mb-3">
      <div class="stat-card stat-info reveal stagger-4">
        <div class="stat-icon"><i class="fas fa-star"></i></div>
        <div class="stat-value">4.9</div>
        <div class="stat-label">Customer Rating</div>
      </div>
    </div>
  </div>

</main>

<footer class="footer">
  <div class="container">
    <p>&copy; 2024 Online Bookstore Management System | SE1020 Object Oriented Programming Project</p>
    <p class="mb-0 mt-2"><i class="fas fa-credit-card me-2"></i>Secure Payments <i class="fas fa-shield-alt mx-3"></i>SSL Encrypted <i class="fas fa-headset ms-2"></i>24/7 Support</p>
  </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/bookstore.js"></script>
</body>
</html>