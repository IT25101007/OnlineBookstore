package com.bookstore.controller;

import com.bookstore.filehandler.AdminFileHandler;
import com.bookstore.filehandler.BookFileHandler;
import com.bookstore.filehandler.OrderFileHandler;
import com.bookstore.filehandler.PaymentFileHandler;
import com.bookstore.filehandler.UserFileHandler;
import com.bookstore.model.Admin;
import com.bookstore.model.User;
import com.bookstore.model.Order;
import com.bookstore.model.Payment;
import com.bookstore.model.Report;
import com.bookstore.util.IDGenerator;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.util.List;

@Controller
public class AdminController {

    private static final String DATA_FOLDER = "data/";

    private String getDataPath(String fileName) {
        String projectPath = System.getProperty("user.dir");
        return projectPath + "/" + DATA_FOLDER + fileName;
    }

    private boolean isAdmin(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole());
    }

    @GetMapping("/admin/dashboard")
    public String dashboard(HttpSession session, Model model) {
        System.out.println("=== Admin dashboard accessed ===");

        if (!isAdmin(session)) {
            System.out.println("User is not admin, redirecting to /books");
            return "redirect:/books";
        }

        String usersPath = getDataPath("users.txt");
        String booksPath = getDataPath("books.txt");
        String ordersPath = getDataPath("orders.txt");
        String paymentsPath = getDataPath("payments.txt");

        System.out.println("Users path: " + usersPath);
        System.out.println("Books path: " + booksPath);

        long totalUsers = AdminFileHandler.countAllUsers(usersPath);
        long totalBooks = BookFileHandler.getAllBooks(booksPath).size();
        long totalOrders = AdminFileHandler.countAllOrders(ordersPath);
        double totalRevenue = AdminFileHandler.sumAllRevenue(paymentsPath);

        System.out.println("Total Users: " + totalUsers);
        System.out.println("Total Books: " + totalBooks);
        System.out.println("Total Orders: " + totalOrders);
        System.out.println("Total Revenue: " + totalRevenue);

        model.addAttribute("totalUsers", totalUsers);
        model.addAttribute("totalBooks", totalBooks);
        model.addAttribute("totalOrders", totalOrders);
        model.addAttribute("totalRevenue", totalRevenue);  // ← Now passing as number, not formatted string

        return "adminDashboard";
    }

    @GetMapping("/admin/reports")
    public String reports(HttpSession session, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/books";
        }

        String usersPath = getDataPath("users.txt");
        String booksPath = getDataPath("books.txt");
        String ordersPath = getDataPath("orders.txt");
        String paymentsPath = getDataPath("payments.txt");

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

        User admin = (User) session.getAttribute("user");
        String reportID = IDGenerator.generateReportID();
        Report report = new Report(reportID, "SALES", LocalDate.now().toString(),
                admin.getUserID(), content.toString());

        model.addAttribute("reportData", report);
        model.addAttribute("recentOrders", orders.stream().limit(10).toArray());
        model.addAttribute("totalRevenue", totalRev);  // ← Pass as number
        model.addAttribute("pendingOrders", pendingOrders);
        model.addAttribute("completedPayments", completedPayments);

        return "reports";
    }

    @GetMapping("/admin/system")
    public String systemPanel(HttpSession session, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/books";
        }

        String adminsPath = getDataPath("admins.txt");
        List<Admin> admins = AdminFileHandler.getAllAdmins(adminsPath);
        model.addAttribute("admins", admins);
        return "systemPanel";
    }

    @GetMapping("/admin/register")
    public String showRegisterForm(HttpSession session) {
        if (!isAdmin(session)) {
            return "redirect:/books";
        }
        return "adminRegister";
    }

    @PostMapping("/admin/register")
    public String registerAdmin(@RequestParam String name,
                                @RequestParam String email,
                                @RequestParam String password,
                                @RequestParam String role,
                                HttpSession session) {
        if (!isAdmin(session)) {
            return "redirect:/books";
        }

        String adminsPath = getDataPath("admins.txt");
        String adminID = IDGenerator.generateAdminID();
        Admin newAdmin = new Admin(adminID, name, email, password, role);
        AdminFileHandler.addAdmin(newAdmin, adminsPath);

        return "redirect:/admin/system?success=true";
    }

    @PostMapping("/admin/system")
    public String deleteAdmin(@RequestParam String action,
                              @RequestParam String adminID,
                              HttpSession session) {
        if (!isAdmin(session)) {
            return "redirect:/books";
        }

        if ("delete".equals(action)) {
            String adminsPath = getDataPath("admins.txt");
            AdminFileHandler.deleteAdmin(adminID, adminsPath);
        }
        return "redirect:/admin/system";
    }
}