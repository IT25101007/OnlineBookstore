<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${action == 'add' ? 'Add' : 'Edit'} Book - Online Bookstore</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@700;800;900&family=Plus+Jakarta+Sans:ital,wght@0,400;0,500;0,600;0,700;1,400&display=swap" rel="stylesheet">
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
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/books"><i class="fas fa-book me-1"></i>Books</a></li>
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

<%-- Safely extract subclass-specific values into page-scope strings --%>
<c:set var="bookPageCount" value="0"/>
<c:set var="bookDownloadURL" value=""/>
<c:if test="${not empty book}">
    <%-- Use instanceOf check via JSTL --%>
    <c:if test="${book['class'].simpleName == 'PrintedBook'}">
        <c:set var="bookPageCount" value="${book.pageCount}"/>
    </c:if>
    <c:if test="${book['class'].simpleName == 'EBook'}">
        <c:set var="bookDownloadURL" value="${book.downloadURL}"/>
    </c:if>
</c:if>

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-7">

            <!-- Back link -->
            <a href="${pageContext.request.contextPath}/admin/books" class="btn-back d-inline-flex mb-4">
                <i class="fas fa-arrow-left"></i> Back to Inventory
            </a>

            <div class="card shadow-lg border-0 fade-in-up" style="border-radius:16px;overflow:hidden;">
                <div class="card-header border-0 py-4 text-center" style="background:linear-gradient(135deg,#6c63ff 0%,#a78bfa 100%);">
                    <i class="fas ${action == 'add' ? 'fa-plus-circle' : 'fa-edit'} fa-3x text-white mb-2"></i>
                    <h3 class="mb-0 fw-bold text-white">${action == 'add' ? 'Add New Book' : 'Edit Book'}</h3>
                    <c:if test="${not empty book}">
                        <p class="text-white-50 small mb-0 mt-1">${book.bookID}</p>
                    </c:if>
                </div>

                <div class="card-body p-4">
                    <form id="bookForm" action="${pageContext.request.contextPath}/book/${action}" method="post">
                        <c:if test="${action == 'edit'}">
                            <input type="hidden" name="bookID" value="${book.bookID}">
                        </c:if>

                        <!-- Title & Author -->
                        <div class="row g-3 mb-3">
                            <div class="col-md-7">
                                <label class="form-label fw-semibold"><i class="fas fa-heading me-1 text-muted"></i>Title <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="title" id="titleInput"
                                       value="${not empty book ? book.title : ''}" required placeholder="Book title">
                            </div>
                            <div class="col-md-5">
                                <label class="form-label fw-semibold"><i class="fas fa-tag me-1 text-muted"></i>Category <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="category" id="categoryInput"
                                       value="${not empty book ? book.category : ''}" required placeholder="e.g. Fiction, Science">
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold"><i class="fas fa-user-edit me-1 text-muted"></i>Author <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="author" id="authorInput"
                                       value="${not empty book ? book.author : ''}" required placeholder="Author name">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-semibold"><i class="fas fa-dollar-sign me-1 text-muted"></i>Price ($) <span class="text-danger">*</span></label>
                                <input type="number" step="0.01" class="form-control" name="price" id="priceInput"
                                       value="${not empty book ? book.price : ''}" required min="0" placeholder="0.00">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-semibold"><i class="fas fa-boxes me-1 text-muted"></i>Stock <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" name="stock" id="stockInput"
                                       value="${not empty book ? book.stock : ''}" required min="0" placeholder="0">
                            </div>
                        </div>

                        <!-- Book Type -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold"><i class="fas fa-book me-1 text-muted"></i>Book Type <span class="text-danger">*</span></label>
                            <div class="row g-2">
                                <div class="col-6">
                                    <label class="w-100 cursor-pointer">
                                        <input type="radio" name="type" value="PRINTED" id="typePrinted"
                                               onchange="toggleTypeFields()"
                                               ${empty book || book.type == 'PRINTED' ? 'checked' : ''} hidden>
                                        <div class="type-card text-center p-3 ${empty book || book.type == 'PRINTED' ? 'selected' : ''}" id="cardPrinted"
                                             onclick="document.getElementById('typePrinted').checked=true;toggleTypeFields();selectTypeCard('cardPrinted','cardEbook');"
                                             style="cursor:pointer;border-radius:12px;border:2px solid #e2e8f0;transition:all .2s;">
                                            <i class="fas fa-book fa-2x text-success d-block mb-1"></i>
                                            <div class="fw-bold">Printed Book</div>
                                            <small class="text-muted">Physical copy</small>
                                        </div>
                                    </label>
                                </div>
                                <div class="col-6">
                                    <label class="w-100 cursor-pointer">
                                        <input type="radio" name="type" value="EBOOK" id="typeEbook"
                                               onchange="toggleTypeFields()"
                                               ${not empty book && book.type == 'EBOOK' ? 'checked' : ''} hidden>
                                        <div class="type-card text-center p-3 ${not empty book && book.type == 'EBOOK' ? 'selected' : ''}" id="cardEbook"
                                             onclick="document.getElementById('typeEbook').checked=true;toggleTypeFields();selectTypeCard('cardEbook','cardPrinted');"
                                             style="cursor:pointer;border-radius:12px;border:2px solid #e2e8f0;transition:all .2s;">
                                            <i class="fas fa-tablet-alt fa-2x text-primary d-block mb-1"></i>
                                            <div class="fw-bold">eBook</div>
                                            <small class="text-muted">Digital download</small>
                                        </div>
                                    </label>
                                </div>
                            </div>
                        </div>

                        <!-- Printed-only: page count -->
                        <div id="printedFields" class="mb-3" style="display:${not empty book && book.type == 'EBOOK' ? 'none' : 'block'};">
                            <label class="form-label fw-semibold"><i class="fas fa-file-alt me-1 text-muted"></i>Page Count</label>
                            <input type="number" class="form-control" name="pageCount" id="pageCount"
                                   value="${bookPageCount}" min="0" placeholder="Number of pages">
                        </div>

                        <!-- eBook-only: download URL -->
                        <div id="ebookFields" class="mb-3" style="display:${not empty book && book.type == 'EBOOK' ? 'block' : 'none'};">
                            <label class="form-label fw-semibold"><i class="fas fa-link me-1 text-muted"></i>Download URL</label>
                            <input type="text" class="form-control" name="downloadURL" id="downloadURL"
                                   value="${bookDownloadURL}" placeholder="https://example.com/book.pdf">
                        </div>

                        <!-- Live Preview -->
                        <div class="p-3 rounded-3 mb-4" style="background:#f8f7ff;border:1px solid #e8e5ff;">
                            <div class="d-flex align-items-center gap-3">
                                <div style="width:46px;height:46px;background:linear-gradient(135deg,#6c63ff,#a78bfa);border-radius:10px;display:flex;align-items:center;justify-content:center;flex-shrink:0;">
                                    <i class="fas fa-book text-white"></i>
                                </div>
                                <div class="flex-grow-1">
                                    <div class="fw-bold" id="previewTitle" style="color:#6c63ff;">${not empty book ? book.title : 'Book Title'}</div>
                                    <small class="text-muted" id="previewAuthor">by ${not empty book ? book.author : 'Author'}</small>
                                </div>
                                <div class="text-end">
                                    <div class="fw-bold fs-5" id="previewPrice" style="color:#6c63ff;">$${not empty book ? book.price : '0.00'}</div>
                                    <small class="text-muted" id="previewStock">Stock: ${not empty book ? book.stock : '0'}</small>
                                </div>
                            </div>
                        </div>

                        <!-- Buttons -->
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn flex-grow-1 fw-bold py-2"
                                    style="background:#6c63ff;color:#fff;border:none;border-radius:10px;">
                                <i class="fas ${action == 'add' ? 'fa-plus' : 'fa-save'} me-2"></i>${action == 'add' ? 'Add Book' : 'Save Changes'}
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/books"
                               class="btn fw-bold py-2 px-4" style="background:#e2e8f0;color:#4a5568;border:none;border-radius:10px;">
                                <i class="fas fa-times me-1"></i>Cancel
                            </a>
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
<script>
function toggleTypeFields() {
    const isPrinted = document.getElementById('typePrinted').checked;
    document.getElementById('printedFields').style.display = isPrinted ? 'block' : 'none';
    document.getElementById('ebookFields').style.display   = isPrinted ? 'none'  : 'block';
}
function selectTypeCard(activeId, inactiveId) {
    document.getElementById(activeId).style.borderColor   = '#6c63ff';
    document.getElementById(activeId).style.background    = '#f3f0ff';
    document.getElementById(inactiveId).style.borderColor = '#e2e8f0';
    document.getElementById(inactiveId).style.background  = '';
}
// Live preview
document.getElementById('titleInput').addEventListener('input',  function(){ document.getElementById('previewTitle').textContent = this.value || 'Book Title'; });
document.getElementById('authorInput').addEventListener('input', function(){ document.getElementById('previewAuthor').textContent = 'by ' + (this.value || 'Author'); });
document.getElementById('priceInput').addEventListener('input',  function(){ document.getElementById('previewPrice').textContent  = '$' + (parseFloat(this.value)||0).toFixed(2); });
document.getElementById('stockInput').addEventListener('input',  function(){ document.getElementById('previewStock').textContent  = 'Stock: ' + (this.value || '0'); });
// Init card styles on load
window.addEventListener('DOMContentLoaded', function(){
    if (document.getElementById('typePrinted').checked) {
        selectTypeCard('cardPrinted','cardEbook');
    } else {
        selectTypeCard('cardEbook','cardPrinted');
    }
});
</script>
</body>
</html>
