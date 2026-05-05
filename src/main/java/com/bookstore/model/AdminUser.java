package com.bookstore.model;

public class Order {
    // Encapsulated fields
    private String orderID;
    private String userID;
    private String bookID;
    private int quantity;
    private double totalAmount;
    private String status; // PENDING, CONFIRMED, CANCELLED, DELIVERED

    // No-args constructor
    public Order() {
    }

    // Full constructor
    public Order(String orderID, String userID, String bookID, int quantity, double totalAmount, String status) {
        this.orderID = orderID;
        this.userID = userID;
        this.bookID = bookID;
        this.quantity = quantity;
        this.totalAmount = totalAmount;
        this.status = status;
    }

    // Getters and Setters
    public String getOrderID() {
        return orderID;
    }

    public void setOrderID(String orderID) {
        this.orderID = orderID;
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

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // Convert to file string
    // Note: Order uses Aggregation (an Order references a Book via bookID)
    public String toFileString() {
        return orderID + " | " + userID + " | " + bookID + " | " + quantity + " | " + totalAmount + " | " + status;
    }

    // Parse from file string
    public static Order fromFileString(String line) {
        String[] parts = line.split(" \\| ");
        if (parts.length == 6) {
            return new Order(parts[0], parts[1], parts[2],
                    Integer.parseInt(parts[3]),
                    Double.parseDouble(parts[4]),
                    parts[5]);
        }
        return null;
    }

    @Override
    public String toString() {
        return "Order{" +
                "orderID='" + orderID + '\'' +
                ", userID='" + userID + '\'' +
                ", bookID='" + bookID + '\'' +
                ", quantity=" + quantity +
                ", totalAmount=" + totalAmount +
                ", status='" + status + '\'' +
                '}';
    }
}