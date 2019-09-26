//
//  MenuItem.swift
//  Gint
//
//  Created by Vladislav Petrov on 27/09/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import Foundation

struct MenuItem {
    let name: String
    let segue: String
    var selected = false
    
    init(name: String, segue: String) {
        self.name = name
        self.segue = segue
    }
}
