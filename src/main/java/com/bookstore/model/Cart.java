package com.bookstore.model;

public class Cart {

    private String cartID;
    private String userID;
    private String bookID;
    private int quantity;

    public Cart() {
    }

    public Cart(String cartID, String userID, String bookID, int quantity) {
        this.cartID = cartID;
        this.userID = userID;
        this.bookID = bookID;
        this.quantity = quantity;
    }

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

}
