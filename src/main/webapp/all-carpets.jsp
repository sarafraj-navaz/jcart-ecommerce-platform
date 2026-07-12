<%@page import="java.util.List"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="com.jsp.jcart.ecommerce.dto.Product"%>
<%@page import="com.jsp.jcart.ecommerce.dao.ProductDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <title>All Carpets & Rugs · J-Cart</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

    <jsp:include page="home-buttom.jsp" />

    <%
    ProductDao productDao = new ProductDao();
    List<Product> products = productDao.getAllProductData();
    %>

    <div class="shop-wrap">
        <!-- Page Header -->
        <div class="shop-hero" style="padding-bottom:0;">
            <div class="auth-eyebrow"><i class="fas fa-arrow-left" style="font-size:0.5rem;margin-right:6px;"></i>
                <a href="app-home.jsp" style="color:inherit;text-decoration:none;">Back to Home</a>
            </div>
            <h1>All <span style="color:var(--gold);">Carpets &amp; Rugs</span></h1>
            <p>Our complete collection — every hand-finished piece currently listed on J-Cart.</p>
        </div>

        <!-- Product Section -->
        <div class="section-header">
            <div class="section-title">
                <span class="eyebrow-dot"></span>
                Full Collection (<%= (products == null) ? 0 : products.size() %> items)
            </div>
        </div>

        <% if (products == null || products.isEmpty()) { %>
            <div class="empty-state">
                <span class="empty-icon"><i class="fas fa-rug"></i></span>
                <p style="font-size:1.1rem;font-weight:500;">New pieces are being added to the collection.</p>
                <p style="font-size:0.9rem;opacity:0.7;">Check back shortly for our latest arrivals.</p>
            </div>
        <% } else { %>
            <div class="product-grid" id="allCarpetsGrid">
                <%
                int cardIndex = 0;
                for (Product product : products) {
                    cardIndex++;
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

                    String productType = product.getProductWearType() != null ? product.getProductWearType() : "Handwoven";
                    int reviews = (product.getProductId() % 20) + 12;
                    long price = (long) product.getProductPrice();

                    String waMessage = "Hi J-Cart! I'm interested in the \"" + product.getProductName()
                            + "\" (" + productType + ") priced at Rs. " + price + ". Please share more details.";
                    String waLink = "https://wa.me/917617809982?text=" + URLEncoder.encode(waMessage, "UTF-8");
                %>
                <div class="product-card"
                     style="--i: <%= cardIndex %>;"
                     data-name="<%= product.getProductName() %>"
                     data-type="<%= productType %>"
                     data-price="<%= price %>"
                     data-img="<%= imgSrc %>"
                     data-reviews="<%= reviews %>"
                     data-badge="<%= badgeText %>"
                     data-wa="<%= waLink %>">
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
                        <span class="product-view-hint"><i class="fas fa-expand"></i> View Details</span>
                    </div>
                    <div class="product-overlay">
                        <div class="product-type"><%= productType %></div>
                        <div class="product-name"><%= product.getProductName() %></div>
                        <div class="product-rating">
                            <span class="stars">★★★★★</span>
                            <span>(<%= reviews %> reviews)</span>
                        </div>
                        <div class="product-footer">
                            <div class="product-price">&#8377;<%= price %><span class="price-unit">/piece</span></div>
                            <a class="btn btn-primary btn-sm whatsapp-add" href="<%= waLink %>" target="_blank" rel="noopener" onclick="event.stopPropagation();">
                                <i class="fab fa-whatsapp"></i> Add
                            </a>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        <% } %>
    </div>

    <!-- Product Detail Modal -->
    <div class="product-modal-backdrop" id="productModalBackdrop" onclick="closeProductModal(event)">
        <div class="product-modal" onclick="event.stopPropagation();">
            <button class="modal-close" onclick="closeProductModal(event)" aria-label="Close"><i class="fas fa-times"></i></button>
            <div class="modal-media">
                <img id="modalImg" src="" alt="">
                <span class="product-badge" id="modalBadge"></span>
            </div>
            <div class="modal-body">
                <div class="product-type" id="modalType"></div>
                <h2 id="modalName"></h2>
                <div class="product-rating">
                    <span class="stars">★★★★★</span>
                    <span id="modalReviews"></span>
                </div>
                <div class="modal-price" id="modalPrice"></div>
                <p class="modal-desc">Hand-finished with premium materials and timeless pattern work — sourced from verified artisan makers on J-Cart. Sign in to add this piece to your cart, or reach out directly below.</p>

                <div class="modal-actions">
                    <a id="modalWaBtn" class="btn btn-primary" href="#" target="_blank" rel="noopener">
                        <i class="fab fa-whatsapp"></i> Order via WhatsApp
                    </a>
                    <a href="user-login.jsp" class="btn btn-outline">
                        <i class="fas fa-shopping-cart"></i> Sign In to Buy
                    </a>
                </div>

                <div class="modal-contact">
                    <div class="auth-eyebrow" style="margin-bottom:12px;"><i class="fas fa-headset" style="margin-right:6px;"></i> Need Help? Contact Us</div>
                    <a class="contact-line" href="tel:+917617809982"><i class="fas fa-phone"></i> +91 76178 09982</a>
                    <a class="contact-line" href="mailto:sarafrajnavaz.hmfa@gmail.com"><i class="fas fa-envelope"></i> sarafrajnavaz.hmfa@gmail.com</a>
                </div>
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
            <a href="app-home.jsp#about">About Us</a>
            <a href="app-home.jsp#contact">Contact</a>
            <a href="#">Privacy Policy</a>
            <a href="#">Terms of Service</a>
            <a href="#">Shipping &amp; Returns</a>
        </div>
        <p>&copy; <%= java.time.Year.now() %> J-Cart. All rights reserved. Crafted with <i class="fas fa-heart" style="color:var(--gold);font-size:0.7rem;"></i> in India</p>
    </footer>

    <script src="script.js"></script>
    <script>
        function openProductModal(card) {
            document.getElementById('modalImg').src = card.dataset.img;
            document.getElementById('modalImg').alt = card.dataset.name;
            document.getElementById('modalType').textContent = card.dataset.type;
            document.getElementById('modalName').textContent = card.dataset.name;
            document.getElementById('modalReviews').textContent = '(' + card.dataset.reviews + ' reviews)';
            document.getElementById('modalPrice').innerHTML = '&#8377;' + card.dataset.price + '<span class="price-unit">/piece</span>';
            document.getElementById('modalWaBtn').href = card.dataset.wa;

            const badgeEl = document.getElementById('modalBadge');
            if (card.dataset.badge) {
                badgeEl.textContent = card.dataset.badge;
                badgeEl.style.display = 'inline-block';
                badgeEl.className = 'product-badge ' + (card.dataset.badge === 'New Arrival' ? 'new' : 'limited');
            } else {
                badgeEl.style.display = 'none';
            }

            document.getElementById('productModalBackdrop').classList.add('active');
            document.body.style.overflow = 'hidden';
        }

        function closeProductModal(e) {
            document.getElementById('productModalBackdrop').classList.remove('active');
            document.body.style.overflow = '';
        }

        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.product-card').forEach(function(card) {
                card.addEventListener('click', function() {
                    openProductModal(card);
                });
            });
        });

        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') closeProductModal(e);
        });

        // Search filter for the full collection
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
