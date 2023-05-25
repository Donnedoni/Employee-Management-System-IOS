
//
//  TableViewCell.swift
//  EmployeeManagementSystem
//
//  Created by DA MAC M1 150 on 2023/05/25.
//

import UIKit

class ToDOTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
  
    @IBOutlet weak var lastNameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var contactNoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

