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
  
  
  var errorMessage: String = ""
  let EXIST_USERNAME_ERROR = "Username is Existed!Please try again"
  // Check Create account successfully
  var isSuccessful: Bool = false
  // Save username and password for auto login after sign up successfully
  var username: String = ""
  var password: String = ""
  
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
  }
}

// Function
extension SignupViewController {
  func checkNotNil() -> Bool {
    if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty || confirmPassTextField.text!.isEmpty {
      errorMessage = "Bạn phải nhập tất cả các trường"
      return false
    } else if passwordTextField.text! != confirmPassTextField.text! {
      errorMessage = "Nhập lại mật khẩu phải giống với mật khẩu"
      return false
    }
    else {
      return true
    }
  }
  
}

// IBAction
extension SignupViewController {
  @IBAction func didTouchButtonBack(_ sender: Any) {
    isSuccessful = false
    performSegue(withIdentifier: "unwindToLogin", sender: self)
  }
  
  @IBAction func didTouchSignUpButton(_ sender: Any) {
    if checkNotNil() {
      NetworkingService.sharedInstance.signUp(username: usernameTextField.text!, password: passwordTextField.text!) {
        [unowned self] (message, error) in
        if error != nil {
          print(error!)
          self.alertError(message: "Đăng ký thất bại")
        } else {
          if message != self.EXIST_USERNAME_ERROR {
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
              self.isSuccessful = true
              // Save username and password in textfield
              self.username = self.usernameTextField.text!
              self.password = self.passwordTextField.text!
              // Go to Login
              self.performSegue(withIdentifier: "unwindToLogin", sender: self)
            })
            self.alertWithAction(message: "Đăng ký thành công", action: ok)
          } else {
            self.alertError(message: "Tên đăng nhập đã tồn tại")
          }
        }
      }
    } else {
      alertError(message: errorMessage)
    }
  }
}

