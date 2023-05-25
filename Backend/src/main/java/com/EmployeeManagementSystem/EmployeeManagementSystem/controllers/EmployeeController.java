package com.EmployeeManagementSystem.EmployeeManagementSystem.controllers;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.lang.NonNull;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.EmployeeManagementSystem.EmployeeManagementSystem.exceptions.ResourceNotFoundException;
import com.EmployeeManagementSystem.EmployeeManagementSystem.models.Employee;
import com.EmployeeManagementSystem.EmployeeManagementSystem.repo.EmployeeRepo;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;


@CrossOrigin
@RestController
@RequestMapping("/employees")
public class EmployeeController {
    @Autowired 
    private EmployeeRepo employeeRepo;
    
    @GetMapping("/getEmployees")
    public List<Employee>getEmployees(){
        return employeeRepo.findAll();
    }

    @PostMapping
    public Employee save(@Validated @NonNull @RequestBody Employee employee){
        return employeeRepo.save(employee);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Employee> getEmployeebyId(@PathVariable int id)
    {
        Employee employee = employeeRepo.
        findById(id).orElseThrow(() -> new ResourceNotFoundException("Employee not found" + id));
        return ResponseEntity.ok(employee);
    }

    @PutMapping("{id}")
    public ResponseEntity<Employee> update(@PathVariable int id,@RequestBody Employee employee) {
        Employee update = employeeRepo.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Employee not exist with id: " + id));

        update.setFirstName(employee.getFirstName());
        update.setLastName(employee.getLastName());
        update.setEmail(employee.getEmail());
        update.setContactNo(employee.getContactNo());

        employeeRepo.save(update);

        return ResponseEntity.ok(update);
    }

    @DeleteMapping("/{id}")
	public ResponseEntity<Map<String, Boolean>> deleteEmployee(@PathVariable int id){
		Employee employee = employeeRepo.findById(id)
				.orElseThrow(() -> new ResourceNotFoundException("Employee not exist with id :" + id));
		
		employeeRepo.delete(employee);
		Map<String, Boolean> response = new HashMap<>();
		response.put("deleted", Boolean.TRUE);
		return ResponseEntity.ok(response);
	}

}
    


