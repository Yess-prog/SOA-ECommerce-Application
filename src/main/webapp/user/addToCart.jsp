<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ecommerce.soap.CartServiceInterface" %>
<%@ page import="java.net.URL" %>
<%@ page import="javax.xml.namespace.QName" %>
<%@ page import="javax.xml.ws.Service" %>

<%
// Check if user is logged in
if (session.getAttribute("userId") == null) {
    response.sendRedirect("../index.jsp");
    return;
}

Integer userId = (Integer) session.getAttribute("userId");
int productId = Integer.parseInt(request.getParameter("productId"));
String productName = request.getParameter("productName");
int quantity = 1; // Default quantity

try {
    URL url = new URL("http://localhost:8080/EcommerceSOAP/services/CartService?wsdl");
    QName qname = new QName("http://soap.ecommerce.com/", "CartService");
    Service service = Service.create(url, qname);
    CartServiceInterface cartService = service.getPort(CartServiceInterface.class);
    
    String result = cartService.addToCart(userId, productId, quantity);
    
    if (result.startsWith("SUCCESS")) {
        session.setAttribute("message", productName + " added to cart!");
        session.setAttribute("messageType", "success");
    } else {
        session.setAttribute("message", result.replace("ERROR: ", ""));
        session.setAttribute("messageType", "error");
    }
    
} catch (Exception e) {
    session.setAttribute("message", "Error: " + e.getMessage());
    session.setAttribute("messageType", "error");
}

response.sendRedirect("home.jsp");
%>