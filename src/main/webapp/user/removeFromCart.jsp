<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ecommerce.soap.CartServiceInterface" %>
<%@ page import="java.net.URL" %>
<%@ page import="javax.xml.namespace.QName" %>
<%@ page import="javax.xml.ws.Service" %>

<%
if (session.getAttribute("userId") == null) {
    response.sendRedirect("../index.jsp");
    return;
}

int cartId = Integer.parseInt(request.getParameter("cartId"));

try {
    URL url = new URL("http://localhost:8080/EcommerceSOAP/services/CartService?wsdl");
    QName qname = new QName("http://soap.ecommerce.com/", "CartService");
    Service service = Service.create(url, qname);
    CartServiceInterface cartService = service.getPort(CartServiceInterface.class);
    
    cartService.removeFromCart(cartId);
    
} catch (Exception e) {
    e.printStackTrace();
}

response.sendRedirect("cart.jsp");
%>