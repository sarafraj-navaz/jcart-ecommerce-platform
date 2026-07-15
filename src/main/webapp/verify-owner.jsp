<%@page import="com.jsp.jcart.ecommerce.dto.ProductOwner"%>
<%@page import="java.util.List"%>
<%@page import="com.jsp.jcart.ecommerce.dao.ProductOwnerDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    ProductOwnerDao verifiedDao = new ProductOwnerDao();
    List<ProductOwner> verifiedOwners = verifiedDao.displayAllProductOwnerDao();
    if (verifiedOwners == null) { verifiedOwners = new java.util.ArrayList<ProductOwner>(); }
    int verifiedCount = 0;
    for (ProductOwner o : verifiedOwners) {
        if ("yes".equalsIgnoreCase(o.getVerify())) { verifiedCount++; }
    }
%>
<div class="verify-panel is-verified" id="verifiedPanel">
    <div class="verify-panel-head">
        <div class="section-title">
            <span class="eyebrow-dot" style="background:var(--success);"></span>
            Verified Owners
        </div>
        <span class="verify-count"><i class="fas fa-check-circle"></i> <%= verifiedCount %></span>
    </div>
    
    <!-- Search within panel -->
    <div style="padding:10px 20px;border-bottom:1px solid rgba(31,61,107,0.1);">
        <input type="text" class="panel-search" placeholder="Search verified owners..." 
               style="width:100%;padding:6px 12px;border-radius:6px;border:1px solid var(--navy-line);background:rgba(10,22,40,0.4);color:var(--text-main);font-size:13px;">
    </div>
    
    <div class="owner-list">
        <% if (verifiedCount == 0) { %>
        <div class="owner-empty">
            <span class="empty-icon"><i class="fas fa-shield-alt"></i></span>
            No verified product owners yet.
            <span style="font-size:0.75rem;opacity:0.6;display:block;margin-top:4px;">Pending owners will appear here after verification</span>
        </div>
        <% } else { %>
            <% for (ProductOwner owner : verifiedOwners) { 
                if ("yes".equalsIgnoreCase(owner.getVerify())) {
                    String initials = owner.getName() != null && owner.getName().length() > 0
                        ? owner.getName().trim().substring(0, 1).toUpperCase() : "?";
            %>
            <div class="owner-card" data-name="<%= owner.getName().toLowerCase() %>" data-email="<%= owner.getEmail().toLowerCase() %>">
                <div class="owner-avatar"><%= initials %></div>
                <div class="owner-info">
                    <div class="owner-name"><span class="owner-name-text"><%= owner.getName() %></span> <span class="badge badge-success">verified</span></div>
                    <div class="owner-meta">
                        <a href="mailto:<%= owner.getEmail() %>" title="Email <%= owner.getName() %>"><i class="fas fa-envelope"></i> <%= owner.getEmail() %></a>
                        <span class="owner-meta-sep">&middot;</span>
                        <a href="tel:<%= owner.getPhone() %>" title="Call <%= owner.getName() %>"><i class="fas fa-phone"></i> <%= owner.getPhone() %></a>
                    </div>
                </div>
                <div class="owner-actions">
                    <a class="btn btn-sm btn-danger" href="unverify?ownerid=<%= owner.getId() %>"
                       data-confirm="Revoke verification for <%= owner.getName() %>?">
                       <i class="fas fa-user-minus"></i> Unverify
                    </a>
                </div>
            </div>
            <% } } %>
        <% } %>
    </div>
</div>

<script>
    // Search functionality for this panel
    document.addEventListener('DOMContentLoaded', function() {
        const panel = document.getElementById('verifiedPanel');
        const searchInput = panel.querySelector('.panel-search');
        if (searchInput) {
            searchInput.addEventListener('input', function() {
                const query = this.value.toLowerCase().trim();
                const cards = panel.querySelectorAll('.owner-card');
                cards.forEach(function(card) {
                    const name = card.getAttribute('data-name') || '';
                    const email = card.getAttribute('data-email') || '';
                    if (query === '' || name.includes(query) || email.includes(query)) {
                        card.style.display = '';
                    } else {
                        card.style.display = 'none';
                    }
                });
            });
        }
    });
</script>