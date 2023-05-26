//
//  AddViewController.swift
//  EmployeeManagementSystem
//
//  Created by DA MAC M1 150 on 2023/05/25.
//

import UIKit

protocol AddViewControllerDelegate: AnyObject {
    func didAddEmployee()
}

class AddViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var contact: UITextField!
    
    weak var delegate: AddViewControllerDelegate?

  
    //        var validateName = validName(entered: firstName.text!)
    //        var validateSurname = validName(entered: lastName.text!)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    @IBAction func Add(_ sender: Any) {
        
        guard let firstName = name.text, !firstName.isEmpty else {
                    showAlert(message: "Please enter a valid first name.")
                    return
                }
                
                guard let lastName = lastName.text, !lastName.isEmpty else {
                    showAlert(message: "Please enter a valid last name.")
                    return
                }
                
                guard let email = email.text, !email.isEmpty else {
                    showAlert(message: "Please enter a valid email address.")
                    return
                }
                
        if !isValidEmail(email) {
                   showAlert(message: "Please enter a valid email address.")
                   return
               }
               
               guard let contactNo = contact.text, !contactNo.isEmpty else {
                   showAlert(message: "Please enter a valid contact number.")
                   return
               }
               
               if !isValidContactNumber(contactNo) {
                   showAlert(message: "Please enter a valid 10-digit contact number.")
                   return
               }
               
        
        let newEmp: Employee = Employee(id: 0, firstName: firstName, lastName: lastName, email: email, contactNo: contactNo)
        addEmployeeToDatabase(employee: newEmp)
        showAlertSuccess(message: "Employee added")
        delegate?.didAddEmployee()
        // Navigate back to the controller with the table view
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ToDOViewController") as? ToDOViewController
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }
        
        func isValidContactNumber(_ contactNumber: String) -> Bool {
            let contactNumberRegex = "\\d{10}"
            let contactNumberPredicate = NSPredicate(format: "SELF MATCHES %@", contactNumberRegex)
            return contactNumberPredicate.evaluate(with: contactNumber)
        }
    
    
   
 
    func addEmployeeToDatabase(employee: Employee) {
        let urlString = "http://localhost:8080/employees/addEmployee"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let employeeData: [String: Any] = [
            "firstName": employee.firstName,
            "lastName": employee.lastName,
            "email": employee.email,
            "contactNo": employee.contactNo
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: employeeData, options: [])

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            let session = URLSession.shared

            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: (error.localizedDescription)")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        print("Employee added successfully")

                        // Perform any additional actions or UI updates if needed

                    } else {
                        print("Error: (httpResponse.statusCode)")
                    }
                }
            }

            task.resume()

        } catch {
            print("Error: Failed to serialize employee data")
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertSuccess(message: String) {
        let alert = UIAlertController(title: "Succesfull", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}


