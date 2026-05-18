package com.bookstore.servlet_backup;

import com.bookstore.filehandler.BookFileHandler;
import com.bookstore.model.Book;
import com.bookstore.model.EBook;
import com.bookstore.model.PrintedBook;
import com.bookstore.model.User;
import com.bookstore.util.IDGenerator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/books", "/book/add", "/book/edit", "/book/delete", "/book/detail"})
public class BookServlet extends HttpServlet {

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

    private boolean checkLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        String booksPath = getDataPath("books.txt", request);

        switch (path) {
            case "/books":
                String search = request.getParameter("search");
                List<Book> books;
                if (search != null && !search.trim().isEmpty()) {
                    books = BookFileHandler.searchBooks(search, booksPath);
                    request.setAttribute("searchKeyword", search);
                } else {
                    books = BookFileHandler.getAllBooks(booksPath);
                }
                request.setAttribute("books", books);
                request.getRequestDispatcher("/WEB-INF/views/bookList.jsp").forward(request, response);
                break;

            case "/book/detail":
                String bookID = request.getParameter("bookID");
                if (bookID != null) {
                    Book book = BookFileHandler.getBookByID(bookID, booksPath);
                    request.setAttribute("book", book);
                }
                request.getRequestDispatcher("/WEB-INF/views/bookDetail.jsp").forward(request, response);
                break;

            case "/book/add":
                if (!isAdmin(request)) {
                    response.sendRedirect("/books");
                    return;
                }
                request.setAttribute("action", "add");
                request.getRequestDispatcher("/WEB-INF/views/addEditBook.jsp").forward(request, response);
                break;

            case "/book/edit":
                if (!isAdmin(request)) {
                    response.sendRedirect("/books");
                    return;
                }
                String editBookID = request.getParameter("bookID");
                Book editBook = BookFileHandler.getBookByID(editBookID, booksPath);
                request.setAttribute("action", "edit");
                request.setAttribute("book", editBook);
                request.getRequestDispatcher("/WEB-INF/views/addEditBook.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect("/books");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String path = request.getServletPath();
        String booksPath = getDataPath("books.txt", request);

        switch (path) {
            case "/book/add":
                if (!isAdmin(request)) {
                    response.sendRedirect("/books");
                    return;
                }
                handleAddBook(request, booksPath);
                response.sendRedirect("/books?success=added");
                break;

            case "/book/edit":
                if (!isAdmin(request)) {
                    response.sendRedirect("/books");
                    return;
                }
                handleEditBook(request, booksPath);
                response.sendRedirect("/books?success=updated");
                break;

            case "/book/delete":
                if (!isAdmin(request)) {
                    response.sendRedirect("/books");
                    return;
                }
                String bookID = request.getParameter("bookID");
                if (bookID != null) {
                    BookFileHandler.deleteBook(bookID, booksPath);
                }
                response.sendRedirect("/books?success=deleted");
                break;

            default:
                response.sendRedirect("/books");
        }
    }

    private void handleAddBook(HttpServletRequest request, String booksPath) {
        try {
            String title = request.getParameter("title");
            String author = request.getParameter("author");
            String category = request.getParameter("category");
            String priceStr = request.getParameter("price");
            String stockStr = request.getParameter("stock");
            String type = request.getParameter("type");

            // Validate required fields
            if (title == null || title.trim().isEmpty() ||
                    author == null || author.trim().isEmpty() ||
                    priceStr == null || priceStr.trim().isEmpty() ||
                    stockStr == null || stockStr.trim().isEmpty()) {
                System.err.println("Missing required fields for book");
                return;
            }

            double price = Double.parseDouble(priceStr);
            int stock = Integer.parseInt(stockStr);
            String bookID = IDGenerator.generateBookID();

            Book newBook;
            if ("EBOOK".equals(type)) {
                String downloadURL = request.getParameter("downloadURL");
                if (downloadURL == null) downloadURL = "";
                newBook = new EBook(bookID, title, author, category, price, stock, downloadURL);
            } else {
                String pageCountStr = request.getParameter("pageCount");
                int pageCount = 0;
                if (pageCountStr != null && !pageCountStr.trim().isEmpty()) {
                    pageCount = Integer.parseInt(pageCountStr);
                }
                newBook = new PrintedBook(bookID, title, author, category, price, stock, pageCount);
            }

            boolean success = BookFileHandler.addBook(newBook, booksPath);
            if (success) {
                System.out.println("Book added successfully: " + title);
            } else {
                System.err.println("Failed to add book: " + title);
            }
        } catch (NumberFormatException e) {
            System.err.println("Number format error in handleAddBook: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error adding book: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void handleEditBook(HttpServletRequest request, String booksPath) {
        try {
            String bookID = request.getParameter("bookID");
            String title = request.getParameter("title");
            String author = request.getParameter("author");
            String category = request.getParameter("category");
            double price = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            String type = request.getParameter("type");

            if ("EBOOK".equals(type)) {
                String downloadURL = request.getParameter("downloadURL");
                EBook ebook = new EBook(bookID, title, author, category, price, stock, downloadURL);
                BookFileHandler.updateBook(ebook, booksPath);
            } else {
                int pageCount = Integer.parseInt(request.getParameter("pageCount"));
                PrintedBook printedBook = new PrintedBook(bookID, title, author, category, price, stock, pageCount);
                BookFileHandler.updateBook(printedBook, booksPath);
            }
        } catch (Exception e) {
            System.err.println("Error editing book: " + e.getMessage());
        }
    }
}