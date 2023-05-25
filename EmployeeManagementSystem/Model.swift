//
//  Model.swift
//  EmployeeManagementSystem
//
//  Created by DA MAC M1 150 on 2023/05/25.
//

import Foundation

// MARK: - Todo
struct Employee: Codable {
    let id: Int
    let firstName, lastName, email, contactNo: String
}
