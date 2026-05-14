
package com.bookstore.model;

public class CreditCardPayment extends Payment {
    private String cardLastFour;

    public CreditCardPayment() {
        setMethod("CREDIT_CARD");
    }

    public CreditCardPayment(String paymentID, String orderID, double amount, String date, String status, String cardLastFour) {
        super(paymentID, orderID, amount, "CREDIT_CARD", date, status);
        this.cardLastFour = cardLastFour;
    }

    public String getCardLastFour() {
        return cardLastFour;
    }

    public void setCardLastFour(String cardLastFour) {
        this.cardLastFour = cardLastFour;
    }

    @Override
    public String processPayment() {
        return "Processing credit card ending in " + cardLastFour;
    }

    @Override
    public String toString() {
        return "CreditCardPayment{" +
                "paymentID='" + getPaymentID() + '\'' +
                ", orderID='" + getOrderID() + '\'' +
                ", amount=" + getAmount() +
                ", cardLastFour='" + cardLastFour + '\'' +
                ", status='" + getStatus() + '\'' +
                '}';
    }
}