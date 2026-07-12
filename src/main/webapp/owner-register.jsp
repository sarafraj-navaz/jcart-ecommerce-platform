<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>J-Cart | Owner Sign Up</title>
<link rel="stylesheet" href="style.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
    <jsp:include page="home-buttom.jsp"></jsp:include>

    <%
    String errorMsg = (String) request.getAttribute("errorMsg");
    String successMsg = (String) request.getAttribute("successMsg");
    %>

    <div class="auth-page">
        <div class="auth-card wide">
            <div class="auth-eyebrow"><i class="fas fa-store" style="margin-right:6px;"></i> Product Owner</div>
            <h2 class="auth-title">Register Your Storefront</h2>
            <p class="auth-subtitle">Create an account to start listing products on J-Cart.</p>

            <% if (errorMsg != null) { %>
            <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> <%= errorMsg %></div>
            <% } %>
            <% if (successMsg != null) { %>
            <div class="alert alert-success"><i class="fas fa-check-circle"></i> <%= successMsg %></div>
            <% } %>

            <form class="auth-form" action="ownerRegister" method="post" id="registerForm">
                <div class="form-group">
                    <label for="ownerName"><i class="fas fa-user" style="margin-right:4px;"></i> Owner Name</label>
                    <input type="text" id="ownerName" name="ownerName" placeholder="Your full name" required>
                </div>
                <div class="form-group">
                    <label for="ownerEmail"><i class="fas fa-envelope" style="margin-right:4px;"></i> Email</label>
                    <input type="email" id="ownerEmail" name="ownerEmail" placeholder="you@example.com" required>
                </div>
                <div class="form-group password-field">
                    <label for="ownerPassword"><i class="fas fa-lock" style="margin-right:4px;"></i> Password</label>
                    <input type="password" id="ownerPassword" name="ownerPassword" placeholder="Create a password (min 8 characters)" required minlength="8">
                    <button type="button" class="password-toggle">SHOW</button>
                </div>
                <div class="form-group">
                    <label for="ownerPhone"><i class="fas fa-phone" style="margin-right:4px;"></i> Phone</label>
                    <input type="tel" id="ownerPhone" name="ownerPhone" placeholder="10-digit mobile number" required pattern="[0-9]{10}">
                </div>
                <div class="form-group">
                    <label for="ownerAddress"><i class="fas fa-map-marker-alt" style="margin-right:4px;"></i> Address (Optional)</label>
                    <input type="text" id="ownerAddress" name="ownerAddress" placeholder="Your business address">
                </div>
                <button type="submit" class="btn btn-primary btn-block" id="registerBtn">
                    <i class="fas fa-user-plus"></i> Create Account
                </button>
            </form>

            <p class="auth-footer">Already registered? <a href="owner-login.jsp">Sign in</a></p>
        </div>
    </div>

    <script src="script.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('registerForm');
            const btn = document.getElementById('registerBtn');
            const password = document.getElementById('ownerPassword');
            const phone = document.getElementById('ownerPhone');
            
            // Password strength indicator
            password.addEventListener('input', function() {
                const val = this.value;
                let strength = 0;
                if (val.length >= 8) strength++;
                if (val.match(/[a-z]+/)) strength++;
                if (val.match(/[A-Z]+/)) strength++;
                if (val.match(/[0-9]+/)) strength++;
                if (val.match(/[$@#&!]+/)) strength++;
                
                const indicator = document.querySelector('.password-strength');
                if (!indicator) {
                    const div = document.createElement('div');
                    div.className = 'password-strength';
                    div.style.cssText = 'margin-top:6px;font-size:11px;color:var(--text-muted);';
                    this.parentElement.appendChild(div);
                }
                
                const el = this.parentElement.querySelector('.password-strength');
                const strengths = ['Very Weak', 'Weak', 'Fair', 'Good', 'Strong', 'Excellent'];
                const colors = ['var(--danger)', 'var(--danger)', 'var(--warning)', 'var(--warning)', 'var(--success)', 'var(--success)'];
                el.textContent = `Password Strength: ${strengths[strength] || 'Very Weak'}`;
                el.style.color = colors[strength] || 'var(--danger)';
            });
            
            // Phone formatting
            phone.addEventListener('input', function() {
                this.value = this.value.replace(/\D/g, '').slice(0, 10);
            });
            
            form.addEventListener('submit', function() {
                btn.innerHTML = '<span class="spinner"></span> Creating account...';
                btn.classList.add('btn-loading');
                btn.disabled = true;
            });
        });
    </script>
</body>
</html>