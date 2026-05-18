<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Book Inventory - Admin</title>
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

<main class="container my-5">
  <div class="d-flex justify-content-between align-items-center mb-4 fade-in-up flex-wrap gap-3">
    <div>
      <h2 class="page-title mb-1"><i class="fas fa-book me-3"></i>Book Inventory</h2>
      <p class="text-muted mb-0">Manage all books add, edit, delete and monitor stock levels</p>
    </div>
    <a href="${pageContext.request.contextPath}/book/add" class="btn btn-primary-custom">
      <i class="fas fa-plus me-2"></i>Add New Book
    </a>
  </div>

  <c:if test="${not empty param.deleted}">
    <div class="alert alert-success alert-dismissible fade show reveal">
      <i class="fas fa-check-circle me-2"></i>Book deleted successfully.
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  </c:if>
  <c:if test="${not empty param.saved}">
    <div class="alert alert-success alert-dismissible fade show reveal">
      <i class="fas fa-check-circle me-2"></i>Book saved successfully.
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  </c:if>

  <!-- Inventory Summary Cards -->
  <div class="row g-3 mb-4">
    <div class="col-md-3 col-6">
      <div class="stat-card stat-success reveal stagger-1">
        <div class="stat-icon"><i class="fas fa-book"></i></div>
        <div class="stat-value counter-number" data-count="${books.size()}">${books.size()}</div>
        <div class="stat-label">Total Titles</div>
      </div>
    </div>
    <div class="col-md-3 col-6">
      <div class="stat-card stat-primary reveal stagger-2">
        <div class="stat-icon"><i class="fas fa-boxes"></i></div>
        <div class="stat-value" id="totalStockVal">—</div>
        <div class="stat-label">Total Stock</div>
      </div>
    </div>
    <div class="col-md-3 col-6">
      <div class="stat-card stat-accent reveal stagger-3">
        <div class="stat-icon"><i class="fas fa-exclamation-triangle"></i></div>
        <div class="stat-value" id="lowStockVal">—</div>
        <div class="stat-label">Low Stock (&lt;5)</div>
      </div>
    </div>
    <div class="col-md-3 col-6">
      <div class="stat-card stat-info reveal stagger-4">
        <div class="stat-icon"><i class="fas fa-dollar-sign"></i></div>
        <div class="stat-value" id="avgPriceVal">—</div>
        <div class="stat-label">Avg. Price</div>
      </div>
    </div>
  </div>

  <!-- Search & Filter -->
  <div class="card shadow-sm border-0 mb-4 reveal">
    <div class="card-body py-3">
      <div class="row g-2 align-items-center">
        <div class="col-md-6">
          <input type="text" id="bookSearch" class="form-control" placeholder="Search by title, author or category..." oninput="filterBooks()" autocomplete="off">
        </div>
        <div class="col-md-3">
          <select id="stockFilter" class="form-select" onchange="filterBooks()" autocomplete="off">
            <option value="">All Stock Levels</option>
            <option value="low">Low Stock (&lt;5)</option>
            <option value="out">Out of Stock</option>
            <option value="ok">In Stock (&ge;5)</option>
          </select>
        </div>
        <div class="col-md-3">
          <select id="typeFilter" class="form-select" onchange="filterBooks()" autocomplete="off">
            <option value="">All Types</option>
            <option value="EBOOK">eBook</option>
            <option value="PRINTED">Printed</option>
          </select>
        </div>
      </div>
    </div>
  </div>

  <!-- Books Table -->
  <c:if test="${empty books}">
    <div class="empty-state reveal">
      <div class="empty-state-icon"><i class="fas fa-book-open"></i></div>
      <h4>No books in inventory</h4>
      <p>Add your first book to get started!</p>
      <a href="${pageContext.request.contextPath}/book/add" class="btn btn-primary-custom mt-3"><i class="fas fa-plus me-2"></i>Add Book</a>
    </div>
  </c:if>

  <c:if test="${not empty books}">
    <div class="card shadow-sm border-0 reveal">
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table align-middle mb-0" id="booksTable">
            <thead class="table-light">
            <tr>
              <th>Book</th>
              <th>Category</th>
              <th>Type</th>
              <th class="text-end">Price</th>
              <th class="text-center">Stock</th>
              <th class="text-center">Actions</th>
            </tr>
            </thead>
            <tbody id="booksTableBody">
            <c:forEach var="book" items="${books}" varStatus="s">
              <tr class="book-row" data-title="${book.title}" data-author="${book.author}" data-category="${book.category}" data-type="${book.type}" data-stock="${book.stock}">
                <td>
                  <div class="d-flex align-items-center gap-3">
                    <div class="book-cover-area" style="width:44px;height:44px;border-radius:var(--r-sm);flex-shrink:0;">
                      <i class="fas fa-book" style="font-size:1.1rem;"></i>
                    </div>
                    <div>
                      <div class="fw-semibold">${book.title}</div>
                      <small class="text-muted">by ${book.author}</small><br>
                      <small class="text-muted font-monospace">${book.bookID}</small>
                    </div>
                  </div>
                </td>
                <td><span class="tag-pill">${book.category}</span></td>
                <td>
                  <c:choose>
                    <c:when test="${book.type == 'EBOOK'}"><span class="badge bg-info text-dark"><i class="fas fa-tablet-alt me-1"></i>eBook</span></c:when>
                    <c:otherwise><span class="badge bg-secondary"><i class="fas fa-print me-1"></i>Printed</span></c:otherwise>
                  </c:choose>
                </td>
                <td class="text-end fw-bold price">$<fmt:formatNumber value="${book.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                <td class="text-center">
                  <c:choose>
                    <c:when test="${book.stock == 0}">
                      <span class="badge bg-danger"><i class="fas fa-times-circle me-1"></i>Out of Stock</span>
                    </c:when>
                    <c:when test="${book.stock < 5}">
                      <span class="badge bg-warning text-dark"><i class="fas fa-exclamation-triangle me-1"></i>${book.stock} left</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge bg-success"><i class="fas fa-check-circle me-1"></i>${book.stock}</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td class="text-center" style="white-space:nowrap;">
                  <a href="${pageContext.request.contextPath}/book/edit?bookID=${book.bookID}"
                     class="btn btn-sm me-1 fw-semibold"
                     style="background:#6c63ff;color:#fff;border:none;border-radius:8px;padding:6px 14px;">
                    <i class="fas fa-edit me-1"></i>Edit
                  </a>
                  <form action="${pageContext.request.contextPath}/book/delete" method="post" class="d-inline" data-confirm="Delete '${book.title}'? This cannot be undone.">
                    <input type="hidden" name="bookID" value="${book.bookID}">
                    <button type="submit" class="btn btn-sm fw-semibold" title="Delete" style="background:#dc3545;color:#fff;border:none;border-radius:8px;padding:6px 14px;">
                      <i class="fas fa-trash me-1"></i>Delete
                    </button>
                  </form>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
        </div>
      </div>
      <div class="card-footer bg-white text-muted small d-flex justify-content-between align-items-center">
        <span id="tableCount">${books.size()} books total</span>
        <a href="${pageContext.request.contextPath}/book/add" class="btn btn-sm btn-primary-custom"><i class="fas fa-plus me-1"></i>Add Book</a>
      </div>
    </div>
  </c:if>
</main>

<!-- ===== EDIT BOOK MODAL ===== -->
<div class="modal fade" id="editBookModal" tabindex="-1" aria-labelledby="editBookModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content" style="border-radius:16px;border:none;box-shadow:0 20px 60px rgba(0,0,0,.2);">
      <div class="modal-header border-0 pb-0 px-4 pt-4">
        <div>
          <h4 class="modal-title fw-bold mb-1" id="editBookModalLabel"><i class="fas fa-edit me-2" style="color:#6c63ff;"></i>Edit Book</h4>
          <p class="text-muted small mb-0" id="editBookIDDisplay"></p>
        </div>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body px-4 py-3">
        <form id="editBookForm" action="${pageContext.request.contextPath}/book/edit" method="post">
          <input type="hidden" name="bookID" id="editBookID">

          <div class="row g-3">
            <!-- Title -->
            <div class="col-md-8">
              <label class="form-label fw-semibold"><i class="fas fa-heading me-1 text-muted"></i>Title <span class="text-danger">*</span></label>
              <input type="text" class="form-control" name="title" id="editTitle" required placeholder="Book title">
            </div>
            <!-- Type -->
            <div class="col-md-4">
              <label class="form-label fw-semibold"><i class="fas fa-tag me-1 text-muted"></i>Type <span class="text-danger">*</span></label>
              <select class="form-select" name="type" id="editType" onchange="toggleEditTypeFields()">
                <option value="PRINTED">Printed Book</option>
                <option value="EBOOK">eBook</option>
              </select>
            </div>
            <!-- Author -->
            <div class="col-md-6">
              <label class="form-label fw-semibold"><i class="fas fa-user-edit me-1 text-muted"></i>Author <span class="text-danger">*</span></label>
              <input type="text" class="form-control" name="author" id="editAuthor" required placeholder="Author name">
            </div>
            <!-- Category -->
            <div class="col-md-6">
              <label class="form-label fw-semibold"><i class="fas fa-folder me-1 text-muted"></i>Category <span class="text-danger">*</span></label>
              <input type="text" class="form-control" name="category" id="editCategory" required placeholder="e.g. Fiction, Science, Programming">
            </div>
            <!-- Price -->
            <div class="col-md-4">
              <label class="form-label fw-semibold"><i class="fas fa-dollar-sign me-1 text-muted"></i>Price ($) <span class="text-danger">*</span></label>
              <input type="number" class="form-control" name="price" id="editPrice" required min="0" step="0.01" placeholder="0.00">
            </div>
            <!-- Stock -->
            <div class="col-md-4">
              <label class="form-label fw-semibold"><i class="fas fa-boxes me-1 text-muted"></i>Stock <span class="text-danger">*</span></label>
              <input type="number" class="form-control" name="stock" id="editStock" required min="0" placeholder="0">
            </div>
            <!-- Page Count (Printed only) -->
            <div class="col-md-4" id="editPageCountGroup">
              <label class="form-label fw-semibold"><i class="fas fa-file me-1 text-muted"></i>Page Count</label>
              <input type="number" class="form-control" name="pageCount" id="editPageCount" min="0" placeholder="Number of pages">
            </div>
            <!-- Download URL (eBook only) -->
            <div class="col-12" id="editDownloadURLGroup" style="display:none;">
              <label class="form-label fw-semibold"><i class="fas fa-link me-1 text-muted"></i>Download URL</label>
              <input type="text" class="form-control" name="downloadURL" id="editDownloadURL" placeholder="https://...">
            </div>
          </div>

          <!-- Live Preview Strip -->
          <div class="mt-4 p-3 rounded-3" style="background:#f8f7ff;border:1px solid #e8e5ff;">
            <div class="row align-items-center g-2">
              <div class="col-auto">
                <div style="width:40px;height:40px;background:linear-gradient(135deg,#6c63ff,#a78bfa);border-radius:8px;display:flex;align-items:center;justify-content:center;">
                  <i class="fas fa-book text-white"></i>
                </div>
              </div>
              <div class="col">
                <div class="fw-bold" id="previewTitle" style="color:#6c63ff;">—</div>
                <small class="text-muted" id="previewAuthor">—</small>
              </div>
              <div class="col-auto text-end">
                <div class="fw-bold fs-5" id="previewPrice" style="color:#6c63ff;">$—</div>
                <small class="text-muted" id="previewStock">Stock: —</small>
              </div>
            </div>
          </div>
        </form>
      </div>
      <div class="modal-footer border-0 px-4 pb-4 pt-0 gap-2">
        <button type="button" class="btn btn-light fw-semibold px-4" data-bs-dismiss="modal">Cancel</button>
        <button type="submit" form="editBookForm" class="btn fw-semibold px-4" style="background:#6c63ff;color:#fff;border:none;border-radius:10px;">
          <i class="fas fa-save me-2"></i>Save Changes
        </button>
      </div>
    </div>
  </div>
</div>

<footer class="footer">
  <div class="container"><p>&copy; 2024 Online Bookstore Management System | SE1020 Project</p></div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/bookstore.js"></script>
<script>
  // Compute inventory stats from DOM
  (function(){
    const rows = document.querySelectorAll('.book-row');
    let totalStock = 0, lowStock = 0, totalPrice = 0, count = rows.length;
    rows.forEach(r => {
      const stock = parseInt(r.dataset.stock) || 0;
      totalStock += stock;
      if (stock < 5) lowStock++;
      const priceCell = r.querySelector('.price');
      if (priceCell) {
        const p = parseFloat(priceCell.textContent.replace('$','').replace(',',''));
        if (!isNaN(p)) totalPrice += p;
      }
    });
    document.getElementById('totalStockVal').textContent = totalStock;
    document.getElementById('lowStockVal').textContent = lowStock;
    document.getElementById('avgPriceVal').textContent = count > 0 ? '$' + (totalPrice / count).toFixed(2) : '$0.00';
  })();

  function filterBooks() {
    const search = (document.getElementById('bookSearch').value || '').toLowerCase();
    const stockF = document.getElementById('stockFilter').value;
    const typeF  = document.getElementById('typeFilter').value;
    const rows = document.querySelectorAll('.book-row');
    let visible = 0;
    rows.forEach(r => {
      const text = (r.dataset.title + ' ' + r.dataset.author + ' ' + r.dataset.category).toLowerCase();
      const stock = parseInt(r.dataset.stock) || 0;
      const type  = r.dataset.type || '';

      const matchSearch = !search || text.includes(search);
      const matchStock  = !stockF ||
              (stockF === 'out' && stock === 0) ||
              (stockF === 'low' && stock > 0 && stock < 5) ||
              (stockF === 'ok'  && stock >= 5);
      const matchType = !typeF || type === typeF;

      const show = matchSearch && matchStock && matchType;
      r.style.display = show ? '' : 'none';
      if (show) visible++;
    });
    const countEl = document.getElementById('tableCount');
    if (countEl) countEl.textContent = visible + ' books shown';
  }

  // ── Edit Modal ────────────────────────────────────────────────────
  function openEditModal(bookID, title, author, category, price, stock, type) {
    document.getElementById('editBookID').value    = bookID;
    document.getElementById('editTitle').value     = title;
    document.getElementById('editAuthor').value    = author;
    document.getElementById('editCategory').value  = category;
    document.getElementById('editPrice').value     = price;
    document.getElementById('editStock').value     = stock;
    document.getElementById('editType').value      = type;
    document.getElementById('editBookIDDisplay').textContent = 'Book ID: ' + bookID;

    toggleEditTypeFields();
    updatePreview();

    ['editTitle','editAuthor','editPrice','editStock'].forEach(id => {
      document.getElementById(id).addEventListener('input', updatePreview);
    });

    new bootstrap.Modal(document.getElementById('editBookModal')).show();
  }

  function toggleEditTypeFields() {
    const type = document.getElementById('editType').value;
    document.getElementById('editPageCountGroup').style.display    = (type === 'PRINTED') ? '' : 'none';
    document.getElementById('editDownloadURLGroup').style.display  = (type === 'EBOOK')   ? '' : 'none';
  }

  function updatePreview() {
    const title  = document.getElementById('editTitle').value  || '—';
    const author = document.getElementById('editAuthor').value || '—';
    const price  = document.getElementById('editPrice').value;
    const stock  = document.getElementById('editStock').value;
    document.getElementById('previewTitle').textContent  = title;
    document.getElementById('previewAuthor').textContent = 'by ' + author;
    document.getElementById('previewPrice').textContent  = price ? '$' + parseFloat(price).toFixed(2) : '$—';
    document.getElementById('previewStock').textContent  = 'Stock: ' + (stock !== '' ? stock : '—');
  }

  // Reset filters and show all books on every page load
  document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('stockFilter').value = '';
    document.getElementById('typeFilter').value  = '';
    document.getElementById('bookSearch').value  = '';
    filterBooks();
  });
</script>
</body>
</html>
