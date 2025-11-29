<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ecommerce.soap.CategoryServiceInterface" %>
<%@ page import="com.ecommerce.model.*" %>
<%@ page import="java.net.URL" %>
<%@ page import="javax.xml.namespace.QName" %>
<%@ page import="javax.xml.ws.Service" %>
<%@ page import="java.util.List" %>

<%
if (session.getAttribute("userId") == null || !"ADMIN".equals(session.getAttribute("role"))) {
    response.sendRedirect("../index.jsp");
    return;
}

// Handle Add Category
String message = "";
if (request.getParameter("addCategory") != null) {
    try {
        String categoryName = request.getParameter("categoryName");
        String description = request.getParameter("description");
        
        URL url = new URL("http://localhost:8080/EcommerceSOAP/services/CategoryService?wsdl");
        QName qname = new QName("http://soap.ecommerce.com/", "CategoryService");
        Service service = Service.create(url, qname);
        CategoryServiceInterface categoryService = service.getPort(CategoryServiceInterface.class);
        
        String result = categoryService.addCategory(categoryName, description);
        message = result;
    } catch (Exception e) {
        message = "ERROR: " + e.getMessage();
    }
}

// Handle Delete Category
if (request.getParameter("deleteCategory") != null) {
    try {
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        
        URL url = new URL("http://localhost:8080/EcommerceSOAP/services/CategoryService?wsdl");
        QName qname = new QName("http://soap.ecommerce.com/", "CategoryService");
        Service service = Service.create(url, qname);
        CategoryServiceInterface categoryService = service.getPort(CategoryServiceInterface.class);
        
        String result = categoryService.deleteCategory(categoryId);
        message = result;
    } catch (Exception e) {
        message = "ERROR: " + e.getMessage();
    }
}

// Get all categories
List<Category> categories = null;

try {
    URL url = new URL("http://localhost:8080/EcommerceSOAP/services/CategoryService?wsdl");
    QName qname = new QName("http://soap.ecommerce.com/", "CategoryService");
    Service service = Service.create(url, qname);
    CategoryServiceInterface categoryService = service.getPort(CategoryServiceInterface.class);
    
    categories = categoryService.getAllCategories();
    
} catch (Exception e) {
    out.println("Error: " + e.getMessage());
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Categories - Admin</title>
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
        
        .section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        h2 {
            margin-bottom: 20px;
            color: #333;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: 500;
        }
        
        input, textarea {
            width: 100%;
            padding: 10px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        
        textarea {
            resize: vertical;
            min-height: 80px;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background: #667eea;
            color: white;
        }
        
        .btn-danger {
            background: #ff4757;
            color: white;
        }
        
        .btn:hover {
            transform: translateY(-2px);
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
        <h1>👨‍💼 Admin - Categories</h1>
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
            <h2>Add New Category</h2>
            <form method="post">
                <div class="form-group">
                    <label>Category Name *</label>
                    <input type="text" name="categoryName" required>
                </div>
                
                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description"></textarea>
                </div>
                
                <button type="submit" name="addCategory" class="btn btn-primary">Add Category</button>
            </form>
        </div>
        
        <div class="section">
            <h2>All Categories</h2>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (categories != null && !categories.isEmpty()) {
                        for (Category category : categories) { %>
                            <tr>
                                <td><%= category.getCategoryId() %></td>
                                <td><%= category.getCategoryName() %></td>
                                <td><%= category.getDescription() != null ? category.getDescription() : "N/A" %></td>
                                <td>
                                    <form method="post" style="display:inline;">
                                        <input type="hidden" name="categoryId" value="<%= category.getCategoryId() %>">
                                        <button type="submit" name="deleteCategory" class="btn btn-danger" 
                                                onclick="return confirm('Are you sure? This may affect products.')">Delete</button>
                                    </form>
                                </td>
                            </tr>
                    <%  }
                    } else { %>
                        <tr><td colspan="4">No categories found</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>