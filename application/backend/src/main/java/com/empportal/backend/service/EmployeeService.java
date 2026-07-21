package com.empportal.backend.service;

import com.empportal.backend.entity.Employee;
import com.empportal.backend.exception.ResourceNotFoundException;
import com.empportal.backend.repository.EmployeeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmployeeService {

    @Autowired
    private EmployeeRepository employeeRepository;

    public List<Employee> findAll() {
        return employeeRepository.findAll();
    }

    public Employee findById(Long id) {
        return employeeRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Employee not found with id: " + id));
    }

    public Employee save(Employee employee) {
        return employeeRepository.save(employee);
    }

    public Employee update(Long id, Employee updated) {
        Employee existing = findById(id);
        existing.setFirstName(updated.getFirstName());
        existing.setLastName(updated.getLastName());
        existing.setEmail(updated.getEmail());
        existing.setDepartment(updated.getDepartment());
        existing.setDesignation(updated.getDesignation());
        existing.setSalary(updated.getSalary());
        return employeeRepository.save(existing);
    }

    public void delete(Long id) {
        Employee existing = findById(id);
        employeeRepository.delete(existing);
    }

    public List<Employee> search(String query) {
        if (query == null || query.isBlank()) {
            return findAll();
        }
        return employeeRepository
                .findByFirstNameContainingIgnoreCaseOrLastNameContainingIgnoreCaseOrDepartmentContainingIgnoreCase(
                        query, query, query);
    }
}
