package com.bookstore.controller;

import com.bookstore.filehandler.PaymentFileHandler;
import com.bookstore.filehandler.OrderFileHandler;
import com.bookstore.model.Payment;
import com.bookstore.model.CreditCardPayment;
import com.bookstore.model.PayPalPayment;
import com.bookstore.model.Order;
import com.bookstore.model.User;
import com.bookstore.util.IDGenerator;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

@Controller
public class PaymentController {

    private static final String DATA_FOLDER = "data/";

    private String getDataPath(String fileName) {
        String projectPath = System.getProperty("user.dir");
        return projectPath + "/" + DATA_FOLDER + fileName;
    }

    private User getSessionUser(HttpSession session) {
        return (User) session.getAttribute("user");
    }

    @GetMapping("/payment")
    public String showPaymentForm(@RequestParam String orderID,
                                  HttpSession session,
                                  Model model) {
        User user = getSessionUser(session);
        if (user == null) return "redirect:/login";

        String ordersPath = getDataPath("orders.txt");
        Order order = OrderFileHandler.getOrderByID(orderID, ordersPath);

        if (order == null) {
            System.err.println("[PaymentController] Order not found: " + orderID);
            return "redirect:/orders";
        }

        model.addAttribute("order", order);
        return "paymentForm";
    }

    @PostMapping("/payment/process")
    public String processPayment(@RequestParam String orderID,
                                 @RequestParam double amount,
                                 @RequestParam String method,
                                 @RequestParam(required = false) String cardLastFour,
                                 @RequestParam(required = false) String paypalEmail,
                                 HttpSession session) {
        User user = getSessionUser(session);
        if (user == null) return "redirect:/login";

        String paymentsPath = getDataPath("payments.txt");
        String ordersPath   = getDataPath("orders.txt");

        String paymentID = IDGenerator.generatePaymentID();
        String date      = LocalDate.now().toString();

        Payment payment;
        if ("CREDIT_CARD".equals(method)) {
            payment = new CreditCardPayment(paymentID, orderID, amount, date, "COMPLETED", cardLastFour);
        } else {
            payment = new PayPalPayment(paymentID, orderID, amount, date, "COMPLETED", paypalEmail);
        }

        // ── Save payment ──────────────────────────────────────
        boolean saved = PaymentFileHandler.addPayment(payment, paymentsPath);
        if (!saved) {
            System.err.println("[PaymentController] Failed to save payment: " + paymentID);
            return "redirect:/orders?error=payment_failed";
        }

        // ── Update order status ───────────────────────────────
        OrderFileHandler.updateOrderStatus(orderID, "CONFIRMED", ordersPath);

        session.setAttribute("paymentMessage", payment.processPayment());

        System.out.println("[PaymentController] Payment saved: " + paymentID
                + " | File: " + paymentsPath);

        return "redirect:/payment/invoice?paymentID=" + paymentID;
    }

    @GetMapping("/payment/invoice")
    public String showInvoice(@RequestParam String paymentID,
                              HttpSession session,
                              Model model) {

        // ── Auth guard ────────────────────────────────────────
        User user = getSessionUser(session);
        if (user == null) return "redirect:/login";

        String paymentsPath = getDataPath("payments.txt");
        String ordersPath   = getDataPath("orders.txt");

        System.out.println("[PaymentController] Looking for paymentID: " + paymentID);
        System.out.println("[PaymentController] Payments file path: " + paymentsPath);

        // ── Null-safe payment lookup ──────────────────────────
        Payment payment = PaymentFileHandler.getPaymentByID(paymentID, paymentsPath);
        if (payment == null) {
            System.err.println("[PaymentController] Payment not found: " + paymentID);
            model.addAttribute("error", "Payment not found: " + paymentID);
            return "redirect:/orders?error=payment_not_found";
        }

        // ── Null-safe order lookup ────────────────────────────
        Order order = OrderFileHandler.getOrderByID(payment.getOrderID(), ordersPath);
        if (order == null) {
            System.err.println("[PaymentController] Order not found for payment: "
                    + payment.getOrderID());
        }

        model.addAttribute("payment", payment);
        model.addAttribute("order", order);
        return "invoice";
    }

    @PostMapping("/payment/cancel")
    public String cancelPayment(@RequestParam String paymentID) {
        String paymentsPath = getDataPath("payments.txt");
        PaymentFileHandler.updatePaymentStatus(paymentID, "CANCELLED", paymentsPath);
        return "redirect:/orders";
    }
}