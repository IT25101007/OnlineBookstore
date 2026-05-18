<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Administration - Online Bookstore</title>
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
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/users"><i class="fas fa-users me-1"></i>Users</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/orders"><i class="fas fa-truck me-1"></i>Orders</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/reports"><i class="fas fa-chart-bar me-1"></i>Reports</a></li>
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/system"><i class="fas fa-cogs me-1"></i>System</a></li>
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
    <div class="d-flex justify-content-between align-items-center mb-5 fade-in-up flex-wrap gap-3">
        <div>
            <h2 class="page-title mb-1"><i class="fas fa-cogs me-3"></i>System Administration</h2>
            <p class="text-muted mb-0">Manage administrator accounts and system settings</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/register" class="btn btn-primary-custom">
            <i class="fas fa-user-plus me-2"></i>Add New Admin
        </a>
    </div>

    <c:if test="${param.success == 'true'}">
        <div class="alert alert-success alert-dismissible fade show"><i class="fas fa-check-circle me-2"></i>Admin account created successfully!<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
    </c:if>
    <c:if test="${param.error == 'true'}">
        <div class="alert alert-danger alert-dismissible fade show"><i class="fas fa-exclamation-triangle me-2"></i>Failed to create admin account. Please try again.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
    </c:if>

    <!-- Admin Cards -->
    <div class="card shadow-lg border-0 mb-4 reveal">
        <div class="card-header bg-white">
            <h5 class="mb-0"><i class="fas fa-users me-2 text-primary"></i>Admin Accounts <span class="badge bg-primary ms-2">${admins.size()}</span></h5>
        </div>
        <div class="card-body">
            <div class="row g-4">
                <c:forEach var="admin" items="${admins}">
                    <div class="col-md-6 col-lg-4">
                        <div class="admin-panel-card h-100">
                            <div class="admin-panel-avatar">
                                <c:choose>
                                    <c:when test="${admin.role == 'SUPER_ADMIN'}"><i class="fas fa-crown fa-2x" style="color:#f59e0b;"></i></c:when>
                                    <c:when test="${admin.role == 'REPORT_ADMIN'}"><i class="fas fa-chart-line fa-2x" style="color:#10b981;"></i></c:when>
                                    <c:otherwise><i class="fas fa-user-shield fa-2x" style="color:#6366f1;"></i></c:otherwise>
                                </c:choose>
                            </div>
                            <h5 class="mb-1">${admin.name}</h5>
                            <p class="text-muted small mb-2">${admin.email}</p>
                            <span class="badge ${admin.role == 'SUPER_ADMIN' ? 'bg-danger' : (admin.role == 'REPORT_ADMIN' ? 'bg-warning' : 'bg-info')} px-3 py-2 mb-3">
                                <i class="fas ${admin.role == 'SUPER_ADMIN' ? 'fa-shield-alt' : (admin.role == 'REPORT_ADMIN' ? 'fa-chart-line' : 'fa-user-check')} me-1"></i>${admin.role}
                            </span>
                            <div class="mt-auto w-100">
                                <c:if test="${admin.email != sessionScope.user.email}">
                                    <form action="${pageContext.request.contextPath}/admin/system" method="post" data-confirm="Delete admin ${admin.name}? This cannot be undone.">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="adminID" value="${admin.adminID}">
                                        <button type="submit" class="btn btn-sm btn-danger w-100"><i class="fas fa-trash-alt me-2"></i>Delete Admin</button>
                                    </form>
                                </c:if>
                                <c:if test="${admin.email == sessionScope.user.email}">
                                    <button class="btn btn-sm btn-secondary w-100" disabled><i class="fas fa-user-check me-2"></i>Current User</button>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty admins}">
                    <div class="col-12">
                        <div class="empty-state">
                            <div class="empty-state-icon"><i class="fas fa-users-slash"></i></div>
                            <h4>No admin accounts found</h4>
                            <p>Click "Add New Admin" to create one.</p>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- System Info -->
        <div class="col-md-6 mb-4">
            <div class="card shadow-lg border-0 h-100 reveal">
                <div class="card-header bg-white"><h5 class="mb-0"><i class="fas fa-server me-2 text-primary"></i>System Information</h5></div>
                <div class="card-body">
                    <table class="table table-sm table-borderless">
                        <tr><th style="width:45%;">Application:</th><td>Online Bookstore Management System</td></tr>
                        <tr><th>Version:</th><td><span class="tag-pill">v1.0.0</span></td></tr>
                        <tr><th>Data Storage:</th><td>File-based (TXT files)</td></tr>
                        <tr><th>Framework:</th><td>Spring Boot 3.x + JSP</td></tr>
                        <tr><th>Java Version:</th><td>17</td></tr>
                        <tr><th>Database:</th><td>File System (data folder)</td></tr>
                    </table>
                </div>
            </div>
        </div>
        <!-- Role Guide -->
        <div class="col-md-6 mb-4">
            <div class="card shadow-lg border-0 h-100 reveal">
                <div class="card-header bg-white"><h5 class="mb-0"><i class="fas fa-graduation-cap me-2 text-primary"></i>Admin Role Guide</h5></div>
                <div class="card-body">
                    <div class="mb-3">
                        <span class="badge bg-danger me-2 px-3 py-2">SUPER_ADMIN</span>
                        <span class="text-muted small">Full system access can manage all features</span>
                    </div>
                    <div class="mb-3">
                        <span class="badge bg-warning me-2 px-3 py-2">REPORT_ADMIN</span>
                        <span class="text-muted small">Can view reports; limited system settings access</span>
                    </div>
                    <div class="mb-3">
                        <span class="badge bg-info me-2 px-3 py-2">REGULAR</span>
                        <span class="text-muted small">Standard admin privileges for daily operations</span>
                    </div>
                    <hr>
                    <p class="mb-0 text-muted small"><i class="fas fa-info-circle me-1"></i>You cannot delete your own account from this panel. Use your Profile page instead.</p>
                </div>
            </div>
        </div>
    </div>

    <div class="mt-2">
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
</body>
</html>