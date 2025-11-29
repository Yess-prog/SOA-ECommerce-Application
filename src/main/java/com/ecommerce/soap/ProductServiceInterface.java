package com.ecommerce.soap;

import com.ecommerce.model.Product;
import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebService;
import java.util.List;

@WebService(name = "ProductService", targetNamespace = "http://soap.ecommerce.com/")
public interface ProductServiceInterface {
    
    @WebMethod
    String addProduct(
            @WebParam(name = "categoryId") int categoryId,
            @WebParam(name = "productName") String productName,
            @WebParam(name = "description") String description,
            @WebParam(name = "price") double price,
            @WebParam(name = "stockQuantity") int stockQuantity,
            @WebParam(name = "imageUrl") String imageUrl);
    
    @WebMethod
    List<Product> getAllProducts();
    
    @WebMethod
    List<Product> getAllProductsForAdmin();
    
    @WebMethod
    Product getProductById(@WebParam(name = "productId") int productId);
    
    @WebMethod
    List<Product> getProductsByCategory(@WebParam(name = "categoryId") int categoryId);
    
    @WebMethod
    List<Product> searchProducts(@WebParam(name = "keyword") String keyword);
    
    @WebMethod
    String updateProduct(
            @WebParam(name = "productId") int productId,
            @WebParam(name = "categoryId") int categoryId,
            @WebParam(name = "productName") String productName,
            @WebParam(name = "description") String description,
            @WebParam(name = "price") double price,
            @WebParam(name = "stockQuantity") int stockQuantity,
            @WebParam(name = "imageUrl") String imageUrl,
            @WebParam(name = "status") String status);
    
    @WebMethod
    String deleteProduct(@WebParam(name = "productId") int productId);
    
    @WebMethod
    String updateStock(
            @WebParam(name = "productId") int productId,
            @WebParam(name = "newQuantity") int newQuantity);
}