<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Reports - Online Bookstore</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@700;800;900&family=Plus+Jakarta+Sans:ital,wght@0,400;0,500;0,600;0,700;1,400&family=Noto+Sans+Sinhala:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark fixed-top no-print">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/"><i class="fas fa-book-open me-2"></i>Online Bookstore</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"><span class="navbar-toggler-icon"></span></button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-chart-line me-1"></i>Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/books"><i class="fas fa-book me-1"></i>Books</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/users"><i class="fas fa-users me-1"></i>Users</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/orders"><i class="fas fa-truck me-1"></i>Orders</a></li>
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/reports"><i class="fas fa-chart-bar me-1"></i>Reports</a></li>
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

<div style="height: 76px;" class="no-print"></div>

<main class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-5 fade-in-up">
        <div>
            <h2 class="page-title mb-1"><i class="fas fa-chart-bar me-3"></i>System Reports</h2>
            <p class="text-muted mb-0">Overview of key metrics and recent activity</p>
        </div>
        <button onclick="window.print()" class="btn btn-primary-custom no-print"><i class="fas fa-print me-2"></i>Export Report</button>
    </div>

    <!-- KPI Row -->
    <div class="row g-4 mb-5">
        <div class="col-md-4">
            <div class="stat-card stat-success reveal stagger-1">
                <div class="stat-icon"><i class="fas fa-dollar-sign"></i></div>
                <div class="stat-value"><fmt:formatNumber value="${totalRevenue}" type="number" minFractionDigits="2" maxFractionDigits="2" var="fmtRev"/>$${fmtRev}</div>
                <div class="stat-label">Total Revenue</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card stat-accent reveal stagger-2">
                <div class="stat-icon"><i class="fas fa-clock"></i></div>
                <div class="stat-value counter-number" data-count="${pendingOrders}">${pendingOrders}</div>
                <div class="stat-label">Pending Orders</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card stat-info reveal stagger-3">
                <div class="stat-icon"><i class="fas fa-check-circle"></i></div>
                <div class="stat-value counter-number" data-count="${completedPayments}">${completedPayments}</div>
                <div class="stat-label">Completed Payments</div>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- Report Summary -->
        <div class="col-md-6 mb-4">
            <div class="card shadow-lg border-0 h-100 reveal">
                <div class="card-header bg-white">
                    <h5 class="mb-0"><i class="fas fa-file-alt me-2 text-primary"></i>Report Summary: ${reportData.reportType}</h5>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <p><strong><i class="fas fa-id-card me-2 text-primary"></i>Report ID:</strong> ${reportData.reportID}</p>
                        <p><strong><i class="fas fa-calendar me-2 text-primary"></i>Generated:</strong> ${reportData.generatedDate}</p>
                        <p><strong><i class="fas fa-user-shield me-2 text-primary"></i>By:</strong> ${reportData.generatedBy}</p>
                    </div>
                    <div class="report-console p-3 rounded">
                        <pre style="white-space:pre-wrap;font-family:monospace;font-size:12px;color:#a5b4fc;margin:0;">${reportData.content}</pre>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Orders -->
        <div class="col-md-6 mb-4">
            <div class="card shadow-lg border-0 h-100 reveal">
                <div class="card-header bg-white">
                    <h5 class="mb-0"><i class="fas fa-receipt me-2 text-primary"></i>Recent Orders (Last 10)</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light"><tr><th>Order ID</th><th>User ID</th><th>Status</th><th>Amount</th></tr></thead>
                            <tbody>
                            <c:forEach var="order" items="${recentOrders}">
                                <tr>
                                    <td><code>${order.orderID}</code></td>
                                    <td><small>${order.userID}</small></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.status == 'PENDING'}"><span class="badge-pending">PENDING</span></c:when>
                                            <c:when test="${order.status == 'CONFIRMED'}"><span class="badge-confirmed">CONFIRMED</span></c:when>
                                            <c:when test="${order.status == 'DELIVERED'}"><span class="badge-delivered">DELIVERED</span></c:when>
                                            <c:when test="${order.status == 'CANCELLED'}"><span class="badge-cancelled">CANCELLED</span></c:when>
                                        </c:choose>
                                    </td>
                                    <td class="fw-bold">$${order.totalAmount}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty recentOrders}">
                                <tr><td colspan="4" class="text-center py-4 text-muted">No orders found</td></tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="alert alert-secondary mt-2 no-print">
        <i class="fas fa-info-circle me-2"></i><strong>Export Hint:</strong> Click "Export Report" above or press <kbd>Ctrl+P</kbd> to save as PDF.
    </div>
    <div class="mt-3 no-print">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-back d-inline-flex">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>
</main>

<footer class="footer no-print">
    <div class="container"><p>&copy; 2024 Online Bookstore Management System | SE1020 Project</p></div>
</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/bookstore.js"></script>
</body>
</html>