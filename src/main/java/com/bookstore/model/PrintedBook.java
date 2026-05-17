package com.bookstore.model;

public class PrintedBook extends Book {
    private int pageCount;

    public PrintedBook() {
        super();
        setType("PRINTED");
    }

    public PrintedBook(String bookID, String title, String author, String category, double price, int stock, int pageCount) {
        super(bookID, title, author, category, price, stock, "PRINTED");
        this.pageCount = pageCount;
    }

    public int getPageCount() {
        return pageCount;
    }

    public void setPageCount(int pageCount) {
        this.pageCount = pageCount;
    }

    // Polymorphism - implementing abstract method
    @Override
    public String displayFormat() {
        return "Printed Book: " + getTitle() + " by " + getAuthor() + " | Pages: " + pageCount;
    }

    @Override
    public String toString() {
        return "PrintedBook{" +
                "bookID='" + getBookID() + '\'' +
                ", title='" + getTitle() + '\'' +
                ", author='" + getAuthor() + '\'' +
                ", price=" + getPrice() +
                ", pageCount=" + pageCount +
                '}';
    }
}