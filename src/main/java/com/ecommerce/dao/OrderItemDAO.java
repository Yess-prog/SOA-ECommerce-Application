package com.ecommerce.dao;

import com.ecommerce.model.OrderItem;
import com.ecommerce.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for OrderItem entity
 * Location: com.ecommerce.dao package
 */
public class OrderItemDAO {
    
    /**
     * Add an order item
     */
    public boolean addOrderItem(OrderItem orderItem) {
        String sql = "INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, orderItem.getOrderId());
            pstmt.setInt(2, orderItem.getProductId());
            pstmt.setInt(3, orderItem.getQuantity());
            pstmt.setDouble(4, orderItem.getUnitPrice());
            pstmt.setDouble(5, orderItem.getSubtotal());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding order item: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Add multiple order items (batch insert)
     */
    public boolean addOrderItems(List<OrderItem> orderItems) {
        String sql = "INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            conn.setAutoCommit(false); // Start transaction
            
            for (OrderItem item : orderItems) {
                pstmt.setInt(1, item.getOrderId());
                pstmt.setInt(2, item.getProductId());
                pstmt.setInt(3, item.getQuantity());
                pstmt.setDouble(4, item.getUnitPrice());
                pstmt.setDouble(5, item.getSubtotal());
                pstmt.addBatch();
            }
            
            int[] results = pstmt.executeBatch();
            conn.commit(); // Commit transaction
            
            return results.length == orderItems.size();
            
        } catch (SQLException e) {
            System.err.println("Error adding order items: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get all items for a specific order
     */
    public List<OrderItem> getOrderItemsByOrderId(int orderId) {
        List<OrderItem> orderItems = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE order_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, orderId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                orderItems.add(extractOrderItemFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting order items: " + e.getMessage());
            e.printStackTrace();
        }
        
        return orderItems;
    }
    
    /**
     * Get order item by ID
     */
    public OrderItem getOrderItemById(int orderItemId) {
        String sql = "SELECT * FROM order_items WHERE order_item_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, orderItemId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractOrderItemFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting order item by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Delete all items for a specific order
     */
    public boolean deleteOrderItemsByOrderId(int orderId) {
        String sql = "DELETE FROM order_items WHERE order_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, orderId);
            pstmt.executeUpdate();
            return true;
            
        } catch (SQLException e) {
            System.err.println("Error deleting order items: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get total number of items in an order
     */
    public int getOrderItemCount(int orderId) {
        String sql = "SELECT COUNT(*) FROM order_items WHERE order_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, orderId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting order item count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Helper method to extract OrderItem from ResultSet
     */
    private OrderItem extractOrderItemFromResultSet(ResultSet rs) throws SQLException {
        OrderItem orderItem = new OrderItem();
        orderItem.setOrderItemId(rs.getInt("order_item_id"));
        orderItem.setOrderId(rs.getInt("order_id"));
        orderItem.setProductId(rs.getInt("product_id"));
        orderItem.setQuantity(rs.getInt("quantity"));
        orderItem.setUnitPrice(rs.getDouble("unit_price"));
        orderItem.setSubtotal(rs.getDouble("subtotal"));
        return orderItem;
    }
}