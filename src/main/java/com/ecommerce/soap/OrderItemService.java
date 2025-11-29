package com.ecommerce.soap;

import com.ecommerce.dao.OrderItemDAO;
import com.ecommerce.model.OrderItem;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebService;
import java.util.List;

/**
 * SOAP Web Service for OrderItem operations
 * Location: com.ecommerce.soap package
 */
@WebService(serviceName = "OrderItemService")
public class OrderItemService {
    
    private OrderItemDAO orderItemDAO = new OrderItemDAO();
    
    /**
     * Add an order item
     * Typically used internally, but available if needed
     */
    @WebMethod
    public String addOrderItem(
            @WebParam(name = "orderId") int orderId,
            @WebParam(name = "productId") int productId,
            @WebParam(name = "quantity") int quantity,
            @WebParam(name = "unitPrice") double unitPrice) {
        
        try {
            OrderItem orderItem = new OrderItem(orderId, productId, quantity, unitPrice);
            boolean success = orderItemDAO.addOrderItem(orderItem);
            
            if (success) {
                return "SUCCESS: Order item added successfully";
            } else {
                return "ERROR: Failed to add order item";
            }
            
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
    
    /**
     * Get all items for a specific order
     */
    @WebMethod
    public List<OrderItem> getOrderItemsByOrderId(@WebParam(name = "orderId") int orderId) {
        try {
            return orderItemDAO.getOrderItemsByOrderId(orderId);
        } catch (Exception e) {
            System.err.println("Error getting order items: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Get order item by ID
     */
    @WebMethod
    public OrderItem getOrderItemById(@WebParam(name = "orderItemId") int orderItemId) {
        try {
            return orderItemDAO.getOrderItemById(orderItemId);
        } catch (Exception e) {
            System.err.println("Error getting order item: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Get total number of items in an order
     */
    @WebMethod
    public int getOrderItemCount(@WebParam(name = "orderId") int orderId) {
        try {
            return orderItemDAO.getOrderItemCount(orderId);
        } catch (Exception e) {
            System.err.println("Error getting order item count: " + e.getMessage());
            return 0;
        }
    }
    
    /**
     * Delete all items for a specific order (Admin only)
     * Use with caution!
     */
    @WebMethod
    public String deleteOrderItemsByOrderId(@WebParam(name = "orderId") int orderId) {
        try {
            boolean success = orderItemDAO.deleteOrderItemsByOrderId(orderId);
            
            if (success) {
                return "SUCCESS: Order items deleted successfully";
            } else {
                return "ERROR: Failed to delete order items";
            }
            
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
}