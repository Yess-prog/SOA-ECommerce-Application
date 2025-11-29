package com.ecommerce.client;

import java.net.URL;
import javax.xml.namespace.QName;
import javax.xml.ws.Service;

/**
 * Utility class to create SOAP service clients
 * Location: com.ecommerce.client package
 */
public class SOAPClientUtil {
    
    private static final String BASE_URL = "http://localhost:8080/EcommerceSOAP/services/";
    
    /**
     * Get UserService client
     */
    public static Object getUserService() throws Exception {
        URL url = new URL(BASE_URL + "UserService?wsdl");
        QName qname = new QName("http://soap.ecommerce.com/", "UserService");
        Service service = Service.create(url, qname);
        return service.getPort(com.ecommerce.soap.UserService.class);
    }
    
    /**
     * Get ProductService client
     */
    public static Object getProductService() throws Exception {
        URL url = new URL(BASE_URL + "ProductService?wsdl");
        QName qname = new QName("http://soap.ecommerce.com/", "ProductService");
        Service service = Service.create(url, qname);
        return service.getPort(com.ecommerce.soap.ProductService.class);
    }
    
    /**
     * Get CategoryService client
     */
    public static Object getCategoryService() throws Exception {
        URL url = new URL(BASE_URL + "CategoryService?wsdl");
        QName qname = new QName("http://soap.ecommerce.com/", "CategoryService");
        Service service = Service.create(url, qname);
        return service.getPort(com.ecommerce.soap.CategoryService.class);
    }
    
    /**
     * Get OrderService client
     */
    public static Object getOrderService() throws Exception {
        URL url = new URL(BASE_URL + "OrderService?wsdl");
        QName qname = new QName("http://soap.ecommerce.com/", "OrderService");
        Service service = Service.create(url, qname);
        return service.getPort(com.ecommerce.soap.OrderService.class);
    }
    
    /**
     * Get CartService client
     */
    public static Object getCartService() throws Exception {
        URL url = new URL(BASE_URL + "CartService?wsdl");
        QName qname = new QName("http://soap.ecommerce.com/", "CartService");
        Service service = Service.create(url, qname);
        return service.getPort(com.ecommerce.soap.CartService.class);
    }
}