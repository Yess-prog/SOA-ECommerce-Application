package com.ecommerce.soap;

import com.ecommerce.model.Order;
import com.ecommerce.model.OrderItem;
import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebService;
import java.util.List;

/**
 * Web Service Interface for Order operations
 */
@WebService(name = "OrderService", targetNamespace = "http://soap.ecommerce.com/")
public interface OrderServiceInterface {
    
    @WebMethod
    String placeOrderFromCart(
            @WebParam(name = "userId") int userId,
            @WebParam(name = "shippingAddress") String shippingAddress,
            @WebParam(name = "paymentMethod") String paymentMethod);
    
    @WebMethod
    List<Order> getAllOrders();
    
    @WebMethod
    List<Order> getOrdersByUserId(@WebParam(name = "userId") int userId);
    
    @WebMethod
    Order getOrderById(@WebParam(name = "orderId") int orderId);
    
    @WebMethod
    List<OrderItem> getOrderItems(@WebParam(name = "orderId") int orderId);
    
    @WebMethod
    String updateOrderStatus(
            @WebParam(name = "orderId") int orderId,
            @WebParam(name = "status") String status);
    
    @WebMethod
    String cancelOrder(@WebParam(name = "orderId") int orderId);
    
    @WebMethod
    List<Order> getOrdersByStatus(@WebParam(name = "status") String status);
}