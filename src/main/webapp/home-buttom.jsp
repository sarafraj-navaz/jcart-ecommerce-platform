<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<nav class="navbar">
    <a class="navbar-brand" href="app-home.jsp">
        <span class="mark">JC</span>
        <span>J-Cart</span>
    </a>
    
    <button class="navbar-toggle" aria-label="Toggle navigation">
        <i class="fas fa-bars"></i>
    </button>
    
    <div class="navbar-links">
        <a href="app-home.jsp">Home</a>
        <a href="admin-login.jsp">Admin</a>
        <a href="user-login.jsp">User</a>
        <a href="owner-login.jsp">Owner</a>
        <a href="#" class="theme-toggle" onclick="toggleTheme()" data-tooltip="Toggle dark mode">
            <i class="fas fa-moon"></i>
        </a>
    </div>
</nav>

<script>
    // Toggle theme function (also in script.js)
    function toggleTheme() {
        document.body.classList.toggle('dark-mode');
        const isDark = document.body.classList.contains('dark-mode');
        localStorage.setItem('jcart-theme', isDark ? 'dark' : 'light');
        
        const icon = document.querySelector('.theme-toggle i');
        if (icon) {
            icon.className = isDark ? 'fas fa-sun' : 'fas fa-moon';
        }
    }
    
    // Load saved theme
    document.addEventListener('DOMContentLoaded', function() {
        const saved = localStorage.getItem('jcart-theme');
        if (saved === 'dark') {
            document.body.classList.add('dark-mode');
            const icon = document.querySelector('.theme-toggle i');
            if (icon) icon.className = 'fas fa-sun';
        }
    });
</script>