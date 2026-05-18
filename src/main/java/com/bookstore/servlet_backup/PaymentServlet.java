package com.bookstore.servlet_backup;

import com.bookstore.filehandler.PaymentFileHandler;
import com.bookstore.filehandler.OrderFileHandler;
import com.bookstore.model.Payment;
import com.bookstore.model.CreditCardPayment;
import com.bookstore.model.PayPalPayment;
import com.bookstore.model.Order;
import com.bookstore.model.User;
import com.bookstore.util.IDGenerator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet(urlPatterns = {"/payment", "/payment/process", "/payment/invoice", "/payment/cancel"})
public class PaymentServlet extends HttpServlet {

    private static final String DATA_FOLDER = "data/";

    private String getDataPath(String fileName, HttpServletRequest request) {
        String realPath = request.getServletContext().getRealPath("/");
        if (realPath == null) {
            return DATA_FOLDER + fileName;
        }
        return realPath + "../../" + DATA_FOLDER + fileName;
    }

    private User getSessionUser(HttpServletRequest request) {
        return (User) request.getSession().getAttribute("user");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = getSessionUser(request);
        if (user == null) {
            response.sendRedirect("/login");
            return;
        }

        String path = request.getServletPath();
        String ordersPath = getDataPath("orders.txt", request);

        switch (path) {
            case "/payment":
                String orderID = request.getParameter("orderID");
                if (orderID == null) {
                    response.sendRedirect("/orders");
                    return;
                }
                Order order = OrderFileHandler.getOrderByID(orderID, ordersPath);
                if (order == null || !order.getUserID().equals(user.getUserID())) {
                    response.sendRedirect("/orders");
                    return;
                }
                request.setAttribute("order", order);
                request.getRequestDispatcher("/WEB-INF/views/paymentForm.jsp").forward(request, response);
                break;

            case "/payment/invoice":
                String paymentID = request.getParameter("paymentID");
                if (paymentID == null) {
                    response.sendRedirect("/orders");
                    return;
                }
                String paymentsPath = getDataPath("payments.txt", request);
                Payment payment = PaymentFileHandler.getPaymentByID(paymentID, paymentsPath);
                if (payment == null) {
                    response.sendRedirect("/orders");
                    return;
                }
                Order linkedOrder = OrderFileHandler.getOrderByID(payment.getOrderID(), ordersPath);
                request.setAttribute("payment", payment);
                request.setAttribute("order", linkedOrder);
                request.getRequestDispatcher("/WEB-INF/views/invoice.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect("/orders");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User user = getSessionUser(request);
        if (user == null) {
            response.sendRedirect("/login");
            return;
        }

        String path = request.getServletPath();
        String paymentsPath = getDataPath("payments.txt", request);
        String ordersPath = getDataPath("orders.txt", request);

        switch (path) {
            case "/payment/process":
                handleProcessPayment(request, response, user, paymentsPath, ordersPath);
                break;

            case "/payment/cancel":
                String paymentID = request.getParameter("paymentID");
                if (paymentID != null) {
                    PaymentFileHandler.updatePaymentStatus(paymentID, "CANCELLED", paymentsPath);
                }
                response.sendRedirect("/orders");
                break;

            default:
                response.sendRedirect("/orders");
                break;
        }
    }

    private void handleProcessPayment(HttpServletRequest request, HttpServletResponse response,
                                      User user, String paymentsPath, String ordersPath) throws IOException {
        String orderID = request.getParameter("orderID");
        String amountStr = request.getParameter("amount");
        String method = request.getParameter("method");

        if (orderID == null || amountStr == null || method == null) {
            response.sendRedirect("/orders?error=payment_failed");
            return;
        }

        double amount;
        try {
            amount = Double.parseDouble(amountStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("/orders?error=invalid_amount");
            return;
        }

        String paymentID = IDGenerator.generatePaymentID();
        String date = LocalDate.now().toString();
        Payment payment;
        String confirmationMessage;

        if ("CREDIT_CARD".equals(method)) {
            String cardLastFour = request.getParameter("cardLastFour");
            if (cardLastFour == null || cardLastFour.trim().isEmpty()) {
                cardLastFour = "1234";
            }
            payment = new CreditCardPayment(paymentID, orderID, amount, date, "COMPLETED", cardLastFour);
            confirmationMessage = payment.processPayment();
        } else {
            String paypalEmail = request.getParameter("paypalEmail");
            if (paypalEmail == null || paypalEmail.trim().isEmpty()) {
                paypalEmail = user.getEmail();
            }
            payment = new PayPalPayment(paymentID, orderID, amount, date, "COMPLETED", paypalEmail);
            confirmationMessage = payment.processPayment();
        }

        boolean success = PaymentFileHandler.addPayment(payment, paymentsPath);

        if (success) {
            // Update order status to CONFIRMED
            OrderFileHandler.updateOrderStatus(orderID, "CONFIRMED", ordersPath);
            request.getSession().setAttribute("paymentMessage", confirmationMessage);
            response.sendRedirect("/payment/invoice?paymentID=" + paymentID);
        } else {
            response.sendRedirect("/orders?error=payment_failed");
        }
    }
}