<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Profile - Online Bookstore</title>
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
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/books">Books</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/cart"><i class="fas fa-shopping-cart me-1"></i>Cart</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/orders">Orders</a></li>
        <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/profile"><i class="fas fa-user me-1"></i>Profile</a></li>
        <c:if test="${sessionScope.user.role == 'ADMIN'}">
          <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Admin</a></li>
        </c:if>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a></li>
      </ul>
    </div>
  </div>
</nav>

<div style="height: 76px;"></div>

<main class="container my-5">
  <div class="row">
    <div class="col-lg-4 mb-4">
      <div class="card shadow-lg border-0 text-center fade-in-up">
        <div class="card-body py-5">
          <div class="profile-avatar"><i class="fas fa-user"></i></div>
          <h4 class="mt-2 mb-1">${sessionScope.user.name}</h4>
          <span class="badge ${sessionScope.user.role == 'ADMIN' ? 'bg-danger' : 'bg-primary'} px-3 py-2">
                        <i class="fas ${sessionScope.user.role == 'ADMIN' ? 'fa-shield-alt' : 'fa-user'} me-1"></i>${sessionScope.user.role}
                    </span>
          <hr class="my-3">
          <p class="text-muted mb-0 small"><i class="fas fa-id-card me-1"></i>Member ID<br><code>${sessionScope.user.userID}</code></p>
        </div>
      </div>
    </div>
    <div class="col-lg-8">
      <div class="card shadow-lg border-0 mb-4 reveal">
        <div class="card-header bg-white"><h5 class="mb-0"><i class="fas fa-user-edit me-2 text-primary"></i>Profile Information</h5></div>
        <div class="card-body">
          <div class="row mb-3"><div class="col-sm-3 fw-bold">User ID:</div><div class="col-sm-9"><code>${sessionScope.user.userID}</code></div></div>
          <div class="row mb-3"><div class="col-sm-3 fw-bold">Role:</div><div class="col-sm-9"><span class="badge ${sessionScope.user.role == 'ADMIN' ? 'bg-danger' : 'bg-primary'}">${sessionScope.user.role}</span></div></div>
        </div>
      </div>

      <div class="card shadow-lg border-0 mb-4 reveal">
        <div class="card-header bg-white"><h5 class="mb-0"><i class="fas fa-edit me-2 text-primary"></i>Edit Profile</h5></div>
        <div class="card-body">
          <form action="${pageContext.request.contextPath}/profile" method="post" data-loading="true">
            <div class="mb-3"><label for="name" class="form-label"><i class="fas fa-user me-2 text-primary"></i>Full Name</label><input type="text" class="form-control" id="name" name="name" value="${sessionScope.user.name}" required></div>
            <div class="mb-3"><label for="email" class="form-label"><i class="fas fa-envelope me-2 text-primary"></i>Email Address</label><input type="email" class="form-control" id="email" name="email" value="${sessionScope.user.email}" required></div>
            <div class="mb-3"><label for="phone" class="form-label"><i class="fas fa-phone me-2 text-primary"></i>Phone Number</label><input type="tel" class="form-control" id="phone" name="phone" value="${sessionScope.user.phone}"></div>
            <button type="submit" class="btn btn-primary-custom"><i class="fas fa-save me-2"></i>Update Profile</button>
          </form>
        </div>
      </div>

      <div class="card shadow-lg border-0 reveal" style="border-left: 4px solid var(--danger);">
        <div class="card-header bg-white text-danger"><h5 class="mb-0"><i class="fas fa-exclamation-triangle me-2"></i>Danger Zone</h5></div>
        <div class="card-body">
          <p class="text-muted">Once you delete your account, there is no going back. Please be certain.</p>
          <form action="${pageContext.request.contextPath}/users" method="post" data-confirm="Are you sure you want to delete your account? This action cannot be undone!">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="userID" value="${sessionScope.user.userID}">
            <button type="submit" class="btn btn-danger"><i class="fas fa-trash-alt me-2"></i>Delete My Account</button>
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
</body>
</html>