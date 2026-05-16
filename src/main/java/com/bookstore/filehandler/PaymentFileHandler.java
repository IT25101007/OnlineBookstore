package com.bookstore.filehandler;

import com.bookstore.model.Payment;
import com.bookstore.model.CreditCardPayment;
import com.bookstore.model.PayPalPayment;
import java.io.*;
import java.nio.file.*;
import java.util.*;

public class PaymentFileHandler {

    public static List<Payment> getAllPayments(String filePath) {
        List<Payment> payments = new ArrayList<>();
        try {
            Path path = Paths.get(filePath);
            if (Files.exists(path)) {
                List<String> lines = Files.readAllLines(path);
                for (String line : lines) {
                    String trimmedLine = line.trim();
                    if (!trimmedLine.isEmpty()) {
                        Payment payment = Payment.fromFileString(trimmedLine);
                        if (payment != null) {
                            payments.add(payment);
                        }
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading payments file: " + e.getMessage());
        }
        return payments;
    }

    public static void saveAllPayments(List<Payment> payments, String filePath) {
        try {
            Path path = Paths.get(filePath);
            Files.createDirectories(path.getParent());

            List<String> lines = new ArrayList<>();
            for (Payment payment : payments) {
                lines.add(payment.toFileString());
            }
            Files.write(path, lines);
        } catch (IOException e) {
            System.err.println("Error saving payments file: " + e.getMessage());
        }
    }

    public static Payment getPaymentByID(String paymentID, String filePath) {
        List<Payment> payments = getAllPayments(filePath);
        for (Payment payment : payments) {
            if (payment.getPaymentID().equals(paymentID)) {
                return payment;
            }
        }
        return null;
    }

    public static Payment getPaymentByOrderID(String orderID, String filePath) {
        List<Payment> payments = getAllPayments(filePath);
        for (Payment payment : payments) {
            if (payment.getOrderID().equals(orderID)) {
                return payment;
            }
        }
        return null;
    }

    public static boolean addPayment(Payment payment, String filePath) {
        try {
            Path path = Paths.get(filePath);
            Files.createDirectories(path.getParent());
            Files.write(path, (payment.toFileString() + System.lineSeparator()).getBytes(),
                    StandardOpenOption.CREATE, StandardOpenOption.APPEND);
            return true;
        } catch (IOException e) {
            System.err.println("Error adding payment: " + e.getMessage());
            return false;
        }
    }

    public static boolean updatePaymentStatus(String paymentID, String newStatus, String filePath) {
        Payment payment = getPaymentByID(paymentID, filePath);
        if (payment != null) {
            payment.setStatus(newStatus);
            return updatePayment(payment, filePath);
        }
        return false;
    }

    private static boolean updatePayment(Payment updatedPayment, String filePath) {
        List<Payment> payments = getAllPayments(filePath);
        boolean found = false;

        for (int i = 0; i < payments.size(); i++) {
            if (payments.get(i).getPaymentID().equals(updatedPayment.getPaymentID())) {
                payments.set(i, updatedPayment);
                found = true;
                break;
            }
        }

        if (found) {
            saveAllPayments(payments, filePath);
            return true;
        }
        return false;
    }

    public static boolean deletePayment(String paymentID, String filePath) {
        List<Payment> payments = getAllPayments(filePath);
        boolean removed = payments.removeIf(payment -> payment.getPaymentID().equals(paymentID));

        if (removed) {
            saveAllPayments(payments, filePath);
            return true;
        }
        return false;
    }
}
