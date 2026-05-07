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

}
