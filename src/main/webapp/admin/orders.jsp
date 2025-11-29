<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ecommerce.soap.OrderServiceInterface" %>
<%@ page import="com.ecommerce.model.*" %>
<%@ page import="java.net.URL" %>
<%@ page import="javax.xml.namespace.QName" %>
<%@ page import="javax.xml.ws.Service" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
if (session.getAttribute("userId") == null || !"ADMIN".equals(session.getAttribute("role"))) {
    response.sendRedirect("../index.jsp");
    return;
}

// Handle Update Order Status
String message = "";
if (request.getParameter("updateStatus") != null) {
    try {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String status = request.getParameter("status");
        
        URL url = new URL("http://localhost:8080/EcommerceSOAP/services/OrderService?wsdl");
        QName qname = new QName("http://soap.ecommerce.com/", "OrderService");
        Service service = Service.create(url, qname);
        OrderServiceInterface orderService = service.getPort(OrderServiceInterface.class);
        
        String result = orderService.updateOrderStatus(orderId, status);
        message = result;
    } catch (Exception e) {
        message = "ERROR: " + e.getMessage();
    }
}

// Get all orders
List<Order> orders = null;

try {
    URL url = new URL("http://localhost:8080/EcommerceSOAP/services/OrderService?wsdl");
    QName qname = new QName("http://soap.ecommerce.com/", "OrderService");
    Service service = Service.create(url, qname);
    OrderServiceInterface orderService = service.getPort(OrderServiceInterface.class);
    
    orders = orderService.getAllOrders();
    
} catch (Exception e) {
    out.println("Error: " + e.getMessage());
}

SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Orders - Admin</title>
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
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        h2 {
            margin-bottom: 20px;
            color: #333;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        th {
            background: #f9f9f9;
            font-weight: 600;
            color: #333;
        }
        
        .status-badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
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
        
        select {
            padding: 5px 10px;
            border: 2px solid #ddd;
            border-radius: 5px;
        }
        
        .btn {
            padding: 5px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
            background: #667eea;
            color: white;
        }
        
        .btn:hover {
            background: #764ba2;
        }
        
        .message {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
            text-align: center;
        }
        
        .success {
            background-color: #efe;
            color: #3c3;
            border: 1px solid #cfc;
        }
        
        .error {
            background-color: #fee;
            color: #c33;
            border: 1px solid #fcc;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <h1>👨‍💼 Admin - Orders</h1>
        <div class="navbar-menu">
            <a href="dashboard.jsp">Dashboard</a>
            <a href="products.jsp">Products</a>
            <a href="categories.jsp">Categories</a>
            <a href="orders.jsp">Orders</a>
            <a href="../logout.jsp">Logout</a>
        </div>
    </nav>
    
    <div class="container">
        <% if (!message.isEmpty()) { %>
            <div class="message <%= message.startsWith("SUCCESS") ? "success" : "error" %>">
                <%= message.replace("SUCCESS: ", "").replace("ERROR: ", "") %>
            </div>
        <% } %>
        
        <div class="section">
            <h2>All Orders</h2>
            <table>
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>User ID</th>
                        <th>Date</th>
                        <th>Total Amount</th>
                        <th>Status</th>
                        <th>Payment Method</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (orders != null && !orders.isEmpty()) {
                        for (Order order : orders) { %>
                            <tr>
                                <td>#<%= order.getOrderId() %></td>
                                <td><%= order.getUserId() %></td>
                                <td><%= sdf.format(order.getOrderDate()) %></td>
                                <td>$<%= String.format("%.2f", order.getTotalAmount()) %></td>
                                <td>
                                    <span class="status-badge status-<%= order.getStatus() %>">
                                        <%= order.getStatus() %>
                                    </span>
                                </td>
                                <td><%= order.getPaymentMethod() %></td>
                                <td>
                                    <form method="post" style="display:inline;">
                                        <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                                        <select name="status">
                                            <option value="PENDING" <%= order.getStatus().toString().equals("PENDING") ? "selected" : "" %>>Pending</option>
                                            <option value="PROCESSING" <%= order.getStatus().toString().equals("PROCESSING") ? "selected" : "" %>>Processing</option>
                                            <option value="SHIPPED" <%= order.getStatus().toString().equals("SHIPPED") ? "selected" : "" %>>Shipped</option>
                                            <option value="DELIVERED" <%= order.getStatus().toString().equals("DELIVERED") ? "selected" : "" %>>Delivered</option>
                                            <option value="CANCELLED" <%= order.getStatus().toString().equals("CANCELLED") ? "selected" : "" %>>Cancelled</option>
                                        </select>
                                        <button type="submit" name="updateStatus" class="btn">Update</button>
                                    </form>
                                </td>
                            </tr>
                    <%  }
                    } else { %>
                        <tr><td colspan="7">No orders found</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>