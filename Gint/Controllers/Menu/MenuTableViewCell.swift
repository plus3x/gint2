//
//  MenuTableViewCell.swift
//  Gint
//
//  Created by Vladislav Petrov on 27/09/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    static let identifier = "MenuTableViewCellIdentifier"
    
    @IBOutlet weak var menuItemLabel: UILabel!
    
    var menuItem: MenuItem!
    
    func configure(with menuItem: MenuItem) {
        self.menuItem = menuItem
        
        menuItemLabel.text = menuItem.name
        
        if menuItem.selected {
            markAsSelected()
        } else {
            markAsDeselected()
        }
    }
    
    private func markAsSelected() {
        menuItemLabel.textColor = .orange
    }
    
    private func markAsDeselected() {
        menuItemLabel.textColor = .white
    }
}