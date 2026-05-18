<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Checkout - Online Bookstore</title>
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
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/books">Books</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/cart"><i class="fas fa-shopping-cart me-1"></i>Cart</a></li>
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
            <i class="fas fa-user-circle me-1"></i>${sessionScope.user.name}
          </a>
          <ul class="dropdown-menu dropdown-menu-end">
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
          </ul>
        </li>
      </ul>
    </div>
  </div>
</nav>

<div style="height: 76px;"></div>

<main class="container my-5">
  <!-- Progress Steps -->
  <div class="d-flex justify-content-center mb-5">
    <div class="checkout-step completed"><i class="fas fa-check me-1"></i>1. Cart</div>
    <div class="checkout-step active">2. Checkout</div>
    <div class="checkout-step">3. Payment</div>
  </div>

  <div class="row justify-content-center">
    <div class="col-md-8">
      <div class="card shadow-lg border-0 fade-in-up">
        <div class="card-header bg-white text-center py-4 border-0">
          <i class="fas fa-clipboard-list fa-3x text-primary mb-2"></i>
          <h3 class="mb-0 fw-bold">Confirm Your Order</h3>
        </div>
        <div class="card-body p-4">
          <c:if test="${not empty param.error}">
            <div class="alert alert-danger"><i class="fas fa-exclamation-triangle me-2"></i>Unable to place order. Please try again.</div>
          </c:if>

          <div class="glass-card p-4 mb-4">
            <h5><i class="fas fa-book me-2 text-primary"></i>Order Summary</h5>
            <table class="table table-borderless mb-0 mt-3">
              <tr><th style="width:40%;">Book Title:</th><td class="fw-bold">${orderSummary.bookTitle}</td></tr>
              <tr><th>Author:</th><td>${orderSummary.author}</td></tr>
              <tr><th>Quantity:</th><td><strong>${orderSummary.quantity}</strong></td></tr>
              <tr><th>Price per unit:</th><td>$${orderSummary.price}</td></tr>
              <tr><th>Total Amount:</th><td><span class="price fs-3 fw-bold">$${orderSummary.totalAmount}</span></td></tr>
            </table>
          </div>

          <div class="d-flex gap-3">
            <form action="${pageContext.request.contextPath}/order/place" method="post" data-loading="true">
              <input type="hidden" name="bookID" value="${orderSummary.bookID}">
              <input type="hidden" name="quantity" value="${orderSummary.quantity}">
              <button type="submit" class="btn btn-primary-custom btn-lg"><i class="fas fa-check-circle me-2"></i>Confirm Order</button>
            </form>
            <a href="${pageContext.request.contextPath}/cart" class="btn btn-secondary btn-lg"><i class="fas fa-arrow-left me-2"></i>Back to Cart</a>
          </div>
        </div>
      </div>
    </div>
  </div>
</main>

<footer class="footer">
  <div class="container"><p>&copy; 2024 Online Bookstore Management System | SE1020 Project</p></div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/bookstore.js"></script>
<style>
  .checkout-step {
    padding: 10px 22px; margin: 0 6px; border-radius: var(--r-full);
    background: var(--border); color: var(--text-muted); font-weight: 600; font-size: 0.9rem;
    transition: var(--t);
  }
  .checkout-step.active { background: var(--grad-primary); color: #fff; box-shadow: var(--shadow-md); }
  .checkout-step.completed { background: var(--success); color: #fff; }
</style>
</body>
</html>