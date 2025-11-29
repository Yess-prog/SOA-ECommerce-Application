package com.ecommerce.soap;

import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.Product;
import com.ecommerce.model.Product.ProductStatus;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebService;
import java.util.List;

/**
 * SOAP Web Service for Product operations
 * Location: com.ecommerce.soap package
 */
@WebService(
    serviceName = "ProductService",
    portName = "ProductServicePort",
    targetNamespace = "http://soap.ecommerce.com/",
    endpointInterface = "com.ecommerce.soap.ProductServiceInterface"
)
public class ProductService implements ProductServiceInterface {
    
    private ProductDAO productDAO = new ProductDAO();
    
    /**
     * Add new product (Admin only)
     */
    @WebMethod
    public String addProduct(
            @WebParam(name = "categoryId") int categoryId,
            @WebParam(name = "productName") String productName,
            @WebParam(name = "description") String description,
            @WebParam(name = "price") double price,
            @WebParam(name = "stockQuantity") int stockQuantity,
            @WebParam(name = "imageUrl") String imageUrl) {
        
        try {
            Product product = new Product(categoryId, productName, description, price, stockQuantity);
            product.setImageUrl(imageUrl);
            
            boolean success = productDAO.addProduct(product);
            
            if (success) {
                return "SUCCESS: Product added successfully";
            } else {
                return "ERROR: Failed to add product";
            }
            
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
    
    /**
     * Get all active products (for customers)
     */
    @WebMethod
    public List<Product> getAllProducts() {
        try {
            return productDAO.getAllProducts();
        } catch (Exception e) {
            System.err.println("Error getting products: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Get all products including inactive (Admin only)
     */
    @WebMethod
    public List<Product> getAllProductsForAdmin() {
        try {
            return productDAO.getAllProductsForAdmin();
        } catch (Exception e) {
            System.err.println("Error getting all products: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Get product by ID
     */
    @WebMethod
    public Product getProductById(@WebParam(name = "productId") int productId) {
        try {
            return productDAO.getProductById(productId);
        } catch (Exception e) {
            System.err.println("Error getting product: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Get products by category
     */
    @WebMethod
    public List<Product> getProductsByCategory(@WebParam(name = "categoryId") int categoryId) {
        try {
            return productDAO.getProductsByCategory(categoryId);
        } catch (Exception e) {
            System.err.println("Error getting products by category: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Search products by name
     */
    @WebMethod
    public List<Product> searchProducts(@WebParam(name = "keyword") String keyword) {
        try {
            return productDAO.searchProducts(keyword);
        } catch (Exception e) {
            System.err.println("Error searching products: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Update product (Admin only)
     */
    @WebMethod
    public String updateProduct(
            @WebParam(name = "productId") int productId,
            @WebParam(name = "categoryId") int categoryId,
            @WebParam(name = "productName") String productName,
            @WebParam(name = "description") String description,
            @WebParam(name = "price") double price,
            @WebParam(name = "stockQuantity") int stockQuantity,
            @WebParam(name = "imageUrl") String imageUrl,
            @WebParam(name = "status") String status) {
        
        try {
            Product product = productDAO.getProductById(productId);
            
            if (product == null) {
                return "ERROR: Product not found";
            }
            
            product.setCategoryId(categoryId);
            product.setProductName(productName);
            product.setDescription(description);
            product.setPrice(price);
            product.setStockQuantity(stockQuantity);
            product.setImageUrl(imageUrl);
            product.setStatus(ProductStatus.valueOf(status));
            
            boolean success = productDAO.updateProduct(product);
            
            if (success) {
                return "SUCCESS: Product updated successfully";
            } else {
                return "ERROR: Failed to update product";
            }
            
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
    
    /**
     * Delete product (Admin only)
     */
    @WebMethod
    public String deleteProduct(@WebParam(name = "productId") int productId) {
        try {
            boolean success = productDAO.deleteProduct(productId);
            
            if (success) {
                return "SUCCESS: Product deleted successfully";
            } else {
                return "ERROR: Failed to delete product";
            }
            
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
    
    /**
     * Update stock quantity (Admin only)
     */
    @WebMethod
    public String updateStock(
            @WebParam(name = "productId") int productId,
            @WebParam(name = "newQuantity") int newQuantity) {
        
        try {
            boolean success = productDAO.updateStock(productId, newQuantity);
            
            if (success) {
                return "SUCCESS: Stock updated successfully";
            } else {
                return "ERROR: Failed to update stock";
            }
            
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
}