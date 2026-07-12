<%@page import="java.util.List"%>
<%@page import="com.jsp.jcart.ecommerce.dto.Product"%>
<%@page import="com.jsp.jcart.ecommerce.dao.ProductDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>J-Cart · Luxury Carpets & Rugs</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

    <jsp:include page="home-buttom.jsp" />

    <%
    ProductDao productDao = new ProductDao();
    List<Product> products = productDao.getAllProductData();
    String[] rugAlt = {
        "Hand-knotted Persian medallion rug",
        "Modern geometric wool rug",
        "Heritage floral border carpet",
        "Contemporary abstract weave",
        "Classic vintage-inspired rug"
    };
    %>

    <div class="shop-wrap">
        <!-- Hero Section -->
        <div class="shop-hero">
            <div class="auth-eyebrow"><i class="fas fa-arrow-right" style="font-size:0.5rem;margin-right:6px;"></i> J-Cart Home &amp; Living</div>
            <h1>Carpets Woven for <span style="color:var(--gold);">Modern Luxury</span></h1>
            <p>Hand-finished rugs and carpets, crafted with premium materials and timeless pattern work — sourced from verified makers on J-Cart.</p>

            <div class="hero-stats">
                <div class="stat-item">
                    <div class="stat-number">250+</div>
                    <div class="stat-label">Handcrafted Rugs</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">12</div>
                    <div class="stat-label">Artisan Partners</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">4.9★</div>
                    <div class="stat-label">Average Rating</div>
                </div>
            </div>
        </div>

        <!-- Product Section -->
        <div class="section-header">
            <div class="section-title">
                <span class="eyebrow-dot"></span>
                Featured Collection
            </div>
            <a href="#" class="role-link" style="width:auto;padding:6px 16px;font-size:12px;">
                View All <i class="fas fa-arrow-right"></i>
            </a>
        </div>

        <% if (products == null || products.isEmpty()) { %>
            <div class="empty-state">
                <span class="empty-icon"><i class="fas fa-rug"></i></span>
                <p style="font-size:1.1rem;font-weight:500;">New pieces are being added to the collection.</p>
                <p style="font-size:0.9rem;opacity:0.7;">Check back shortly for our latest arrivals.</p>
            </div>
        <% } else { %>
            <div class="product-grid">
                <% 
                int count = 0;
                for (Product product : products) {
                    if (count >= 8) break;
                    count++;
                    boolean hasStaticPhoto = product.getImagePath() != null && !product.getImagePath().trim().isEmpty();
                    String imgSrc = hasStaticPhoto ? product.getImagePath() : ("photo?id=" + product.getProductId());
                    
                    String badgeClass = "";
                    String badgeText = "";
                    if (product.getProductId() % 3 == 0) {
                        badgeClass = "new";
                        badgeText = "New Arrival";
                    } else if (product.getProductId() % 5 == 0) {
                        badgeClass = "limited";
                        badgeText = "Limited";
                    }
                %>
                <div class="product-card">
                    <div class="product-media">
                        <img src="<%= imgSrc %>"
                             alt="<%= product.getProductName() %>"
                             loading="lazy"
                             onerror="this.style.display='none'; this.parentElement.querySelector('.fallback-swatch').style.display='flex';">
                        <div class="fallback-swatch" style="display:none;width:100%;height:100%;background:linear-gradient(135deg, #2d4a6b, #1a2d44);align-items:center;justify-content:center;font-size:3rem;color:var(--gold);">
                            <i class="fas fa-rug"></i>
                        </div>
                        <% if (!badgeText.isEmpty()) { %>
                            <span class="product-badge <%= badgeClass %>"><%= badgeText %></span>
                        <% } %>
                    </div>
                    <div class="product-body">
                        <div class="product-type"><%= product.getProductWearType() != null ? product.getProductWearType() : "Handwoven" %></div>
                        <div class="product-name"><%= product.getProductName() %></div>
                        <div class="product-rating">
                            <span class="stars">★★★★★</span>
                            <span>(<%= (product.getProductId() % 20) + 12 %> reviews)</span>
                        </div>
                        <div class="product-footer">
                            <div class="product-price">&#8377;<%= (long) product.getProductPrice() %><span class="price-unit">/piece</span></div>
                            <a class="btn btn-primary btn-sm" href="user-login.jsp">
                                <i class="fas fa-shopping-cart"></i> Add
                            </a>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>

            <div style="text-align:center;margin-top:36px;">
                <a href="#" class="btn btn-outline" style="padding:0.7rem 2rem;">
                    Browse All Carpets <i class="fas fa-arrow-right" style="margin-left:8px;"></i>
                </a>
            </div>
        <% } %>
    </div>

    <!-- Portal Section -->
    <div class="portal-section" style="max-width:1100px;margin:60px auto 0;text-align:center;padding:0 20px 20px;">
        <div class="auth-eyebrow"><i class="fas fa-lock" style="margin-right:6px;"></i> Secure Access Portal</div>
        <h2 style="font-family:var(--font-display);font-size:clamp(1.6rem,3vw,2.4rem);font-weight:700;color:var(--text-main);margin-bottom:8px;">Manage Your J-Cart Account</h2>
        <p style="color:var(--text-muted);font-size:1rem;max-width:500px;margin:0 auto 40px;">Sign in as an Admin, Buyer, or Product Owner to continue.</p>

        <div class="role-grid">
            <div class="role-card">
                <div class="role-icon"><i class="fas fa-shield-alt"></i></div>
                <p class="role-name">Admin</p>
                <p class="role-desc">Manage users, verify product owners, and configure system-wide settings.</p>
                <a class="role-link" href="admin-login.jsp">Sign in as Admin <i class="fas fa-arrow-right"></i></a>
            </div>
            <div class="role-card">
                <div class="role-icon"><i class="fas fa-user-circle"></i></div>
                <p class="role-name">Buyer</p>
                <p class="role-desc">Browse the collection, manage your account, and shop with ease.</p>
                <a class="role-link" href="user-login.jsp">Sign in as Buyer <i class="fas fa-arrow-right"></i></a>
            </div>
            <div class="role-card">
                <div class="role-icon"><i class="fas fa-store"></i></div>
                <p class="role-name">Product Owner</p>
                <p class="role-desc">List carpets, track verification status, and manage your storefront.</p>
                <a class="role-link" href="owner-login.jsp">Sign in as Owner <i class="fas fa-arrow-right"></i></a>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="page-footer">
        <div class="social-icons">
            <a href="#" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
            <a href="#" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
            <a href="#" aria-label="Twitter"><i class="fab fa-x-twitter"></i></a>
            <a href="#" aria-label="YouTube"><i class="fab fa-youtube"></i></a>
            <a href="#" aria-label="Pinterest"><i class="fab fa-pinterest-p"></i></a>
        </div>
        <div class="footer-links">
            <a href="#">About Us</a>
            <a href="#">Contact</a>
            <a href="#">Privacy Policy</a>
            <a href="#">Terms of Service</a>
            <a href="#">Shipping &amp; Returns</a>
        </div>
        <p>&copy; <%= java.time.Year.now() %> J-Cart. All rights reserved. Crafted with <i class="fas fa-heart" style="color:var(--gold);font-size:0.7rem;"></i> in India</p>
    </footer>

    <script src="script.js"></script>
    <script>
        // Initialize search filter on product cards
        document.addEventListener('DOMContentLoaded', function() {
            const searchInput = document.createElement('input');
            searchInput.type = 'text';
            searchInput.placeholder = 'Search products...';
            searchInput.className = 'search-input';
            searchInput.style.cssText = `
                width: 100%;
                max-width: 300px;
                padding: 8px 16px;
                border-radius: 8px;
                border: 1px solid var(--navy-line);
                background: rgba(10, 22, 40, 0.6);
                color: var(--text-main);
                font-size: 14px;
                margin-bottom: 20px;
            `;
            
            const header = document.querySelector('.section-header');
            if (header) {
                header.style.flexWrap = 'wrap';
                header.appendChild(searchInput);
            }
            
            searchInput.addEventListener('input', function() {
                const query = this.value.toLowerCase().trim();
                document.querySelectorAll('.product-card').forEach(function(card) {
                    const name = card.querySelector('.product-name')?.textContent?.toLowerCase() || '';
                    const type = card.querySelector('.product-type')?.textContent?.toLowerCase() || '';
                    if (query === '' || name.includes(query) || type.includes(query)) {
                        card.style.display = '';
                    } else {
                        card.style.display = 'none';
                    }
                });
            });
        });
    </script>
</body>
</html>