<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login - Online Bookstore</title>
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
    <div class="collapse navbar-collapse">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/"><i class="fas fa-home me-1"></i>Home</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/books"><i class="fas fa-book me-1"></i>Browse Books</a></li>
      </ul>
    </div>
  </div>
</nav>

<div style="height: 76px;"></div>

<main class="container my-5">
  <div class="row justify-content-center">
    <div class="col-md-6 col-lg-5">
      <div class="auth-card fade-in-up">
        <div class="auth-card-header">
          <div class="auth-card-icon"><i class="fas fa-sign-in-alt"></i></div>
          <h3 class="mb-1">Welcome Back!</h3>
          <p class="mb-0 opacity-75">Login to your account</p>
        </div>
        <div class="auth-card-body">
          <c:if test="${param.error == 'true'}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
              <i class="fas fa-exclamation-triangle me-2"></i>Invalid email or password. Please try again.
              <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
          </c:if>
          <c:if test="${param.expired == 'true'}">
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
              <i class="fas fa-clock me-2"></i>Your session expired. Please log in again.
              <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
          </c:if>

          <form action="${pageContext.request.contextPath}/login" method="post" data-loading="true">
            <div class="mb-3">
              <label for="email" class="form-label"><i class="fas fa-envelope me-2 text-primary"></i>Email Address</label>
              <input type="email" class="form-control" id="email" name="email" placeholder="you@example.com" required autofocus>
            </div>
            <div class="mb-3">
              <label for="password" class="form-label"><i class="fas fa-lock me-2 text-primary"></i>Password</label>
              <div class="input-group">
                <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
                <button class="btn btn-outline-secondary" type="button" id="togglePassword" data-target="password"><i class="fas fa-eye"></i></button>
              </div>
            </div>
            <button type="submit" class="btn btn-primary-custom w-100 py-2"><i class="fas fa-sign-in-alt me-2"></i>Login</button>
          </form>

          <div class="divider-text my-4">OR</div>
          <div class="text-center">
            <p class="mb-0"><i class="fas fa-user-plus me-2 text-primary"></i>Don't have an account? <a href="${pageContext.request.contextPath}/register" class="fw-bold">Register here</a></p>
          </div>
        </div>
      </div>

      <div class="demo-credentials reveal">
        <div class="text-center">
          <small><i class="fas fa-info-circle me-1"></i> <strong>Demo Credentials</strong></small><br>
          <small class="text-muted">Admin: admin@bookstore.com / admin123</small><br>
          <small class="text-muted">Customer: john@example.com / password123</small>
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