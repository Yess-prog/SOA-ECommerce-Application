package com.ecommerce.soap;

import com.ecommerce.dao.OrderDAO;
import com.ecommerce.dao.OrderItemDAO;
import com.ecommerce.dao.CartDAO;
import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.Order;
import com.ecommerce.model.OrderItem;
import com.ecommerce.model.Cart;
import com.ecommerce.model.Product;
import com.ecommerce.model.Order.OrderStatus;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebService;
import java.util.List;

/**
 * SOAP Web Service for Order operations
 * Location: com.ecommerce.soap package
 */
@WebService(
    serviceName = "OrderService",
    portName = "OrderServicePort",
    targetNamespace = "http://soap.ecommerce.com/",
    endpointInterface = "com.ecommerce.soap.OrderServiceInterface"
)
public class OrderService implements OrderServiceInterface {
    
    private OrderDAO orderDAO = new OrderDAO();
    private OrderItemDAO orderItemDAO = new OrderItemDAO();
    private CartDAO cartDAO = new CartDAO();
    private ProductDAO productDAO = new ProductDAO();
    
    /**
     * Place order from cart
     */
    @WebMethod
    public String placeOrderFromCart(
            @WebParam(name = "userId") int userId,
            @WebParam(name = "shippingAddress") String shippingAddress,
            @WebParam(name = "paymentMethod") String paymentMethod) {
        
        try {
            // Get cart items
            List<Cart> cartItems = cartDAO.getCartByUserId(userId);
            
            if (cartItems.isEmpty()) {
                return "ERROR: Cart is empty";
            }
            
            // Calculate total amount and validate stock
            double totalAmount = 0;
            for (Cart cartItem : cartItems) {
                Product product = productDAO.getProductById(cartItem.getProductId());
                
                if (product == null) {
                    return "ERROR: Product not found (ID: " + cartItem.getProductId() + ")";
                }
                
                if (product.getStockQuantity() < cartItem.getQuantity()) {
                    return "ERROR: Insufficient stock for " + product.getProductName();
                }
                
                totalAmount += product.getPrice() * cartItem.getQuantity();
            }
            
            // Create order
            Order order = new Order(userId, totalAmount, shippingAddress, paymentMethod);
            int orderId = orderDAO.createOrder(order);
            
            if (orderId == -1) {
                return "ERROR: Failed to create order";
            }
            
            // Create order items and update stock
            for (Cart cartItem : cartItems) {
                Product product = productDAO.getProductById(cartItem.getProductId());
                
                OrderItem orderItem = new OrderItem(
                    orderId,
                    cartItem.getProductId(),
                    cartItem.getQuantity(),
                    product.getPrice()
                );
                
                orderItemDAO.addOrderItem(orderItem);
                
                // Update stock
                int newStock = product.getStockQuantity() - cartItem.getQuantity();
                productDAO.updateStock(cartItem.getProductId(), newStock);
            }
            
            // Clear cart
            cartDAO.clearCart(userId);
            
            return "SUCCESS: Order placed successfully. Order ID: " + orderId;
            
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
    
    /**
     * Get all orders (Admin only)
     */
    @WebMethod
    public List<Order> getAllOrders() {
        try {
            return orderDAO.getAllOrders();
        } catch (Exception e) {
            System.err.println("Error getting all orders: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Get orders by user ID
     */
    @WebMethod
    public List<Order> getOrdersByUserId(@WebParam(name = "userId") int userId) {
        try {
            return orderDAO.getOrdersByUserId(userId);
        } catch (Exception e) {
            System.err.println("Error getting user orders: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Get order by ID
     */
    @WebMethod
    public Order getOrderById(@WebParam(name = "orderId") int orderId) {
        try {
            return orderDAO.getOrderById(orderId);
        } catch (Exception e) {
            System.err.println("Error getting order: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Get order items for an order
     */
    @WebMethod
    public List<OrderItem> getOrderItems(@WebParam(name = "orderId") int orderId) {
        try {
            return orderItemDAO.getOrderItemsByOrderId(orderId);
        } catch (Exception e) {
            System.err.println("Error getting order items: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Update order status (Admin only)
     */
    @WebMethod
    public String updateOrderStatus(
            @WebParam(name = "orderId") int orderId,
            @WebParam(name = "status") String status) {
        
        try {
            OrderStatus orderStatus = OrderStatus.valueOf(status);
            boolean success = orderDAO.updateOrderStatus(orderId, orderStatus);
            
            if (success) {
                return "SUCCESS: Order status updated to " + status;
            } else {
                return "ERROR: Failed to update order status";
            }
            
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
    
    /**
     * Cancel order
     */
    @WebMethod
    public String cancelOrder(@WebParam(name = "orderId") int orderId) {
        try {
            Order order = orderDAO.getOrderById(orderId);
            
            if (order == null) {
                return "ERROR: Order not found";
            }
            
            if (order.getStatus() == OrderStatus.DELIVERED) {
                return "ERROR: Cannot cancel delivered order";
            }
            
            if (order.getStatus() == OrderStatus.CANCELLED) {
                return "ERROR: Order is already cancelled";
            }
            
            boolean success = orderDAO.cancelOrder(orderId);
            
            if (success) {
                // Restore stock
                List<OrderItem> orderItems = orderItemDAO.getOrderItemsByOrderId(orderId);
                for (OrderItem item : orderItems) {
                    Product product = productDAO.getProductById(item.getProductId());
                    int newStock = product.getStockQuantity() + item.getQuantity();
                    productDAO.updateStock(item.getProductId(), newStock);
                }
                
                return "SUCCESS: Order cancelled successfully";
            } else {
                return "ERROR: Failed to cancel order";
            }
            
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
    
    /**
     * Get orders by status (Admin only)
     */
    @WebMethod
    public List<Order> getOrdersByStatus(@WebParam(name = "status") String status) {
        try {
            OrderStatus orderStatus = OrderStatus.valueOf(status);
            return orderDAO.getOrdersByStatus(orderStatus);
        } catch (Exception e) {
            System.err.println("Error getting orders by status: " + e.getMessage());
            return null;
        }
    }
}