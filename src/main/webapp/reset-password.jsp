<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>J-Cart | Reset Password</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
    <jsp:include page="home-buttom.jsp"></jsp:include>

    <%
    String role = (String) request.getAttribute("role");
    String contact = (String) request.getAttribute("contact");
    String otpSent = (String) request.getAttribute("otpSent");
    String otpError = (String) request.getAttribute("otpError");
    String resetError = (String) request.getAttribute("resetError");
    boolean isOwner = "owner".equalsIgnoreCase(role);
    String backLink = isOwner ? "owner-login.jsp" : "user-login.jsp";
    String eyebrow = isOwner ? "Product Owner" : "User";
    %>

    <div class="auth-page">
        <div class="auth-card">
            <div class="auth-eyebrow"><%= eyebrow %></div>
            <h2 class="auth-title">Reset Your Password</h2>
            <p class="auth-subtitle">Enter the code we sent you and choose a new password.</p>

            <% if (otpSent != null) { %>
            <div class="alert alert-success"><%= otpSent %></div>
            <% } %>
            <% if (otpError != null) { %>
            <div class="alert alert-error"><%= otpError %></div>
            <% } %>
            <% if (resetError != null) { %>
            <div class="alert alert-error"><%= resetError %></div>
            <% } %>

            <form class="auth-form" action="reset-password" method="post">
                <input type="hidden" name="role" value="<%= isOwner ? "owner" : "user" %>">

                <div class="form-group">
                    <label for="contact">Email or Phone Number</label>
                    <input type="text" id="contact" name="contact"
                           value="<%= contact != null ? contact : "" %>" placeholder="you@example.com or phone number" required>
                </div>
                <div class="form-group">
                    <label for="otp">6-digit Code</label>
                    <input type="text" id="otp" name="otp" maxlength="6" inputmode="numeric" placeholder="123456" required>
                </div>
                <div class="form-group password-field">
                    <label for="newPassword">New Password</label>
                    <input type="password" id="newPassword" name="newPassword" placeholder="8-15 chars, letter + number + special char" required>
                    <button type="button" class="password-toggle">SHOW</button>
                </div>
                <div class="form-group password-field">
                    <label for="confirmPassword">Confirm New Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Re-enter new password" required>
                    <button type="button" class="password-toggle">SHOW</button>
                </div>
                <button type="submit" class="btn btn-primary btn-block">Reset Password</button>
            </form>

            <p class="auth-footer">
                Remembered your password? <a href="<%= backLink %>">Back to login</a>
            </p>
        </div>
    </div>

    <script src="script.js"></script>
</body>
</html>
