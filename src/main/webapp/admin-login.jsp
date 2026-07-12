<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>J-Cart | Admin Login</title>
<link rel="stylesheet" href="style.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
    <jsp:include page="home-buttom.jsp"></jsp:include>

    <%
    String incorrectEmail = (String) request.getAttribute("incorrectadminEmail");
    String incorrectPassword = (String) request.getAttribute("incorrectadminPassword");
    %>

    <div class="auth-page">
        <div class="auth-card">
            <div class="auth-eyebrow"><i class="fas fa-shield-alt" style="margin-right:6px;"></i> Administrator</div>
            <h2 class="auth-title">Welcome Back</h2>
            <p class="auth-subtitle">Sign in to the admin control panel.</p>

            <% if (incorrectEmail != null) { %>
            <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> <%= incorrectEmail %></div>
            <% } %>
            <% if (incorrectPassword != null) { %>
            <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> <%= incorrectPassword %></div>
            <% } %>

            <form class="auth-form" action="adminLogin" method="post" id="loginForm">
                <div class="form-group">
                    <label for="adminEmail"><i class="fas fa-envelope" style="margin-right:4px;"></i> Admin Email</label>
                    <input type="email" id="adminEmail" name="adminEmail" placeholder="you@jcart.com" required>
                </div>
                <div class="form-group password-field">
                    <label for="adminPassword"><i class="fas fa-lock" style="margin-right:4px;"></i> Password</label>
                    <input type="password" id="adminPassword" name="adminPassword" placeholder="Enter your password" required>
                    <button type="button" class="password-toggle">SHOW</button>
                </div>
                <button type="submit" class="btn btn-primary btn-block" id="loginBtn">
                    <i class="fas fa-sign-in-alt"></i> Login
                </button>
            </form>

            <p class="auth-footer">Not an admin? <a href="app-home.jsp">Back to role selection</a></p>
        </div>
    </div>

    <script src="script.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('loginForm');
            const btn = document.getElementById('loginBtn');
            
            form.addEventListener('submit', function() {
                btn.innerHTML = '<span class="spinner"></span> Logging in...';
                btn.classList.add('btn-loading');
                btn.disabled = true;
            });
        });
    </script>
</body>
</html>