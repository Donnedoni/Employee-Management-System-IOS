package com.EmployeeManagementSystem.EmployeeManagementSystem.repo;

import org.springframework.data.jpa.repository.JpaRepository;

import com.EmployeeManagementSystem.EmployeeManagementSystem.models.Employee;
public interface EmployeeRepo extends JpaRepository<Employee, Integer> {
    
}
