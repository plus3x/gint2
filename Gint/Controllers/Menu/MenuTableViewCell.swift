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
    
    func configure(with menuItem: MenuItem) {
        menuItemLabel.text = menuItem.name
        
        mark(as: menuItem.selected)
    }
    
    private func mark(as selected: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.menuItemLabel.alpha = selected ? 0.5 : 1
        }
    }
}
