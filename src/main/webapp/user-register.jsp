<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>J-Cart | User Sign Up</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
    <jsp:include page="home-buttom.jsp"></jsp:include>

    <% String msgPass = (String) request.getAttribute("passwordMessage"); %>

    <div class="auth-page">
        <div class="auth-card wide">
            <div class="auth-eyebrow">User</div>
            <h2 class="auth-title">Create Your Account</h2>
            <p class="auth-subtitle">Join J-Cart to start shopping.</p>

            <% if (msgPass != null) { %>
            <div class="alert alert-error"><%= msgPass %></div>
            <% } %>

            <form class="auth-form" action="userRegister" method="post">
                <div class="form-group">
                    <label for="userName">Username</label>
                    <input type="text" id="userName" name="userName" placeholder="Your username">
                </div>
                <div class="form-group">
                    <label for="userEmail">Email</label>
                    <input type="email" id="userEmail" name="userEmail" placeholder="you@example.com">
                </div>
                <div class="form-group">
                    <label for="userPhone">Phone</label>
                    <input type="tel" id="userPhone" name="userPhone" placeholder="10-digit mobile number">
                </div>
                <div class="form-group password-field">
                    <label for="userPassword">Password</label>
                    <input type="password" id="userPassword" name="userPassword" placeholder="Create a password">
                    <button type="button" class="password-toggle">SHOW</button>
                </div>
                <div class="form-group">
                    <label for="userAddress">Address</label>
                    <input type="text" id="userAddress" name="userAddress" placeholder="Your delivery address">
                </div>
                <button type="submit" class="btn btn-primary btn-block">Sign Up</button>
            </form>

            <p class="auth-footer">Already have an account? <a href="user-login.jsp">Sign in</a></p>
        </div>
    </div>

    <script src="script.js"></script>
</body>
</html>
