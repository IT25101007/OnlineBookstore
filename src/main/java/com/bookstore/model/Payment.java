package com.bookstore.model;

import java.time.LocalDate;

public abstract class Payment {
    // Encapsulated fields
    private String paymentID;
    private String orderID;
    private double amount;
    private String method;
    private String date;
    private String status; // PENDING, COMPLETED, FAILED, CANCELLED

    // No-args constructor
    public Payment() {
    }

    // Full constructor
    public Payment(String paymentID, String orderID, double amount, String method, String date, String status) {
        this.paymentID = paymentID;
        this.orderID = orderID;
        this.amount = amount;
        this.method = method;
        this.date = date;
        this.status = status;
    }

    // Getters and Setters
    public String getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(String paymentID) {
        this.paymentID = paymentID;
    }

    public String getOrderID() {
        return orderID;
    }

    public void setOrderID(String orderID) {
        this.orderID = orderID;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // Abstract method - polymorphism
    public abstract String processPayment();

    // Concrete method to convert to file string
    public String toFileString() {
        return paymentID + " | " + orderID + " | " + amount + " | " + method + " | " + date + " | " + status;
    }

    // Static factory method
    public static Payment fromFileString(String line) {
        String[] parts = line.split(" \\| ");
        if (parts.length == 6) {
            String method = parts[3];
            if (method.contains("CREDIT")) {
                CreditCardPayment payment = new CreditCardPayment();
                payment.setPaymentID(parts[0]);
                payment.setOrderID(parts[1]);
                payment.setAmount(Double.parseDouble(parts[2]));
                payment.setMethod(parts[3]);
                payment.setDate(parts[4]);
                payment.setStatus(parts[5]);
                return payment;
            } else {
                PayPalPayment payment = new PayPalPayment();
                payment.setPaymentID(parts[0]);
                payment.setOrderID(parts[1]);
                payment.setAmount(Double.parseDouble(parts[2]));
                payment.setMethod(parts[3]);
                payment.setDate(parts[4]);
                payment.setStatus(parts[5]);
                return payment;
            }
        }
        return null;
    }

    @Override
    public String toString() {
        return "Payment{" +
                "paymentID='" + paymentID + '\'' +
                ", orderID='" + orderID + '\'' +
                ", amount=" + amount +
                ", method='" + method + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
//Updated code