package com.bookstore.servlet_backup;

import com.bookstore.filehandler.OrderFileHandler;
import com.bookstore.filehandler.CartFileHandler;
import com.bookstore.filehandler.BookFileHandler;
import com.bookstore.model.Order;
import com.bookstore.model.Book;
import com.bookstore.model.User;
import com.bookstore.util.IDGenerator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/orders", "/order/place", "/order/update", "/order/delete", "/order/status"})
public class OrderServlet extends HttpServlet {

    private static final String DATA_FOLDER = "data/";

    private String getDataPath(String fileName, HttpServletRequest request) {
        String realPath = request.getServletContext().getRealPath("/");
        if (realPath == null) {
            return DATA_FOLDER + fileName;
        }
        return realPath + "../../" + DATA_FOLDER + fileName;
    }

    private boolean isAdmin(HttpServletRequest request) {
        User user = (User) request.getSession().getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole());
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
            case "/orders":
                List<Order> orders;
                if (isAdmin(request)) {
                    orders = OrderFileHandler.getAllOrders(ordersPath);
                } else {
                    orders = OrderFileHandler.getOrdersByUserID(user.getUserID(), ordersPath);
                }
                request.setAttribute("orders", orders);
                request.getRequestDispatcher("/WEB-INF/views/orderHistory.jsp").forward(request, response);
                break;

            case "/order/status":
                String orderID = request.getParameter("orderID");
                Order order = OrderFileHandler.getOrderByID(orderID, ordersPath);
                request.setAttribute("order", order);
                request.getRequestDispatcher("/WEB-INF/views/orderStatus.jsp").forward(request, response);
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
        String ordersPath = getDataPath("orders.txt", request);
        String booksPath = getDataPath("books.txt", request);
        String cartPath = getDataPath("cart.txt", request);

        switch (path) {
            case "/order/place":
                handlePlaceOrder(request, response, user, ordersPath, booksPath, cartPath);
                break;

            case "/order/update":
                if (isAdmin(request)) {
                    String orderID = request.getParameter("orderID");
                    String newStatus = request.getParameter("status");
                    boolean success = OrderFileHandler.updateOrderStatus(orderID, newStatus, ordersPath);
                    if (success) {
                        System.out.println("Order " + orderID + " status updated to: " + newStatus);
                    }
                }
                response.sendRedirect("/orders");
                break;

            case "/order/delete":
                if (isAdmin(request)) {
                    String orderID = request.getParameter("orderID");
                    boolean success = OrderFileHandler.deleteOrder(orderID, ordersPath);
                    if (success) {
                        System.out.println("Order " + orderID + " deleted successfully");
                    }
                }
                response.sendRedirect("/orders");
                break;

            default:
                response.sendRedirect("/orders");
                break;
        }
    }

    private void handlePlaceOrder(HttpServletRequest request, HttpServletResponse response,
                                  User user, String ordersPath, String booksPath, String cartPath)
            throws IOException {
        String bookID = request.getParameter("bookID");
        String quantityParam = request.getParameter("quantity");

        if (bookID == null || quantityParam == null) {
            response.sendRedirect("/cart?error=missing_info");
            return;
        }

        int quantity;
        try {
            quantity = Integer.parseInt(quantityParam);
            if (quantity <= 0) {
                response.sendRedirect("/book/detail?bookID=" + bookID + "&error=invalid_quantity");
                return;
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("/book/detail?bookID=" + bookID + "&error=invalid_quantity");
            return;
        }

        Book book = BookFileHandler.getBookByID(bookID, booksPath);

        if (book == null) {
            response.sendRedirect("/books?error=book_not_found");
            return;
        }

        if (book.getStock() < quantity) {
            response.sendRedirect("/book/detail?bookID=" + bookID + "&error=insufficient_stock");
            return;
        }

        double totalAmount = book.getPrice() * quantity;
        String orderID = IDGenerator.generateOrderID();

        Order order = new Order(orderID, user.getUserID(), bookID, quantity, totalAmount, "PENDING");
        boolean orderAdded = OrderFileHandler.addOrder(order, ordersPath);

        if (!orderAdded) {
            response.sendRedirect("/cart?error=order_failed");
            return;
        }

        // Update stock
        int newStock = book.getStock() - quantity;
        BookFileHandler.updateStock(bookID, newStock, booksPath);

        // Clear cart for this user (remove all items)
        CartFileHandler.clearCartForUser(user.getUserID(), cartPath);

        response.sendRedirect("/orders?success=order_placed");
    }
}