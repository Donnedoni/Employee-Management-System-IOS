//
//  Model.swift
//  EmployeeManagementSystem
//
//  Created by DA MAC M1 150 on 2023/05/25.
//

import Foundation
struct Employee: Codable {
    let id: Int
    let firstName, lastName, email, contactNo: String
    
    enum CodingKeys: String, CodingKey {
        case id,firstName, lastName, email, contactNo
    }
}
