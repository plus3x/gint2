//
//  LoginViewController.swift
//  Gint
//
//  Created by Vladislav Petrov on 27/09/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import UIKit

protocol LoginShowHideProtocol {
    func showLogin()
    func hideLogin()
}

class LoginViewController: UIViewController {
    @IBOutlet weak var tokenField: UITextField!
    
    weak var delegate: AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tokenField.delegate = self
    }
    
    @IBAction func onSignInTap(_ sender: Any) {
        singIn()
    }
    
    private func singIn() {
        if let token = tokenField.text {
            GitHubService.token = token
            delegate!.hideLogin()
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        singIn()
        
        return true
    }
}
