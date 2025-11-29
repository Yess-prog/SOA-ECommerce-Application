<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ecommerce.soap.UserServiceInterface" %>
<%@ page import="com.ecommerce.soap.OrderServiceInterface" %>
<%@ page import="com.ecommerce.model.User" %>
<%@ page import="java.net.URL" %>
<%@ page import="javax.xml.namespace.QName" %>
<%@ page import="javax.xml.ws.Service" %>

<%
if (session.getAttribute("userId") == null) {
    response.sendRedirect("../index.jsp");
    return;
}

Integer userId = (Integer) session.getAttribute("userId");

// Get user details
User user = null;
try {
    URL url = new URL("http://localhost:8080/EcommerceSOAP/services/UserService?wsdl");
    QName qname = new QName("http://soap.ecommerce.com/", "UserService");
    Service service = Service.create(url, qname);
    UserServiceInterface userService = service.getPort(UserServiceInterface.class);
    
    user = userService.getUserById(userId);
} catch (Exception e) {
    e.printStackTrace();
}

// Handle order placement
String message = "";
if (request.getParameter("placeOrder") != null) {
    String shippingAddress = request.getParameter("shippingAddress");
    String paymentMethod = request.getParameter("paymentMethod");
    
    try {
        URL url = new URL("http://localhost:8080/EcommerceSOAP/services/OrderService?wsdl");
        QName qname = new QName("http://soap.ecommerce.com/", "OrderService");
        Service service = Service.create(url, qname);
        OrderServiceInterface orderService = service.getPort(OrderServiceInterface.class);
        
        String result = orderService.placeOrderFromCart(userId, shippingAddress, paymentMethod);
        
        if (result.startsWith("SUCCESS")) {
            response.sendRedirect("orders.jsp?success=true");
            return;
        } else {
            message = result.replace("ERROR: ", "");
        }
    } catch (Exception e) {
        message = "Error: " + e.getMessage();
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout - E-Commerce</title>
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
        
        .container {
            max-width: 600px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .checkout-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        h2 {
            margin-bottom: 20px;
            color: #333;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: 500;
        }
        
        textarea, select {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            font-family: inherit;
        }
        
        textarea {
            min-height: 100px;
            resize: vertical;
        }
        
        .btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s;
        }
        
        .btn:hover {
            transform: translateY(-2px);
        }
        
        .message {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
            background-color: #fee;
            color: #c33;
            border: 1px solid #fcc;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <h1>🛒 E-Commerce - Checkout</h1>
    </nav>
    
    <div class="container">
        <div class="checkout-container">
            <h2>Complete Your Order</h2>
            
            <% if (!message.isEmpty()) { %>
                <div class="message"><%= message %></div>
            <% } %>
            
            <form method="post">
                <div class="form-group">
                    <label for="shippingAddress">Shipping Address *</label>
                    <textarea id="shippingAddress" name="shippingAddress" required><%= user != null && user.getAddress() != null ? user.getAddress() : "" %></textarea>
                </div>
                
                <div class="form-group">
                    <label for="paymentMethod">Payment Method *</label>
                    <select id="paymentMethod" name="paymentMethod" required>
                        <option value="">Select Payment Method</option>
                        <option value="Credit Card">Credit Card</option>
                        <option value="Debit Card">Debit Card</option>
                        <option value="PayPal">PayPal</option>
                        <option value="Cash on Delivery">Cash on Delivery</option>
                    </select>
                </div>
                
                <button type="submit" name="placeOrder" class="btn">Place Order</button>
            </form>
        </div>
    </div>
</body>
</html>