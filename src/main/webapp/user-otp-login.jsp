<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>J-Cart | User OTP Login</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
    <jsp:include page="home-buttom.jsp"></jsp:include>

    <%
    String otpContact = (String) request.getAttribute("otpContact");
    String otpSent = (String) request.getAttribute("otpSent");
    String otpError = (String) request.getAttribute("otpError");
    %>

    <div class="auth-page">
        <div class="auth-card">
            <div class="auth-eyebrow">User</div>
            <h2 class="auth-title">Enter Your Code</h2>
            <p class="auth-subtitle">We sent a 6-digit login code to your email or phone.</p>

            <% if (otpSent != null) { %>
            <div class="alert alert-success"><%= otpSent %></div>
            <% } %>
            <% if (otpError != null) { %>
            <div class="alert alert-error"><%= otpError %></div>
            <% } %>

            <form class="auth-form" action="user-verify-login-otp" method="post">
                <div class="form-group">
                    <label for="userContact">Email or Phone Number</label>
                    <input type="text" id="userContact" name="userContact"
                           value="<%= otpContact != null ? otpContact : "" %>" placeholder="you@example.com or phone number" required>
                </div>
                <div class="form-group">
                    <label for="otp">6-digit Code</label>
                    <input type="text" id="otp" name="otp" maxlength="6" inputmode="numeric" placeholder="123456" required>
                </div>
                <button type="submit" class="btn btn-primary btn-block">Verify &amp; Login</button>
            </form>

            <p class="auth-footer">
                Didn't get a code? <a href="user-login.jsp">Back to login</a>
            </p>
        </div>
    </div>

    <script src="script.js"></script>
</body>
</html>
