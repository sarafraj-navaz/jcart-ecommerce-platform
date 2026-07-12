<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>J-Cart | My Account</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
    <jsp:include page="home-buttom.jsp"></jsp:include>

    <div class="dashboard-page">
        <div class="dashboard-content">
            <div class="dashboard-hero">
                <div class="dashboard-hero-left">
                    <div class="dashboard-hero-icon">
                        <svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                    </div>
                    <div>
                        <div class="auth-eyebrow">My Account</div>
                        <h2>Welcome Back</h2>
                        <p class="subtitle">This is your J-Cart account home.</p>
                    </div>
                </div>
                <div class="dashboard-hero-actions">
                    <a class="btn" href="app-home.jsp">Browse Rugs</a>
                    <a class="btn btn-danger" href="logout" data-confirm="Log out of your account?">Logout</a>
                </div>
            </div>

            <div class="panel welcome-card">
                <div class="welcome-card-icon">&#128717;</div>
                <div>
                    <h3>Your orders &amp; wishlist are on the way</h3>
                    <p>We're weaving this part of your account together. Soon you'll be able to track orders,
                       save favourite rugs to a wishlist, and manage your saved addresses right from here.</p>
                </div>
            </div>
        </div>
    </div>

    <script src="script.js"></script>
</body>
</html>
