<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment - Online Bookstore</title>
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
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/cart">Cart</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/orders">Orders</a></li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown"><i class="fas fa-user-circle me-1"></i>${sessionScope.user.name}</a>
                    <ul class="dropdown-menu dropdown-menu-end"><li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li></ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div style="height: 76px;"></div>

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <!-- Progress Steps -->
            <div class="d-flex justify-content-center mb-5">
                <div class="checkout-step completed"><i class="fas fa-check me-1"></i>1. Cart</div>
                <div class="checkout-step completed"><i class="fas fa-check me-1"></i>2. Checkout</div>
                <div class="checkout-step active">3. Payment</div>
            </div>

            <div class="card shadow-lg border-0 fade-in-up">
                <div class="card-header bg-white text-center py-4 border-0">
                    <i class="fas fa-credit-card fa-3x text-primary mb-2"></i>
                    <h3 class="mb-0 fw-bold">Complete Payment</h3>
                </div>
                <div class="card-body p-4">
                    <div class="glass-card p-4 mb-4">
                        <h5><i class="fas fa-receipt me-2 text-primary"></i>Order Summary</h5>
                        <div class="row mt-3">
                            <div class="col-6"><strong>Order ID:</strong></div><div class="col-6"><code>${order.orderID}</code></div>
                            <div class="col-6 mt-2"><strong>Total Amount:</strong></div><div class="col-6 mt-2"><span class="price fs-4">$${order.totalAmount}</span></div>
                        </div>
                    </div>

                    <form id="paymentForm" action="${pageContext.request.contextPath}/payment/process" method="post" data-loading="true">
                        <input type="hidden" name="orderID" value="${order.orderID}">
                        <input type="hidden" name="amount" value="${order.totalAmount}">

                        <div class="mb-4">
                            <label class="form-label fw-bold mb-3">Select Payment Method</label>
                            <div class="row">
                                <div class="col-md-6 mb-2">
                                    <div class="payment-method-card selected" data-method="CREDIT_CARD">
                                        <input type="radio" name="method" id="creditCardMethod" value="CREDIT_CARD" checked hidden>
                                        <i class="fas fa-credit-card fa-2x text-primary"></i>
                                        <div class="mt-2 fw-bold">Credit Card</div>
                                        <small class="text-muted">Visa, MasterCard, Amex</small>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-2">
                                    <div class="payment-method-card" data-method="PAYPAL">
                                        <input type="radio" name="method" id="paypalMethod" value="PAYPAL" hidden>
                                        <i class="fab fa-paypal fa-2x text-info"></i>
                                        <div class="mt-2 fw-bold">PayPal</div>
                                        <small class="text-muted">Fast &amp; Secure</small>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div data-payment-section="CREDIT_CARD">
                            <div class="card-preview mb-4">
                                <div class="card-preview-inner">
                                    <i class="fas fa-credit-card"></i>
                                    <span id="cardPreviewNumber">**** **** **** 1234</span>
                                    <span id="cardPreviewName">Cardholder Name</span>
                                </div>
                            </div>
                            <div class="mb-3"><label class="form-label"><i class="fas fa-credit-card me-2 text-primary"></i>Card Number</label><input type="text" class="form-control" id="cardNumber" placeholder="1234 5678 9012 3456" maxlength="19"></div>
                            <div class="row">
                                <div class="col-md-6 mb-3"><label class="form-label"><i class="fas fa-calendar me-2 text-primary"></i>Expiry Date</label><input type="text" class="form-control" id="expiryDate" placeholder="MM/YY"></div>
                                <div class="col-md-6 mb-3"><label class="form-label"><i class="fas fa-lock me-2 text-primary"></i>Last 4 Digits</label><input type="text" class="form-control" id="cardLastFour" name="cardLastFour" placeholder="1234" maxlength="4" required></div>
                            </div>
                            <div class="mb-3"><label class="form-label"><i class="fas fa-user me-2 text-primary"></i>Cardholder Name</label><input type="text" class="form-control" id="cardholderName" placeholder="John Doe"></div>
                        </div>

                        <div data-payment-section="PAYPAL" style="display:none;">
                            <div class="text-center mb-4 py-3">
                                <i class="fab fa-paypal fa-4x text-info"></i>
                                <p class="mt-3">You will be redirected to PayPal to complete your payment.</p>
                            </div>
                            <div class="mb-3"><label class="form-label"><i class="fas fa-envelope me-2 text-primary"></i>PayPal Email</label><input type="email" class="form-control" id="paypalEmail" name="paypalEmail" placeholder="you@example.com"></div>
                        </div>

                        <div class="d-flex gap-3 mt-4">
                            <button type="submit" class="btn btn-primary-custom btn-lg flex-grow-1"><i class="fas fa-lock me-2"></i>Pay Now</button>
                            <a href="${pageContext.request.contextPath}/orders" class="btn btn-secondary btn-lg"><i class="fas fa-times me-2"></i>Cancel</a>
                        </div>
                    </form>
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
.checkout-step { padding:10px 22px;margin:0 6px;border-radius:var(--r-full);background:var(--border);color:var(--text-muted);font-weight:600;font-size:0.9rem;transition:var(--t); }
.checkout-step.active { background:var(--grad-primary);color:#fff;box-shadow:var(--shadow-md); }
.checkout-step.completed { background:var(--success);color:#fff; }
.card-preview { background:linear-gradient(135deg,#1e293b,#0f172a);border-radius:var(--r-lg);padding:20px;color:#fff; }
.card-preview-inner { display:flex;flex-direction:column;gap:10px; }
.card-preview-inner i { font-size:2rem; }
</style>
<script>
document.getElementById('cardNumber').addEventListener('input', function(e) {
    let value = e.target.value.replace(/\D/g, '');
    if (value.length > 4) {
        let lastFour = value.slice(-4);
        document.getElementById('cardLastFour').value = lastFour;
        document.getElementById('cardPreviewNumber').innerText = '**** **** **** ' + lastFour;
    }
    e.target.value = value.replace(/(\d{4})(?=\d)/g, '$1 ').substring(0, 19);
});
document.getElementById('cardholderName').addEventListener('input', function(e) {
    document.getElementById('cardPreviewName').innerText = e.target.value || 'Cardholder Name';
});
</script>
</body>
</html>