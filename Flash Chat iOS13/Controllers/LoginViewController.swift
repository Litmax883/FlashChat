//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by MAC on 06.11.2020.
//  Copyright © 2020 Litmax. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        let email = emailTextfield.text
        let password = passwordTextfield.text
        
        if let email = email, let pass = password {
            
            Auth.auth().signIn(withEmail: email, password: pass) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    self.performSegue(withIdentifier: "LoginToChat", sender: self)
                }
                
            }
        }
    }
    
}
