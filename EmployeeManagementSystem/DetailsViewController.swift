//
//  DetailsViewController.swift
//  EmployeeManagementSystem
//
//  Created by DA MAC M1 150 on 2023/05/26.
//

import UIKit

class DetailsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var contactNumberTxt: UITextField!
    
    @Published var idTxt: Int?
        var fNameTxt: String?
        var lNameTxt: String?
        var mailTxt: String?
        var contactTxt: String?
    
    @IBOutlet weak var editBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTxt.text = fNameTxt
        lastNameTxt.text = lNameTxt
        emailTxt.text = mailTxt
        contactNumberTxt.text = contactTxt

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func editBtn(_ sender: Any) {
        guard let firstName = firstNameTxt.text, !firstName.isEmpty else {
                    showAlert(message: "Please enter a valid first name.")
                    return
                }
                
                guard let lastName = lastNameTxt.text, !lastName.isEmpty else {
                    showAlert(message: "Please enter a valid last name.")
                    return
                }
                
                guard let email = emailTxt.text, !email.isEmpty else {
                    showAlert(message: "Please enter a valid email address.")
                    return
                }
                
        if !isValidEmail(email) {
                   showAlert(message: "Please enter a valid email address.")
                   return
               }
               
               guard let contactNo = contactNumberTxt.text, !contactNo.isEmpty else {
                   showAlert(message: "Please enter a valid contact number.")
                   return
               }
               
               if !isValidContactNumber(contactNo) {
                   showAlert(message: "Please enter a valid 10-digit contact number.")
                   return
               }
               
        let newEmp: Employee = Employee(id: Int(0), firstName: String(firstNameTxt.text ?? "value"), lastName: String(lastNameTxt.text ?? "value"), email: String(emailTxt.text ?? "value"), contactNo: String(contactNumberTxt.text ?? "value"))

                update(Id: idTxt!, employee: newEmp)
        showAlertSuccess(message: "Employee edited")
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
    
    func update(Id:Int, employee:Employee) {

                var request = URLRequest(url:URL(string: "http://localhost:8080/employees/\(Id)")!)
                print("url request to update (request)")
                request.httpMethod  = "PUT"
                //HTTP Headers
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                let parameters: [String: Any] = [
                    "firstName" : employee.firstName,
                    "lastName": employee.lastName,
                    "email": employee.email,
                    "contactNo": employee.contactNo,
                ]
                // covert dictionary to json
                let jsonData = try? JSONSerialization.data(withJSONObject: parameters)

                request.httpBody =  jsonData

                let session = URLSession(configuration: .default)
                session.dataTask(with: request){(data,res,err) in
                    if err != nil {
                        print(err!.localizedDescription)
                        return
                    }
                    if err == nil,let response = res as? HTTPURLResponse {
                        if response.statusCode == 200
                        {
                            DispatchQueue.main.async {

                            }
                        }
                    }
                    guard let response = data else {return}
                    let status = String(data:response,encoding: .utf8) ?? ""

                    print(status)

                }.resume()
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

