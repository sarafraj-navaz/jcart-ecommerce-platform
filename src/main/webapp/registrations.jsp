<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>J-Cart | Registrations</title>
<link rel="stylesheet" href="style.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
    <jsp:include page="home-buttom.jsp"></jsp:include>

    <div class="dashboard-page">
        <div class="dashboard-content">
            <div class="dashboard-hero">
                <div class="dashboard-hero-left">
                    <div class="dashboard-hero-icon">
                        <i class="fas fa-file-alt"></i>
                    </div>
                    <div>
                        <div class="auth-eyebrow"><i class="fas fa-arrow-right" style="font-size:0.5rem;"></i> Admin · Audit Log</div>
                        <h2>Registrations</h2>
                        <p class="subtitle">Live feed from the connected Google Sheet.</p>
                    </div>
                </div>
                <div class="dashboard-hero-actions">
                    <button class="btn btn-secondary" onclick="exportRegistrations()">
                        <i class="fas fa-file-export"></i> Export CSV
                    </button>
                    <button class="btn btn-secondary" onclick="refreshData()">
                        <i class="fas fa-sync-alt"></i> Refresh
                    </button>
                    <a class="btn" href="admin-home.jsp"><i class="fas fa-arrow-left"></i> Back</a>
                </div>
            </div>

            <div class="table-wrap">
                <table class="data-table" id="registrationsTable">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Timestamp</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Address</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            @SuppressWarnings("unchecked")
                            List<String[]> rows = (List<String[]>) request.getAttribute("registrations");
                            if (rows == null || rows.isEmpty()) {
                        %>
                        <tr class="empty-row"><td colspan="6">No registrations yet, or JCART_SHEETS_WEBHOOK is not configured.</td></tr>
                        <%
                            } else {
                                int index = 1;
                                for (String[] row : rows) {
                        %>
                        <tr>
                            <td><%= index++ %></td>
                            <% for (String cell : row) { %>
                            <td><%= cell != null ? cell : "" %></td>
                            <% } %>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
            
            <div style="margin-top:16px;text-align:right;font-size:12px;color:var(--text-muted);">
                <i class="fas fa-info-circle"></i> Showing <%= rows != null ? rows.size() : 0 %> registrations
            </div>
        </div>
    </div>

    <script src="script.js"></script>
    <script>
        function refreshData() {
            const btn = document.querySelector('[onclick="refreshData()"]');
            if (btn) {
                btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Loading...';
                btn.disabled = true;
                setTimeout(function() {
                    location.reload();
                }, 300);
            }
        }
        
        function exportRegistrations() {
            const table = document.getElementById('registrationsTable');
            const rows = table.querySelectorAll('tbody tr:not(.empty-row)');
            
            if (rows.length === 0) {
                showToast('No data to export', 'warning');
                return;
            }
            
            const data = [];
            rows.forEach(function(row) {
                const cells = row.querySelectorAll('td');
                if (cells.length >= 5) {
                    data.push({
                        '#': cells[0].textContent,
                        'Timestamp': cells[1].textContent,
                        'Name': cells[2].textContent,
                        'Email': cells[3].textContent,
                        'Phone': cells[4].textContent,
                        'Address': cells[5] ? cells[5].textContent : ''
                    });
                }
            });
            
            exportToCSV(data, 'registrations-export.csv');
        }
    </script>
</body>
</html>