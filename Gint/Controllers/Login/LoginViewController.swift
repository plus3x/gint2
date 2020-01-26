//
//  LoginViewController.swift
//  Gint
//
//  Created by Vladislav Petrov on 27/09/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import UIKit

protocol LoginShowHideProtocol: class {
    func showLogin()
    func hideLogin()
}

class LoginViewController: UIViewController {
    @IBOutlet weak var tokenField: UITextField!

    weak var delegate: LoginShowHideProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tokenField.delegate = self
        
        observe(UIResponder.keyboardWillShowNotification, by: #selector(keyboardWillShow(_:)))
        observe(UIResponder.keyboardWillHideNotification, by: #selector(keyboardWillHide(_:)))
    }
    
    @IBAction func onSignInTap(_ sender: Any) {
        singIn()
    }
    
    private func observe(_ name: NSNotification.Name, by selector: Selector, sender: Any? = nil) {
        NotificationCenter.default.addObserver(
            self,
            selector: selector,
            name: name,
            object: nil
        )
    }
    
    private func singIn() {
        guard let token = tokenField.text else { return }
        guard let delegate = delegate else {
            fatalError("Login view can't show preveous screen becouse 'delegate' are empty!")
        }
        
        Environment.GitHub.token = token
        
        delegate.hideLogin()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardFrame = keyboardSize.cgRectValue
        if view.frame.origin.y == 0 {
            view.frame.origin.y -= keyboardFrame.height
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardFrame = keyboardSize.cgRectValue
        if view.frame.origin.y != 0 {
            view.frame.origin.y += keyboardFrame.height
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        singIn()
        
        return true
    }
}
