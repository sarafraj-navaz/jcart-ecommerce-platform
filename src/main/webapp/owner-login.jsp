<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>J-Cart | Owner Login</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
    <jsp:include page="home-buttom.jsp"></jsp:include>

    <%
    String incorrectOwnerEmail = (String) request.getAttribute("incorrectOwnerEmail");
    String incorrectOwnerPass = (String) request.getAttribute("incorrectOwnerPass");
    String unverified = (String) request.getAttribute("unverified");
    String otpError = (String) request.getAttribute("otpError");
    String resetSuccess = (String) request.getAttribute("resetSuccess");
    %>

    <div class="auth-page">
        <div class="auth-card">
            <div class="auth-eyebrow">Product Owner</div>
            <h2 class="auth-title">Welcome Back</h2>
            <p class="auth-subtitle">Sign in to manage your storefront.</p>

            <% if (incorrectOwnerEmail != null) { %>
            <div class="alert alert-error"><%= incorrectOwnerEmail %></div>
            <% } %>
            <% if (incorrectOwnerPass != null) { %>
            <div class="alert alert-error"><%= incorrectOwnerPass %></div>
            <% } %>
            <% if (unverified != null) { %>
            <div class="alert alert-error"><%= unverified %></div>
            <% } %>
            <% if (otpError != null) { %>
            <div class="alert alert-error"><%= otpError %></div>
            <% } %>
            <% if (resetSuccess != null) { %>
            <div class="alert alert-success"><%= resetSuccess %></div>
            <% } %>

            <form class="auth-form" id="ownerPasswordForm" action="ownerLogin" method="post">
                <div class="form-group">
                    <label for="OwnerEmail">Email</label>
                    <input type="email" id="OwnerEmail" name="OwnerEmail" placeholder="you@example.com">
                </div>
                <div class="form-group password-field">
                    <label for="OwnerPassword">Password</label>
                    <input type="password" id="OwnerPassword" name="OwnerPassword" placeholder="Enter your password">
                    <button type="button" class="password-toggle">SHOW</button>
                </div>
                <button type="submit" class="btn btn-primary btn-block">Login</button>
            </form>

            <p class="auth-footer">New owner? <a href="owner-register.jsp">Create an account</a></p>
        </div>
    </div>

    <script src="script.js"></script>
</body>
</html>
