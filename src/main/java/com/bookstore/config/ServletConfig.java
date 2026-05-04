package com.bookstore.config;

import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@ServletComponentScan("com.bookstore.servlet")
public class ServletConfig {
}