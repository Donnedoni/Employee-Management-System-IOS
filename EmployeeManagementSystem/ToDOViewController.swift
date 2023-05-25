
//
//  TableViewController.swift
//  EmployeeManagementSystem
//
//  Created by DA MAC M1 150 on 2023/05/25.
//

import UIKit

class ToDOViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    var  array = [Employee]()
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        array.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
    
}
