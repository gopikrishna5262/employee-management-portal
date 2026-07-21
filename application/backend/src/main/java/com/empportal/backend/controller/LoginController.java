package com.empportal.backend.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

// NOTE: This is a simple placeholder login, matching the assessment's
// "simple authentication" requirement. It does NOT verify credentials
// against a user store or hash passwords — any username/password combo
// is accepted and redirected to the employee list. This is fine for a
// learning/demo project, but should be replaced with Spring Security
// (form login + a real Users table with hashed passwords) before this
// is treated as a real, secured application.
@Controller
public class LoginController {

    @GetMapping("/")
    public String root() {
        return "redirect:/login";
    }

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    @PostMapping("/login")
    public String doLogin(@RequestParam String username, @RequestParam String password) {
        return "redirect:/employees";
    }
}
