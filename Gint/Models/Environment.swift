//
//  Environment.swift
//  Gint
//
//  Created by Vladislav Petrov on 08/10/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import UIKit

struct Environment {
    struct GitHub {
        static var token: String? {
            get {
                return UserDefaults.standard.string(forKey: "UserToken")
            }
            
            set {
                UserDefaults.standard.set(newValue, forKey: "UserToken")
                UserDefaults.standard.synchronize()
            }
        }
    }
}
