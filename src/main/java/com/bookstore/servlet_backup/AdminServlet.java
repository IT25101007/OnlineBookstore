package com.bookstore.servlet_backup;

import com.bookstore.filehandler.AdminFileHandler;
import com.bookstore.filehandler.UserFileHandler;
import com.bookstore.filehandler.BookFileHandler;
import com.bookstore.filehandler.OrderFileHandler;
import com.bookstore.filehandler.PaymentFileHandler;
import com.bookstore.model.Admin;
import com.bookstore.model.User;
import com.bookstore.model.Order;
import com.bookstore.model.Payment;
import com.bookstore.model.Report;
import com.bookstore.util.IDGenerator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet(urlPatterns = {"/admin", "/admin/dashboard", "/admin/reports", "/admin/system", "/admin/register"})
public class AdminServlet extends HttpServlet {

    private static final String DATA_FOLDER = "data/";

    private String getDataPath(String fileName, HttpServletRequest request) {
        String realPath = request.getServletContext().getRealPath("/");
        if (realPath == null || realPath.isEmpty()) {
            String projectPath = System.getProperty("user.dir");
            return projectPath + "/" + DATA_FOLDER + fileName;
        }
        return realPath + "../../" + DATA_FOLDER + fileName;
    }

    private boolean isAdmin(HttpServletRequest request) {
        User user = (User) request.getSession().getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole());
    }

    private boolean checkAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/books");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAdmin(request, response)) return;

        String path = request.getServletPath();
        String usersPath = getDataPath("users.txt", request);
        String booksPath = getDataPath("books.txt", request);
        String ordersPath = getDataPath("orders.txt", request);
        String paymentsPath = getDataPath("payments.txt", request);
        String adminsPath = getDataPath("admins.txt", request);

        switch (path) {
            case "/admin":
            case "/admin/dashboard":
                long totalUsers = AdminFileHandler.countAllUsers(usersPath);
                long totalBooks = BookFileHandler.getAllBooks(booksPath).size();
                long totalOrders = AdminFileHandler.countAllOrders(ordersPath);
                double totalRevenue = AdminFileHandler.sumAllRevenue(paymentsPath);

                request.setAttribute("totalUsers", totalUsers);
                request.setAttribute("totalBooks", totalBooks);
                request.setAttribute("totalOrders", totalOrders);
                request.setAttribute("totalRevenue", String.format("%.2f", totalRevenue));
                request.getRequestDispatcher("/WEB-INF/views/adminDashboard.jsp").forward(request, response);
                break;

            case "/admin/reports":
                List<User> users = UserFileHandler.getAllUsers(usersPath);
                List<Order> orders = OrderFileHandler.getAllOrders(ordersPath);
                List<Payment> payments = PaymentFileHandler.getAllPayments(paymentsPath);

                long totalBooksCount = BookFileHandler.getAllBooks(booksPath).size();
                long totalUsersCount = users.size();
                long totalOrdersCount = orders.size();
                double totalRev = 0.0;
                long completedPayments = 0;

                for (Payment payment : payments) {
                    if ("COMPLETED".equalsIgnoreCase(payment.getStatus())) {
                        totalRev += payment.getAmount();
                        completedPayments++;
                    }
                }

                long pendingOrders = orders.stream()
                        .filter(o -> "PENDING".equalsIgnoreCase(o.getStatus()))
                        .count();

                StringBuilder content = new StringBuilder();
                content.append("SYSTEM SUMMARY REPORT\n");
                content.append("=====================\n\n");
                content.append("Total Users: ").append(totalUsersCount).append("\n");
                content.append("Total Books: ").append(totalBooksCount).append("\n");
                content.append("Total Orders: ").append(totalOrdersCount).append("\n");
                content.append("Pending Orders: ").append(pendingOrders).append("\n");
                content.append("Completed Payments: ").append(completedPayments).append("\n");
                content.append("Total Revenue: $").append(String.format("%.2f", totalRev)).append("\n");

                User admin = (User) request.getSession().getAttribute("user");
                String reportID = IDGenerator.generateReportID();
                Report report = new Report(reportID, "SALES", LocalDate.now().toString(),
                        admin.getUserID(), content.toString());

                request.setAttribute("reportData", report);
                request.setAttribute("recentOrders", orders.stream().limit(10).toArray());
                request.setAttribute("totalRevenue", String.format("%.2f", totalRev));
                request.setAttribute("pendingOrders", pendingOrders);
                request.setAttribute("completedPayments", completedPayments);
                request.getRequestDispatcher("/WEB-INF/views/reports.jsp").forward(request, response);
                break;

            case "/admin/system":
                List<Admin> admins = AdminFileHandler.getAllAdmins(adminsPath);
                request.setAttribute("admins", admins);
                request.getRequestDispatcher("/WEB-INF/views/systemPanel.jsp").forward(request, response);
                break;

            case "/admin/register":
                request.getRequestDispatcher("/WEB-INF/views/adminRegister.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect("/admin/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (!checkAdmin(request, response)) return;

        String path = request.getServletPath();
        String adminsPath = getDataPath("admins.txt", request);

        switch (path) {
            case "/admin/register":
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String role = request.getParameter("role");

                if (role == null || role.trim().isEmpty()) {
                    role = "REGULAR";
                }

                String newAdminID = IDGenerator.generateAdminID();  // Changed variable name
                Admin newAdmin = new Admin(newAdminID, name, email, password, role);

                boolean success = AdminFileHandler.addAdmin(newAdmin, adminsPath);

                if (success) {
                    response.sendRedirect("/admin/system?success=true");
                } else {
                    response.sendRedirect("/admin/register?error=true");
                }
                break;

            case "/admin/system":
                String action = request.getParameter("action");
                if ("delete".equals(action)) {
                    String deleteAdminID = request.getParameter("adminID");  // Changed variable name
                    if (deleteAdminID != null) {
                        AdminFileHandler.deleteAdmin(deleteAdminID, adminsPath);
                    }
                }
                response.sendRedirect("/admin/system");
                break;

            default:
                response.sendRedirect("/admin/dashboard");
        }
    }
}