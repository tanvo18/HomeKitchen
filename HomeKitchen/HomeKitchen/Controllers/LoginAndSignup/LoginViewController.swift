//
//  LoginViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/3/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  // MARK: IBOutlet
  @IBOutlet weak var usernameTextfield: UITextField!
  
  @IBOutlet weak var passwordTextfield: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTextfield()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}

//MARK: Setting for UITextField
extension LoginViewController {
  func setupTextfield() {
    let paddingViewUser = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: self.usernameTextfield.frame.height))
    usernameTextfield.leftView = paddingViewUser
    usernameTextfield.leftViewMode = UITextFieldViewMode.always
    let paddingViewPassword = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: self.passwordTextfield.frame.height))
    passwordTextfield.leftView = paddingViewPassword
    passwordTextfield.leftViewMode = UITextFieldViewMode.always
  }
}
