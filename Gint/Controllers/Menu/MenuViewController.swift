//
//  MasterViewController.swift
//  Gint
//
//  Created by Vladislav Petrov on 27/09/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {
    let menuItems = [
        MenuItem(name: "Repositories", segue: "ShowRepositories"),
    ]
    var selectedMenuItem: MenuItem?
}

extension MasterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath) as! MenuTableViewCell
        
        var menuItem = menuItems[indexPath.row]
        menuItem.selected = selectedMenuItem == menuItem
        cell.configure(with: menuItem)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItem = menuItems[indexPath.row]
        
        performSegue(withIdentifier: menuItem.segue, sender: self)
        
        selectedMenuItem = menuItem
        tableView.reloadData()
    }
}
