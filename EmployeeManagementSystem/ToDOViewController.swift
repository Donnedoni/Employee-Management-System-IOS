
//
//  TableViewController.swift
//  EmployeeManagementSystem
//
//  Created by DA MAC M1 150 on 2023/05/25.
//

import UIKit

class ToDOViewController: UIViewController,AddViewControllerDelegate {

    func didAddEmployee() {
        
        tableView.reloadData()
    }
    
    func presentAddViewController() {
        let addViewController = AddViewController()
        addViewController.delegate = self
        present(addViewController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    var  array = [Employee]()
    var del = false
    @Published var isDeleted = false
  
    var Delete : Int = 0
    override func viewDidLoad() {
        
        super.viewDidLoad()
     

        fetchApiData(URL: "http://localhost:8080/employees/getEmployees"){ result in
            self.array = result
           
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchApiData(URL  url: String, completion: @escaping([Employee]) -> Void ){
        
        let url = URL(string: url)
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!) { data, response, error in
            if data != nil, error == nil {
                
                do{
                    let parsingData = try JSONDecoder().decode([Employee].self, from: data!)
                    completion(parsingData)
                }catch{
                    print("parsing error")
                }
            }
        }
        dataTask.resume()
    }
}


    

extension ToDOViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return array.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDOViewController", for: indexPath) as? ToDOTableViewCell else {return UITableViewCell()}
        
        cell.nameLabel.text = array[indexPath.row].firstName
        cell.lastNameLabel.text = array[indexPath.row].lastName
        cell.emailLabel.text = array[indexPath.row].email
        cell.contactNoLabel.text = array[indexPath.row].contactNo
        Delete = Int(array[indexPath.row].id)
        return cell
    }
     

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
        let id = array[indexPath.row].id
        deleteEmployee(id: id, at: indexPath)
    }

    }
    
    func deleteEmployee(id: Int, at indexPath: IndexPath) {
           let urlString = "http://localhost:8080/employees/deleteEmployee/\(id)"

           guard let url = URL(string: urlString) else {
               print("Invalid URL")
               return
           }

           var request = URLRequest(url: url)
           request.httpMethod = "DELETE"

           let session = URLSession.shared

           let task = session.dataTask(with: request) { [weak self] (data, response, error) in
               if let error = error {
                   print("Error: \(error.localizedDescription)")
                   return
               }

               if let httpResponse = response as? HTTPURLResponse {
                   if httpResponse.statusCode == 200 {
                       print("Employee deleted successfully")

                       DispatchQueue.main.async {
                           self?.array.remove(at: indexPath.row)
                           self?.tableView.deleteRows(at: [indexPath], with: .fade)
                       }
                   } else {
                       print("Error: \(httpResponse.statusCode)")
                   }
               }
           }

           task.resume()
       }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController

                vc?.idTxt = array[indexPath.row].id
                vc?.fNameTxt = array[indexPath.row].firstName
                vc?.lNameTxt = array[indexPath.row].lastName
                vc?.mailTxt = array[indexPath.row].email
                vc?.contactTxt = array[indexPath.row].contactNo

                self.navigationController?.pushViewController(vc!, animated: true)
    }
   }


