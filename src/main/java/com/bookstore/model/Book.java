package com.bookstore.model;

public abstract class Book {
    // Encapsulated fields
    private String bookID;
    private String title;
    private String author;
    private String category;
    private double price;
    private int stock;
    private String type; // "EBOOK" or "PRINTED"

    // No-args constructor
    public Book() {
    }

    // Full constructor
    public Book(String bookID, String title, String author, String category, double price, int stock, String type) {
        this.bookID = bookID;
        this.title = title;
        this.author = author;
        this.category = category;
        this.price = price;
        this.stock = stock;
        this.type = type;
    }

    // Getters and Setters
    public String getBookID() {
        return bookID;
    }

    public void setBookID(String bookID) {
        this.bookID = bookID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    // Abstract method - polymorphism
    public abstract String displayFormat();

    // Concrete method to convert to file string
    public String toFileString() {
        return bookID + " | " + title + " | " + author + " | " + category + " | " + price + " | " + stock + " | " + type;
    }

    // Static factory method to parse and create appropriate subclass
    public static Book fromFileString(String line) {
        String[] parts = line.split(" \\| ");
        if (parts.length == 7) {
            String type = parts[6];
            if ("EBOOK".equalsIgnoreCase(type)) {
                return new EBook(parts[0], parts[1], parts[2], parts[3],
                        Double.parseDouble(parts[4]), Integer.parseInt(parts[5]), "");
            } else {
                return new PrintedBook(parts[0], parts[1], parts[2], parts[3],
                        Double.parseDouble(parts[4]), Integer.parseInt(parts[5]), 0);
            }
        }
        return null;
    }
    @Override
    public String toString() {
        return "Book{" +
                "bookID='" + bookID + '\'' +
                ", title='" + title + '\'' +
                ", author='" + author + '\'' +
                ", price=" + price +
                ", stock=" + stock +
                ", type='" + type + '\'' +
                '}';
    }

}