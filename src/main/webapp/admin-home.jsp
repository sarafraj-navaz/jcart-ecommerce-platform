<%@page import="com.jsp.jcart.ecommerce.dto.ProductOwner"%>
<%@page import="java.util.List"%>
<%@page import="com.jsp.jcart.ecommerce.dao.ProductOwnerDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>J-Cart | Admin Dashboard</title>
<link rel="stylesheet" href="style.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
    <jsp:include page="home-buttom.jsp"></jsp:include>

    <%
    ProductOwnerDao adminOwnerDao = new ProductOwnerDao();
    List<ProductOwner> allOwners = adminOwnerDao.displayAllProductOwnerDao();
    int totalOwners = allOwners == null ? 0 : allOwners.size();
    int verifiedTotal = 0, pendingTotal = 0;
    if (allOwners != null) {
        for (ProductOwner o : allOwners) {
            if ("yes".equalsIgnoreCase(o.getVerify())) { verifiedTotal++; } else { pendingTotal++; }
        }
    }
    
    // Get admin name from session
    String adminName = (String) session.getAttribute("adminName");
    if (adminName == null) adminName = "Admin";
    
    // Get messages
    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg = (String) session.getAttribute("errorMsg");
    if (successMsg != null) session.removeAttribute("successMsg");
    if (errorMsg != null) session.removeAttribute("errorMsg");
    %>

    <div class="dashboard-page">
        <div class="dashboard-content">
            
            <!-- Toast Messages -->
            <% if (successMsg != null) { %>
            <div class="alert alert-success"><i class="fas fa-check-circle"></i> <%= successMsg %></div>
            <% } %>
            <% if (errorMsg != null) { %>
            <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> <%= errorMsg %></div>
            <% } %>

            <!-- Hero -->
            <div class="dashboard-hero">
                <div class="dashboard-hero-left">
                    <div class="dashboard-hero-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <div>
                        <div class="auth-eyebrow"><i class="fas fa-arrow-right" style="font-size:0.5rem;"></i> Admin Control Panel</div>
                        <h2>Welcome back, <%= adminName %></h2>
                        <p class="subtitle">Review product owner verifications and manage the J-Cart marketplace.</p>
                    </div>
                </div>
                <div class="dashboard-hero-actions">
                    <a class="btn btn-primary" href="registrations">
                        <i class="fas fa-users"></i> View Registrations
                    </a>
                    <button class="btn btn-secondary" onclick="refreshData()">
                        <i class="fas fa-sync-alt"></i> Refresh
                    </button>
                    <a class="btn btn-danger" href="logout" data-confirm="Log out of the admin panel?">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </div>
            </div>

            <!-- Stats -->
            <div class="stat-grid">
                <div class="stat-card">
                    <div class="stat-icon"><i class="fas fa-users"></i></div>
                    <div class="stat-label"><i class="fas fa-users" style="margin-right:4px;"></i> Total Owners</div>
                    <div class="stat-value"><%= totalOwners %></div>
                    <div class="stat-change"><i class="fas fa-circle" style="color:var(--gold);font-size:0.4rem;"></i> Active marketplace</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon"><i class="fas fa-check-circle"></i></div>
                    <div class="stat-label"><i class="fas fa-check-circle" style="margin-right:4px;"></i> Verified</div>
                    <div class="stat-value"><%= verifiedTotal %></div>
                    <div class="stat-change"><i class="fas fa-check" style="color:var(--success);font-size:0.4rem;"></i> Approved sellers</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon"><i class="fas fa-clock"></i></div>
                    <div class="stat-label"><i class="fas fa-clock" style="margin-right:4px;"></i> Pending Approval</div>
                    <div class="stat-value"><%= pendingTotal %></div>
                    <div class="stat-change"><i class="fas fa-hourglass-half" style="color:var(--warning);font-size:0.4rem;"></i> Awaiting review</div>
                </div>
            </div>

            <!-- Verification Section -->
            <div class="section">
                <div class="section-header">
                    <div class="section-title">
                        <span class="eyebrow-dot"></span>
                        Owner Verification Center
                    </div>
                    <div class="section-actions">
                        <button class="btn btn-sm btn-outline" onclick="selectAll()">
                            <i class="fas fa-check-double"></i> Select All
                        </button>
                        <button class="btn btn-sm btn-outline" onclick="exportData()">
                            <i class="fas fa-file-export"></i> Export
                        </button>
                    </div>
                </div>
                <div class="verify-columns">
                    <jsp:include page="verify-owner.jsp"></jsp:include>
                    <jsp:include page="unverify-owner.jsp"></jsp:include>
                </div>
            </div>

        </div>
    </div>

    <script src="script.js"></script>
    <script>
        function refreshData() {
            const btn = document.querySelector('[onclick="refreshData()"]');
            if (btn) {
                btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Loading...';
                btn.classList.add('btn-loading');
                setTimeout(function() {
                    location.reload();
                }, 300);
            }
        }
        
        function selectAll() {
            const cards = document.querySelectorAll('.owner-card');
            const isSelected = cards[0]?.style.borderColor === 'var(--gold)';
            
            cards.forEach(function(card) {
                if (isSelected) {
                    card.style.borderColor = '';
                    card.style.background = '';
                } else {
                    card.style.borderColor = 'var(--gold)';
                    card.style.background = 'var(--gold-soft)';
                }
            });
            
            showToast(isSelected ? 'Deselected all' : 'Selected all owners', 'info');
        }
        
        function exportData() {
            const data = [];
            document.querySelectorAll('.owner-card').forEach(function(card) {
                const name = card.querySelector('.owner-name')?.textContent || '';
                const email = card.querySelector('.owner-meta')?.textContent?.split('·')[0]?.trim() || '';
                const phone = card.querySelector('.owner-meta')?.textContent?.split('·')[1]?.trim() || '';
                const status = card.closest('.is-verified') ? 'Verified' : 'Pending';
                data.push({ Name: name, Email: email, Phone: phone, Status: status });
            });
            
            if (data.length === 0) {
                showToast('No data to export', 'warning');
                return;
            }
            
            exportToCSV(data, 'owners-export.csv');
        }
        
        // Keyboard shortcut: Ctrl+Shift+R = Refresh
        document.addEventListener('keydown', function(e) {
            if (e.ctrlKey && e.shiftKey && (e.key === 'r' || e.key === 'R')) {
                e.preventDefault();
                refreshData();
            }
        });
    </script>
</body>
</html>