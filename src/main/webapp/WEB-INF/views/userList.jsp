<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - Admin</title>
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
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-chart-line me-1"></i>Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/books"><i class="fas fa-book me-1"></i>Books</a></li>
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/users"><i class="fas fa-users me-1"></i>Users</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/orders"><i class="fas fa-truck me-1"></i>Orders</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/reports"><i class="fas fa-chart-bar me-1"></i>Reports</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/system"><i class="fas fa-cogs me-1"></i>System</a></li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user-cog me-1"></i>${sessionScope.user.name}
                        <span class="admin-badge ms-1">ADMIN</span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="fas fa-id-card me-2"></i>Profile</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div style="height: 76px;"></div>

<main class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4 fade-in-up">
        <div>
            <h2 class="page-title mb-1"><i class="fas fa-users me-3"></i>All Users</h2>
            <p class="text-muted mb-0">Manage registered user accounts</p>
        </div>
        <span class="badge bg-primary fs-6 px-3 py-2"><i class="fas fa-users me-1"></i>${users.size()} users</span>
    </div>

    <!-- Search / Filter bar -->
    <div class="mb-4 reveal">
        <input type="text" id="userSearchInput" class="form-control" placeholder="🔍  Filter by name, email or role..." oninput="filterUsers(this.value)" style="max-width:400px;">
    </div>

    <div class="card shadow-lg border-0 reveal">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0" id="usersTable">
                    <thead class="table-light">
                    <tr>
                        <th>User ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Role</th>
                        <th class="text-end">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="user" items="${users}">
                        <tr>
                            <td><code>${user.userID}</code></td>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <div style="width:32px;height:32px;border-radius:50%;background:var(--grad-primary);display:flex;align-items:center;justify-content:center;color:#fff;font-size:0.85rem;flex-shrink:0;">
                                            ${user.name.substring(0,1).toUpperCase()}
                                    </div>
                                    <strong>${user.name}</strong>
                                </div>
                            </td>
                            <td>${user.email}</td>
                            <td>${user.phone != null ? user.phone : '—'}</td>
                            <td>
                                <span class="badge ${user.role == 'ADMIN' ? 'bg-danger' : 'bg-success'}">
                                    <i class="fas ${user.role == 'ADMIN' ? 'fa-shield-alt' : 'fa-user'} me-1"></i>${user.role}
                                </span>
                            </td>
                            <td class="text-end">
                                <c:if test="${user.userID != sessionScope.user.userID}">
                                    <form action="${pageContext.request.contextPath}/users" method="post" class="d-inline" data-confirm="Delete user ${user.name}? This cannot be undone.">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="userID" value="${user.userID}">
                                        <button type="submit" class="btn btn-sm btn-danger"><i class="fas fa-trash me-1"></i>Delete</button>
                                    </form>
                                </c:if>
                                <c:if test="${user.userID == sessionScope.user.userID}">
                                    <span class="badge bg-secondary"><i class="fas fa-user-check me-1"></i>You</span>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="mt-3">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-back d-inline-flex">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>
</main>

<footer class="footer">
    <div class="container"><p>&copy; 2024 Online Bookstore Management System | SE1020 Project</p></div>
</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/bookstore.js"></script>
<script>
    function filterUsers(query) {
        const rows = document.querySelectorAll('#usersTable tbody tr');
        const q = query.toLowerCase();
        rows.forEach(row => {
            row.style.display = row.innerText.toLowerCase().includes(q) ? '' : 'none';
        });
    }
</script>
</body>
</html>