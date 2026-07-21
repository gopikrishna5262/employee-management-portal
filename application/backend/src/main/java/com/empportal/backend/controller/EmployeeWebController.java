package com.empportal.backend.controller;

import com.empportal.backend.entity.Employee;
import com.empportal.backend.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

// Serves the Thymeleaf HTML pages (login.html, employees.html, employee-form.html).
// Separate from EmployeeController (the JSON REST API) — same underlying
// EmployeeService, two different "front doors" into the same data.
@Controller
@RequestMapping("/employees")
public class EmployeeWebController {

    @Autowired
    private EmployeeService employeeService;

    @GetMapping
    public String listEmployees(@RequestParam(required = false) String search, Model model) {
        model.addAttribute("employees", employeeService.search(search));
        return "employees";
    }

    @GetMapping("/new")
    public String newEmployeeForm(Model model) {
        model.addAttribute("employee", new Employee());
        return "employee-form";
    }

    @GetMapping("/edit/{id}")
    public String editEmployeeForm(@PathVariable Long id, Model model) {
        model.addAttribute("employee", employeeService.findById(id));
        return "employee-form";
    }

    @PostMapping("/save")
    public String saveEmployee(@ModelAttribute Employee employee) {
        if (employee.getId() == null) {
            employeeService.save(employee);
        } else {
            employeeService.update(employee.getId(), employee);
        }
        return "redirect:/employees";
    }

    // Backs the fetch()-based delete button in employees.html
    @DeleteMapping("/{id}")
    @ResponseBody
    public ResponseEntity<Void> deleteEmployee(@PathVariable Long id) {
        employeeService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
