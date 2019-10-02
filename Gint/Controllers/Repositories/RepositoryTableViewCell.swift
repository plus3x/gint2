//
//  RepositoryTableViewCell.swift
//  Gint
//
//  Created by Vladislav Petrov on 02/10/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
    static let identifier = "ReposytoryTableViewCellIdentifier"
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var repository: Repository?
    
    func configure(with repository: Repository) {
        self.repository = repository
        
        nameLabel.text = repository.name
    }
}
