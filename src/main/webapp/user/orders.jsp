<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ecommerce.soap.OrderServiceInterface" %>
<%@ page import="com.ecommerce.model.*" %>
<%@ page import="java.net.URL" %>
<%@ page import="javax.xml.namespace.QName" %>
<%@ page import="javax.xml.ws.Service" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
if (session.getAttribute("userId") == null) {
    response.sendRedirect("../index.jsp");
    return;
}

Integer userId = (Integer) session.getAttribute("userId");
List<Order> orders = null;

try {
    URL url = new URL("http://localhost:8080/EcommerceSOAP/services/OrderService?wsdl");
    QName qname = new QName("http://soap.ecommerce.com/", "OrderService");
    Service service = Service.create(url, qname);
    OrderServiceInterface orderService = service.getPort(OrderServiceInterface.class);
    
    orders = orderService.getOrdersByUserId(userId);
    
} catch (Exception e) {
    out.println("Error: " + e.getMessage());
}

SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");

String successMessage = request.getParameter("success");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Orders - E-Commerce</title>
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
        
        .orders-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        h2 {
            margin-bottom: 20px;
            color: #333;
        }
        
        .order-card {
            border: 2px solid #eee;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .order-id {
            font-size: 18px;
            font-weight: 600;
            color: #333;
        }
        
        .order-date {
            color: #666;
            font-size: 14px;
        }
        
        .order-details {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .detail-item {
            display: flex;
            flex-direction: column;
        }
        
        .detail-label {
            font-size: 12px;
            color: #666;
            margin-bottom: 5px;
        }
        
        .detail-value {
            font-size: 16px;
            font-weight: 600;
            color: #333;
        }
        
        .status-badge {
            padding: 5px 15px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }
        
        .status-PENDING {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-PROCESSING {
            background: #cce5ff;
            color: #004085;
        }
        
        .status-SHIPPED {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .status-DELIVERED {
            background: #d4edda;
            color: #155724;
        }
        
        .status-CANCELLED {
            background: #f8d7da;
            color: #721c24;
        }
        
        .empty-orders {
            text-align: center;
            padding: 50px;
            color: #666;
        }
        
        .empty-orders a {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 30px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        
        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border: 1px solid #c3e6cb;
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
        <div class="orders-container">
            <h2>My Orders</h2>
            
            <% if ("true".equals(successMessage)) { %>
                <div class="success-message">
                    ✅ Order placed successfully! Thank you for your purchase.
                </div>
            <% } %>
            
            <% if (orders != null && !orders.isEmpty()) {
                for (Order order : orders) { %>
                    <div class="order-card">
                        <div class="order-header">
                            <div>
                                <div class="order-id">Order #<%= order.getOrderId() %></div>
                                <div class="order-date"><%= sdf.format(order.getOrderDate()) %></div>
                            </div>
                            <span class="status-badge status-<%= order.getStatus() %>">
                                <%= order.getStatus() %>
                            </span>
                        </div>
                        
                        <div class="order-details">
                            <div class="detail-item">
                                <span class="detail-label">Total Amount</span>
                                <span class="detail-value">$<%= String.format("%.2f", order.getTotalAmount()) %></span>
                            </div>
                            
                            <div class="detail-item">
                                <span class="detail-label">Payment Method</span>
                                <span class="detail-value"><%= order.getPaymentMethod() %></span>
                            </div>
                            
                            <div class="detail-item">
                                <span class="detail-label">Shipping Address</span>
                                <span class="detail-value"><%= order.getShippingAddress() != null ? order.getShippingAddress().substring(0, Math.min(order.getShippingAddress().length(), 30)) + "..." : "N/A" %></span>
                            </div>
                        </div>
                    </div>
            <%  }
            } else { %>
                <div class="empty-orders">
                    <h3>You haven't placed any orders yet</h3>
                    <a href="home.jsp">Start Shopping</a>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>