package com.bookstore.controller;

import com.bookstore.filehandler.OrderFileHandler;
import com.bookstore.filehandler.BookFileHandler;
import com.bookstore.filehandler.BookInventoryFileHandler;
import com.bookstore.model.Order;
import com.bookstore.model.Book;
import com.bookstore.model.User;
import com.bookstore.util.IDGenerator;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
public class OrderController {

    private static final String DATA_FOLDER = "data/";

    private String getDataPath(String fileName) {
        String projectPath = System.getProperty("user.dir");
        return projectPath + "/" + DATA_FOLDER + fileName;
    }

    private User getSessionUser(HttpSession session) {
        return (User) session.getAttribute("user");
    }

    @GetMapping("/orders")
    public String listOrders(HttpSession session, Model model) {
        User user = getSessionUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        String ordersPath = getDataPath("orders.txt");
        List<Order> orders;

        if ("ADMIN".equals(user.getRole())) {
            orders = OrderFileHandler.getAllOrders(ordersPath);
        } else {
            orders = OrderFileHandler.getOrdersByUserID(user.getUserID(), ordersPath);
        }
        // Newest orders first
        java.util.Collections.reverse(orders);

        model.addAttribute("orders", orders);
        return "orderHistory";
    }

    @GetMapping("/order/status")
    public String orderStatus(@RequestParam String orderID, Model model) {
        String ordersPath = getDataPath("orders.txt");
        Order order = OrderFileHandler.getOrderByID(orderID, ordersPath);
        model.addAttribute("order", order);
        return "orderStatus";
    }

    @PostMapping("/order/place")
    public String placeOrder(HttpSession session) {
        User user = getSessionUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        String ordersPath = getDataPath("orders.txt");
        String booksPath = getDataPath("books.txt");
        String cartPath = getDataPath("cart.txt");

        // Get all cart items for the user
        List<com.bookstore.model.Cart> cartItems = com.bookstore.filehandler.CartFileHandler.getCartByUserID(user.getUserID(), cartPath);
        if (cartItems == null || cartItems.isEmpty()) {
            return "redirect:/cart";
        }

        String lastOrderID = null;
        for (com.bookstore.model.Cart cartItem : cartItems) {
            Book book = BookFileHandler.getBookByID(cartItem.getBookID(), booksPath);
            if (book == null || !BookInventoryFileHandler.hasEnoughStock(cartItem.getBookID(), cartItem.getQuantity(), booksPath)) continue;

            double totalAmount = book.getPrice() * cartItem.getQuantity();
            String orderID = IDGenerator.generateOrderID();
            Order order = new Order(orderID, user.getUserID(), cartItem.getBookID(), cartItem.getQuantity(), totalAmount, "PENDING");
            OrderFileHandler.addOrder(order, ordersPath);

            BookInventoryFileHandler.reduceStock(cartItem.getBookID(), cartItem.getQuantity(), booksPath);
            lastOrderID = orderID;
        }

        com.bookstore.filehandler.CartFileHandler.clearCartForUser(user.getUserID(), cartPath);

        if (lastOrderID != null) {
            return "redirect:/order/status?orderID=" + lastOrderID;
        }
        return "redirect:/cart?error=insufficient_stock";
    }

    @PostMapping("/order/update")
    public String updateOrderStatus(@RequestParam String orderID,
                                    @RequestParam String status,
                                    HttpSession session) {
        User user = getSessionUser(session);
        if (user == null || !"ADMIN".equals(user.getRole())) {
            return "redirect:/login";
        }

        String ordersPath = getDataPath("orders.txt");
        OrderFileHandler.updateOrderStatus(orderID, status, ordersPath);
        return "redirect:/orders";
    }

    @PostMapping("/order/delete")
    public String deleteOrder(@RequestParam String orderID, HttpSession session) {
        User user = getSessionUser(session);
        if (user == null || !"ADMIN".equals(user.getRole())) {
            return "redirect:/login";
        }

        String ordersPath = getDataPath("orders.txt");
        OrderFileHandler.deleteOrder(orderID, ordersPath);
        return "redirect:/orders";
    }
}
