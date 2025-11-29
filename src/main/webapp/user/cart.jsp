<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ecommerce.soap.CartServiceInterface" %>
<%@ page import="com.ecommerce.soap.ProductServiceInterface" %>
<%@ page import="com.ecommerce.model.*" %>
<%@ page import="java.net.URL" %>
<%@ page import="javax.xml.namespace.QName" %>
<%@ page import="javax.xml.ws.Service" %>
<%@ page import="java.util.List" %>

<%
if (session.getAttribute("userId") == null) {
    response.sendRedirect("../index.jsp");
    return;
}

Integer userId = (Integer) session.getAttribute("userId");
String fullName = (String) session.getAttribute("fullName");

List<Cart> cartItems = null;
double totalAmount = 0;

try {
    URL cartUrl = new URL("http://localhost:8080/EcommerceSOAP/services/CartService?wsdl");
    QName cartQname = new QName("http://soap.ecommerce.com/", "CartService");
    Service cartService = Service.create(cartUrl, cartQname);
    CartServiceInterface cartSoap = cartService.getPort(CartServiceInterface.class);
    
    URL productUrl = new URL("http://localhost:8080/EcommerceSOAP/services/ProductService?wsdl");
    QName productQname = new QName("http://soap.ecommerce.com/", "ProductService");
    Service productService = Service.create(productUrl, productQname);
    ProductServiceInterface productSoap = productService.getPort(ProductServiceInterface.class);
    
    cartItems = cartSoap.getCartItems(userId);
    
    if (cartItems != null) {
        for (Cart item : cartItems) {
            Product product = productSoap.getProductById(item.getProductId());
            if (product != null) {
                totalAmount += product.getPrice() * item.getQuantity();
            }
        }
    }
    
} catch (Exception e) {
    out.println("Error: " + e.getMessage());
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Shopping Cart - E-Commerce</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
        }
        
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 50px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .navbar h1 {
            font-size: 24px;
        }
        
        .navbar-menu {
            display: flex;
            gap: 20px;
        }
        
        .navbar-menu a {
            color: white;
            text-decoration: none;
            padding: 8px 15px;
            border-radius: 5px;
            transition: background 0.3s;
        }
        
        .navbar-menu a:hover {
            background: rgba(255,255,255,0.2);
        }
        
        .container {
            max-width: 1000px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .cart-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        h2 {
            margin-bottom: 20px;
            color: #333;
        }
        
        .cart-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px;
            border-bottom: 1px solid #eee;
        }
        
        .item-info {
            flex: 1;
        }
        
        .item-name {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }
        
        .item-price {
            font-size: 16px;
            color: #667eea;
            font-weight: 600;
        }
        
        .item-quantity {
            font-size: 14px;
            color: #666;
        }
        
        .item-actions {
            display: flex;
            gap: 10px;
        }
        
        .btn {
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-remove {
            background: #ff4757;
            color: white;
        }
        
        .btn-remove:hover {
            background: #ff3838;
        }
        
        .cart-summary {
            margin-top: 30px;
            padding: 20px;
            background: #f9f9f9;
            border-radius: 5px;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            font-size: 18px;
        }
        
        .summary-total {
            font-size: 24px;
            font-weight: bold;
            color: #667eea;
            padding-top: 10px;
            border-top: 2px solid #ddd;
        }
        
        .checkout-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            margin-top: 20px;
            font-size: 18px;
        }
        
        .checkout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .empty-cart {
            text-align: center;
            padding: 50px;
            color: #666;
        }
        
        .empty-cart a {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 30px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <h1>🛒 E-Commerce</h1>
        <div class="navbar-menu">
            <a href="home.jsp">Shop</a>
            <a href="cart.jsp">Cart</a>
            <a href="orders.jsp">My Orders</a>
            <a href="profile.jsp">Profile</a>
            <a href="../logout.jsp">Logout</a>
        </div>
    </nav>
    
    <div class="container">
        <div class="cart-container">
            <h2>Shopping Cart</h2>
            
            <% if (cartItems != null && !cartItems.isEmpty()) { 
                URL productUrl = new URL("http://localhost:8080/EcommerceSOAP/services/ProductService?wsdl");
                QName productQname = new QName("http://soap.ecommerce.com/", "ProductService");
                Service productService = Service.create(productUrl, productQname);
                ProductServiceInterface productSoap = productService.getPort(ProductServiceInterface.class);
                
                for (Cart item : cartItems) {
                    Product product = productSoap.getProductById(item.getProductId());
                    if (product != null) {
                        double itemTotal = product.getPrice() * item.getQuantity();
            %>
                <div class="cart-item">
                    <div class="item-info">
                        <div class="item-name"><%= product.getProductName() %></div>
                        <div class="item-price">$<%= String.format("%.2f", product.getPrice()) %> × <%= item.getQuantity() %> = $<%= String.format("%.2f", itemTotal) %></div>
                    </div>
                    <div class="item-actions">
                        <form action="removeFromCart.jsp" method="post" style="display:inline;">
                            <input type="hidden" name="cartId" value="<%= item.getCartId() %>">
                            <button type="submit" class="btn btn-remove">Remove</button>
                        </form>
                    </div>
                </div>
            <%      }
                } %>
                
                <div class="cart-summary">
                    <div class="summary-row summary-total">
                        <span>Total:</span>
                        <span>$<%= String.format("%.2f", totalAmount) %></span>
                    </div>
                    
                    <a href="checkout.jsp"><button class="btn checkout-btn">Proceed to Checkout</button></a>
                </div>
            <% } else { %>
                <div class="empty-cart">
                    <h3>Your cart is empty</h3>
                    <a href="home.jsp">Continue Shopping</a>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>