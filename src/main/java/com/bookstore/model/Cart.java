
package com.bookstore.model;

public class Cart {
    // Encapsulated fields
    private String cartID;
    private String userID;
    private String bookID;
    private int quantity;

    // No-args constructor
    public Cart() {
    }

    // Full constructor
    public Cart(String cartID, String userID, String bookID, int quantity) {
        this.cartID = cartID;
        this.userID = userID;
        this.bookID = bookID;
        this.quantity = quantity;
    }

    // Getters and Setters
    public String getCartID() {
        return cartID;
    }

    public void setCartID(String cartID) {
        this.cartID = cartID;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getBookID() {
        return bookID;
    }

    public void setBookID(String bookID) {
        this.bookID = bookID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    // Convert to file string
    // Cart uses Aggregation — a cart entry references a Book via bookID
    public String toFileString() {
        return cartID + " | " + userID + " | " + bookID + " | " + quantity;
    }

    // Parse from file string
    public static Cart fromFileString(String line) {
        String[] parts = line.split(" \\| ");
        if (parts.length == 4) {
            return new Cart(parts[0], parts[1], parts[2], Integer.parseInt(parts[3]));
        }
        return null;
    }

    @Override
    public String toString() {
        return "Cart{" +
                "cartID='" + cartID + '\'' +
                ", userID='" + userID + '\'' +
                ", bookID='" + bookID + '\'' +
                ", quantity=" + quantity +
                '}';
    }
}