//
//  LoginChecker.swift
//  Gint
//
//  Created by Vladislav Petrov on 08/10/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import UIKit

class LoginChecker {
    let window: UIWindow?
    
    private var loggedIn: Bool { return Environment.GitHub.token != nil }
    
    required init(window: UIWindow?) {
        self.window = window
    }
    
    func checkLoggedIn() {
        guard !loggedIn else { return }
        
        showLogin()
    }
}

extension LoginChecker: LoginShowHideProtocol {
    func showLogin() {
        guard let window = window,
              let loginViewController = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController() as? LoginViewController else {
            return
        }
        
        loginViewController.delegate = self
        window.makeKeyAndVisible()
        window.rootViewController?.present(loginViewController, animated: false, completion: nil)
    }
    
    func hideLogin() {
        guard let window = window else { return }
        
        window.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
