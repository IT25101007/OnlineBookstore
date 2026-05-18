<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Online Bookstore</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@700;800;900&family=Plus+Jakarta+Sans:ital,wght@0,400;0,500;0,600;0,700;1,400&family=Noto+Sans+Sinhala:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <style>
        /* Quick Action buttons - isolated from theme overrides */
        .qa-btn {
            display: flex !important;
            flex-direction: column !important;
            align-items: center !important;
            justify-content: center !important;
            padding: 1.2rem 0.5rem !important;
            border-radius: 14px !important;
            text-decoration: none !important;
            font-weight: 700 !important;
            transition: transform .15s, box-shadow .15s !important;
            gap: 0.5rem !important;
        }
        .qa-btn:hover { transform: translateY(-3px) !important; box-shadow: 0 8px 24px rgba(0,0,0,.12) !important; }
        .qa-icon { display: block; margin-bottom: 2px; }
        .qa-label { font-size: 0.9rem; line-height: 1.2; }

        .qa-purple { background: #f3f0ff !important; border: 2px solid #6c63ff !important; }
        .qa-purple .qa-icon, .qa-purple .qa-label { color: #6c63ff !important; }

        .qa-green  { background: #f0fdf4 !important; border: 2px solid #22c55e !important; }
        .qa-green  .qa-icon, .qa-green  .qa-label { color: #16a34a !important; }

        .qa-orange { background: #fff7ed !important; border: 2px solid #f97316 !important; }
        .qa-orange .qa-icon, .qa-orange .qa-label { color: #ea6c00 !important; }

        .qa-teal   { background: #f0fdfa !important; border: 2px solid #14b8a6 !important; }
        .qa-teal   .qa-icon, .qa-teal   .qa-label { color: #0f9488 !important; }

        .qa-gray   { background: #f8fafc !important; border: 2px solid #94a3b8 !important; }
        .qa-gray   .qa-icon, .qa-gray   .qa-label { color: #64748b !important; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark fixed-top">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/"><i class="fas fa-book-open me-2"></i>Online Bookstore</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"><span class="navbar-toggler-icon"></span></button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-chart-line me-1"></i>Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/books"><i class="fas fa-book me-1"></i>Books</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/users"><i class="fas fa-users me-1"></i>Users</a></li>
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
    <div class="d-flex justify-content-between align-items-center mb-5 fade-in-up">
        <div>
            <h2 class="page-title mb-1"><i class="fas fa-chart-line me-3"></i>Admin Dashboard</h2>
            <p class="text-muted mb-0">Welcome back, ${sessionScope.user.name}! Here's your store overview.</p>
        </div>
        <span class="badge bg-danger px-3 py-2 fs-6"><i class="fas fa-shield-alt me-1"></i>Admin Access</span>
    </div>

    <!-- KPI Stats -->
    <div class="row g-4 mb-5">
        <div class="col-md-6 col-lg-3">
            <div class="stat-card stat-primary reveal stagger-1">
                <div class="stat-icon"><i class="fas fa-users"></i></div>
                <div class="stat-value counter-number" data-count="${totalUsers}">${totalUsers}</div>
                <div class="stat-label">Total Users</div>
            </div>
        </div>
        <div class="col-md-6 col-lg-3">
            <div class="stat-card stat-success reveal stagger-2">
                <div class="stat-icon"><i class="fas fa-book"></i></div>
                <div class="stat-value counter-number" data-count="${totalBooks}">${totalBooks}</div>
                <div class="stat-label">Total Books</div>
            </div>
        </div>
        <div class="col-md-6 col-lg-3">
            <div class="stat-card stat-accent reveal stagger-3">
                <div class="stat-icon"><i class="fas fa-shopping-cart"></i></div>
                <div class="stat-value counter-number" data-count="${totalOrders}">${totalOrders}</div>
                <div class="stat-label">Total Orders</div>
            </div>
        </div>
        <div class="col-md-6 col-lg-3">
            <div class="stat-card stat-info reveal stagger-4">
                <div class="stat-icon"><i class="fas fa-dollar-sign"></i></div>
                <div class="stat-value"><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="$" minFractionDigits="2" maxFractionDigits="2"/></div>
                <div class="stat-label">Total Revenue</div>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- Quick Actions -->
        <div class="col-md-6 mb-4">
            <div class="card shadow-lg border-0 h-100 reveal">
                <div class="card-header bg-white"><h5 class="mb-0"><i class="fas fa-bolt me-2 text-primary"></i>Quick Actions</h5></div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-6">
                            <a href="${pageContext.request.contextPath}/users" class="qa-btn qa-purple w-100">
                                <i class="fas fa-users fa-2x qa-icon"></i>
                                <span class="qa-label">User Management</span>
                            </a>
                        </div>
                        <div class="col-6">
                            <a href="${pageContext.request.contextPath}/admin/books" class="qa-btn qa-green w-100">
                                <i class="fas fa-book fa-2x qa-icon"></i>
                                <span class="qa-label">Manage Books</span>
                            </a>
                        </div>
                        <div class="col-6">
                            <a href="${pageContext.request.contextPath}/orders" class="qa-btn qa-orange w-100">
                                <i class="fas fa-truck fa-2x qa-icon"></i>
                                <span class="qa-label">View Orders</span>
                            </a>
                        </div>
                        <div class="col-6">
                            <a href="${pageContext.request.contextPath}/admin/reports" class="qa-btn qa-teal w-100">
                                <i class="fas fa-chart-bar fa-2x qa-icon"></i>
                                <span class="qa-label">Reports</span>
                            </a>
                        </div>
                        <div class="col-12">
                            <a href="${pageContext.request.contextPath}/admin/system" class="qa-btn qa-gray w-100">
                                <i class="fas fa-cogs fa-2x qa-icon"></i>
                                <span class="qa-label">System Panel</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- System Overview -->
        <div class="col-md-6 mb-4">
            <div class="card shadow-lg border-0 h-100 reveal">
                <div class="card-header bg-white"><h5 class="mb-0"><i class="fas fa-chart-pie me-2 text-primary"></i>System Overview</h5></div>
                <div class="card-body">
                    <div class="mb-4">
                        <div class="d-flex justify-content-between mb-1"><span>Active Users</span><span class="fw-bold">${totalUsers}</span></div>
                        <div class="progress"><div class="progress-bar" style="width: ${totalUsers > 100 ? 100 : totalUsers}%"></div></div>
                    </div>
                    <div class="mb-4">
                        <div class="d-flex justify-content-between mb-1"><span>Books in Inventory</span><span class="fw-bold">${totalBooks}</span></div>
                        <div class="progress"><div class="progress-bar bg-success" style="width: ${totalBooks > 500 ? 100 : totalBooks / 5}%"></div></div>
                    </div>
                    <div class="mb-4">
                        <div class="d-flex justify-content-between mb-1"><span>Orders Processed</span><span class="fw-bold">${totalOrders}</span></div>
                        <div class="progress"><div class="progress-bar bg-warning" style="width: ${totalOrders > 200 ? 100 : totalOrders / 2}%"></div></div>
                    </div>
                    <div class="mb-0">
                        <div class="d-flex justify-content-between mb-1"><span>Revenue</span><span class="fw-bold"><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="$" maxFractionDigits="2"/></span></div>
                        <div class="progress"><div class="progress-bar bg-info" style="width: ${totalRevenue > 10000 ? 100 : totalRevenue / 100}%"></div></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Admin Guide -->
    <div class="card shadow-lg border-0 reveal">
        <div class="card-header bg-white"><h5 class="mb-0"><i class="fas fa-info-circle me-2 text-primary"></i>Admin Guide</h5></div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-4"><span class="tag-pill me-2"><i class="fas fa-users me-1"></i>Users</span>View all registered users and manage accounts</div>
                <div class="col-md-4"><span class="tag-pill me-2"><i class="fas fa-book me-1"></i>Books</span>Add, edit, or remove books from inventory</div>
                <div class="col-md-4"><span class="tag-pill me-2"><i class="fas fa-truck me-1"></i>Orders</span>View all orders and update their status</div>
                <div class="col-md-4"><span class="tag-pill me-2"><i class="fas fa-chart-bar me-1"></i>Reports</span>Generate system summary reports</div>
                <div class="col-md-4"><span class="tag-pill me-2"><i class="fas fa-cogs me-1"></i>System</span>Manage admin accounts and system settings</div>
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