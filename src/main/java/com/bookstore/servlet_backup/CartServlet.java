package com.bookstore.servlet_backup;

import com.bookstore.filehandler.CartFileHandler;
import com.bookstore.filehandler.BookFileHandler;
import com.bookstore.model.Cart;
import com.bookstore.model.Book;
import com.bookstore.model.User;
import com.bookstore.util.IDGenerator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = {"/cart", "/cart/add", "/cart/update", "/cart/remove"})
public class CartServlet extends HttpServlet {

    private static final String DATA_FOLDER = "data/";

    private String getDataPath(String fileName, HttpServletRequest request) {
        String realPath = request.getServletContext().getRealPath("/");
        if (realPath == null || realPath.isEmpty()) {
            String projectPath = System.getProperty("user.dir");
            return projectPath + "/" + DATA_FOLDER + fileName;
        }
        return realPath + "../../" + DATA_FOLDER + fileName;
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (User) session.getAttribute("user");
    }

    private boolean checkLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = getSessionUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkLogin(request, response)) return;

        String path = request.getServletPath();
        System.out.println("CartServlet doGet called for path: " + path);

        if ("/cart".equals(path)) {
            String cartPath = getDataPath("cart.txt", request);
            String booksPath = getDataPath("books.txt", request);
            User user = getSessionUser(request);

            List<Cart> cartItems = CartFileHandler.getCartByUserID(user.getUserID(), cartPath);
            System.out.println("Found " + cartItems.size() + " cart items for user: " + user.getUserID());

            // Create a list to hold cart items with book details
            List<CartItemDisplay> displayItems = new ArrayList<>();
            double cartTotal = 0.0;

            for (Cart item : cartItems) {
                Book book = BookFileHandler.getBookByID(item.getBookID(), booksPath);
                if (book != null) {
                    double subtotal = book.getPrice() * item.getQuantity();
                    cartTotal += subtotal;
                    displayItems.add(new CartItemDisplay(item, book, subtotal));
                    System.out.println("Added item: " + book.getTitle() + " x " + item.getQuantity());
                } else {
                    System.out.println("Book not found for ID: " + item.getBookID());
                }
            }

            request.setAttribute("cartItems", displayItems);
            request.setAttribute("cartTotal", String.format("%.2f", cartTotal));
            request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (!checkLogin(request, response)) return;

        String path = request.getServletPath();
        String cartPath = getDataPath("cart.txt", request);
        User user = getSessionUser(request);

        System.out.println("CartServlet doPost called for path: " + path);

        switch (path) {
            case "/cart/add":
                handleAddToCart(request, response, user, cartPath);
                break;

            case "/cart/update":
                handleUpdateCart(request, response, cartPath);
                break;

            case "/cart/remove":
                handleRemoveFromCart(request, response, cartPath);
                break;

            default:
                response.sendRedirect("/cart");
                break;
        }
    }

    private void handleAddToCart(HttpServletRequest request, HttpServletResponse response,
                                 User user, String cartPath) throws IOException {
        String bookID = request.getParameter("bookID");
        String quantityParam = request.getParameter("quantity");

        System.out.println("Adding to cart - bookID: " + bookID + ", quantity: " + quantityParam);

        if (bookID == null || bookID.trim().isEmpty()) {
            response.sendRedirect("/books?error=missing_book");
            return;
        }

        int quantity = 1;
        if (quantityParam != null && !quantityParam.trim().isEmpty()) {
            try {
                quantity = Integer.parseInt(quantityParam);
                if (quantity <= 0) quantity = 1;
            } catch (NumberFormatException e) {
                quantity = 1;
            }
        }

        String cartID = IDGenerator.generateCartID();
        Cart cartItem = new Cart(cartID, user.getUserID(), bookID, quantity);

        boolean success = CartFileHandler.addToCart(cartItem, cartPath);

        if (success) {
            System.out.println("Added to cart successfully");
            response.sendRedirect("/cart");
        } else {
            System.out.println("Failed to add to cart");
            response.sendRedirect("/book/detail?bookID=" + bookID + "&error=cart_failed");
        }
    }

    private void handleUpdateCart(HttpServletRequest request, HttpServletResponse response,
                                  String cartPath) throws IOException {
        String cartID = request.getParameter("cartID");
        String quantityParam = request.getParameter("quantity");

        if (cartID == null || cartID.trim().isEmpty()) {
            response.sendRedirect("/cart");
            return;
        }

        int newQuantity = 1;
        if (quantityParam != null && !quantityParam.trim().isEmpty()) {
            try {
                newQuantity = Integer.parseInt(quantityParam);
            } catch (NumberFormatException e) {
                newQuantity = 1;
            }
        }

        if (newQuantity <= 0) {
            CartFileHandler.removeFromCart(cartID, cartPath);
        } else {
            CartFileHandler.updateCartQuantity(cartID, newQuantity, cartPath);
        }

        response.sendRedirect("/cart");
    }

    private void handleRemoveFromCart(HttpServletRequest request, HttpServletResponse response,
                                      String cartPath) throws IOException {
        String cartID = request.getParameter("cartID");

        if (cartID != null && !cartID.trim().isEmpty()) {
            CartFileHandler.removeFromCart(cartID, cartPath);
            System.out.println("Removed cart item: " + cartID);
        }

        response.sendRedirect("/cart");
    }

    // Inner class for displaying cart items with book details
    public static class CartItemDisplay {
        private Cart cart;
        private Book book;
        private double subtotal;

        public CartItemDisplay(Cart cart, Book book, double subtotal) {
            this.cart = cart;
            this.book = book;
            this.subtotal = subtotal;
        }

        public Cart getCart() { return cart; }
        public Book getBook() { return book; }
        public double getSubtotal() { return subtotal; }
    }
}