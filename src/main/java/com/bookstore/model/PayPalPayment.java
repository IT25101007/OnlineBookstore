package com.bookstore.model;

public class PayPalPayment extends Payment {
    private String paypalEmail;

    public PayPalPayment() {
        setMethod("PAYPAL");
    }

    public PayPalPayment(String paymentID, String orderID, double amount, String date, String status, String paypalEmail) {
        super(paymentID, orderID, amount, "PAYPAL", date, status);
        this.paypalEmail = paypalEmail;
    }

    public String getPaypalEmail() {
        return paypalEmail;
    }

    public void setPaypalEmail(String paypalEmail) {
        this.paypalEmail = paypalEmail;
    }

    @Override
    public String processPayment() {
        return "Processing PayPal payment for " + paypalEmail;
    }

    @Override
    public String toString() {
        return "PayPalPayment{" +
                "paymentID='" + getPaymentID() + '\'' +
                ", orderID='" + getOrderID() + '\'' +
                ", amount=" + getAmount() +
                ", paypalEmail='" + paypalEmail + '\'' +
                ", status='" + getStatus() + '\'' +
                '}';
    }
}