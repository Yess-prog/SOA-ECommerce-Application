<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ecommerce.soap.ProductServiceInterface" %>
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

// Handle Add Product
String message = "";
if (request.getParameter("addProduct") != null) {
    try {
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String productName = request.getParameter("productName");
        String description = request.getParameter("description");
        double price = Double.parseDouble(request.getParameter("price"));
        int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
        String imageUrl = request.getParameter("imageUrl");
        
        URL url = new URL("http://localhost:8080/EcommerceSOAP/services/ProductService?wsdl");
        QName qname = new QName("http://soap.ecommerce.com/", "ProductService");
        Service service = Service.create(url, qname);
        ProductServiceInterface productService = service.getPort(ProductServiceInterface.class);
        
        String result = productService.addProduct(categoryId, productName, description, price, stockQuantity, imageUrl);
        message = result;
    } catch (Exception e) {
        message = "ERROR: " + e.getMessage();
    }
}

// Handle Delete Product
if (request.getParameter("deleteProduct") != null) {
    try {
        int productId = Integer.parseInt(request.getParameter("productId"));
        
        URL url = new URL("http://localhost:8080/EcommerceSOAP/services/ProductService?wsdl");
        QName qname = new QName("http://soap.ecommerce.com/", "ProductService");
        Service service = Service.create(url, qname);
        ProductServiceInterface productService = service.getPort(ProductServiceInterface.class);
        
        String result = productService.deleteProduct(productId);
        message = result;
    } catch (Exception e) {
        message = "ERROR: " + e.getMessage();
    }
}

// Get all products and categories
List<Product> products = null;
List<Category> categories = null;

try {
    URL productUrl = new URL("http://localhost:8080/EcommerceSOAP/services/ProductService?wsdl");
    QName productQname = new QName("http://soap.ecommerce.com/", "ProductService");
    Service productService = Service.create(productUrl, productQname);
    ProductServiceInterface productSoap = productService.getPort(ProductServiceInterface.class);
    
    URL categoryUrl = new URL("http://localhost:8080/EcommerceSOAP/services/CategoryService?wsdl");
    QName categoryQname = new QName("http://soap.ecommerce.com/", "CategoryService");
    Service categoryService = Service.create(categoryUrl, categoryQname);
    CategoryServiceInterface categorySoap = categoryService.getPort(CategoryServiceInterface.class);
    
    products = productSoap.getAllProductsForAdmin();
    categories = categorySoap.getAllCategories();
    
} catch (Exception e) {
    out.println("Error: " + e.getMessage());
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Products - Admin</title>
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
            margin-bottom: 30px;
        }
        
        h2 {
            margin-bottom: 20px;
            color: #333;
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group.full-width {
            grid-column: 1 / -1;
        }
        
        label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: 500;
        }
        
        input, select, textarea {
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
        <h1>👨‍💼 Admin - Products</h1>
        <div class="navbar-menu">
            <a href="dashboard.jsp">Dashboard</a>
            <a href="products.jsp">Products</a>
            <a href="categories.jsp">Categories</a>
            <a href="orders.jsp">Orders</a>
            <a href="users.jsp">Users</a>
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
            <h2>Add New Product</h2>
            <form method="post">
                <div class="form-grid">
                    <div class="form-group">
                        <label>Product Name *</label>
                        <input type="text" name="productName" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Category *</label>
                        <select name="categoryId" required>
                            <option value="">Select Category</option>
                            <% if (categories != null) {
                                for (Category category : categories) { %>
                                    <option value="<%= category.getCategoryId() %>">
                                        <%= category.getCategoryName() %>
                                    </option>
                            <%  }
                            } %>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label>Price *</label>
                        <input type="number" step="0.01" name="price" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Stock Quantity *</label>
                        <input type="number" name="stockQuantity" required>
                    </div>
                    
                    <div class="form-group full-width">
                        <label>Description</label>
                        <textarea name="description"></textarea>
                    </div>
                    
                    <div class="form-group full-width">
                        <label>Image URL</label>
                        <input type="text" name="imageUrl">
                    </div>
                </div>
                
                <button type="submit" name="addProduct" class="btn btn-primary">Add Product</button>
            </form>
        </div>
        
        <div class="section">
            <h2>All Products</h2>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Price</th>
                        <th>Stock</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (products != null && !products.isEmpty()) {
                        for (Product product : products) { %>
                            <tr>
                                <td><%= product.getProductId() %></td>
                                <td><%= product.getProductName() %></td>
                                <td>$<%= String.format("%.2f", product.getPrice()) %></td>
                                <td><%= product.getStockQuantity() %></td>
                                <td><%= product.getStatus() %></td>
                                <td>
                                    <form method="post" style="display:inline;">
                                        <input type="hidden" name="productId" value="<%= product.getProductId() %>">
                                        <button type="submit" name="deleteProduct" class="btn btn-danger" 
                                                onclick="return confirm('Are you sure?')">Delete</button>
                                    </form>
                                </td>
                            </tr>
                    <%  }
                    } else { %>
                        <tr><td colspan="6">No products found</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>