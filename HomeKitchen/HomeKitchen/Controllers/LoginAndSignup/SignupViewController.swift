//
//  SignupViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/3/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
  
  // MARK: IBOutlet
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var confirmPassTextField: UITextField!
  @IBOutlet weak var phoneTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTextfield()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}

// MARK: Setting for UITextField
extension SignupViewController {
  func setupTextfield() {
    let paddingViewUser = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: self.usernameTextField.frame.height))
    usernameTextField.leftView = paddingViewUser
    usernameTextField.leftViewMode = UITextFieldViewMode.always
    
    let paddingViewPass = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: self.passwordTextField.frame.height))
    passwordTextField.leftView = paddingViewPass
    passwordTextField.leftViewMode = UITextFieldViewMode.always
    
    let paddingViewConfirmPass = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: self.confirmPassTextField.frame.height))
    confirmPassTextField.leftView = paddingViewConfirmPass
    confirmPassTextField.leftViewMode = UITextFieldViewMode.always
    
    let paddingViewUserPhone = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: self.phoneTextField.frame.height))
    phoneTextField.leftView = paddingViewUserPhone
    phoneTextField.leftViewMode = UITextFieldViewMode.always
  }
}

