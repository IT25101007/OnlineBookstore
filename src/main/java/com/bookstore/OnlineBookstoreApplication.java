package com.bookstore;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan(basePackages = {"com.bookstore.controller", "com.bookstore.filehandler", "com.bookstore.model", "com.bookstore.util"})
public class OnlineBookstoreApplication {

    public static void main(String[] args) {
        SpringApplication.run(OnlineBookstoreApplication.class, args);
        System.out.println("========================================");
        System.out.println("Online Bookstore is running!");
        System.out.println("Access at: http://localhost:8082");
        System.out.println("========================================");
    }
}