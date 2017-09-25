//
//  LoginViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/3/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import Alamofire

class LoginViewController: UIViewController {
  
  // MARK: IBOutlet
  @IBOutlet weak var usernameTextfield: UITextField!
  @IBOutlet weak var passwordTextfield: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTextfield()
    self.hideKeyboardWhenTappedAround()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}

extension LoginViewController {
  // Setting padding for UITextField
  func setupTextfield() {
    let paddingViewUser = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: self.usernameTextfield.frame.height))
    usernameTextfield.leftView = paddingViewUser
    usernameTextfield.leftViewMode = UITextFieldViewMode.always
    let paddingViewPassword = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: self.passwordTextfield.frame.height))
    passwordTextfield.leftView = paddingViewPassword
    passwordTextfield.leftViewMode = UITextFieldViewMode.always
  }
  
  // Get Facebook user information
  func getUserInfo(completion: @escaping (_ : [String : Any]?, _ :Error?) -> Void) {
    let request = GraphRequest(graphPath: "me", parameters: ["fields":"id,email,name"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
    request.start { (response, result) in
      switch result {
      case .success(let value):
        completion(value.dictionaryValue,nil)
      case .failed(let error):
        completion(nil,error)
      }
    }
  }
  
  // Post Json to get Authorization, we have to use responseString to get header
  func getAuthorizationFromServer(username: String, password: String, facebookToken: String) {
    let parameters: Parameters = ["username" : username,
                                  "password" : password,
                                  "token" : facebookToken]
    Alamofire.request("http://ec2-34-201-3-13.compute-1.amazonaws.com:8081/login", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString { response in
      switch response.result {
      case .success:
        if let authorizationToken = response.response?.allHeaderFields["Authorization"] as? String {
          // Save accessToken to global variable
          Helper.accessToken = authorizationToken
          print("==authorization \(Helper.accessToken)")
          // Go to HomeScreen after get authorization
          self.performSegue(withIdentifier: "showHomeScreen", sender: self)
        }
      case .failure(let error):
        print(error)
      }
    }
  }
  
}

// MARK: IBAction
extension LoginViewController {
  @IBAction func didTouchFacebookButton(_ sender: Any) {
    let loginManager = LoginManager()
    loginManager.logIn([.publicProfile, .email], viewController: self) {
      result in
      switch result {
      case .failed(let error):
        print(error.localizedDescription)
      case .cancelled:
        print("user cancelled the login")
      case .success(_ , _, let userInfo):
        self.getUserInfo { info, error in
          if let info = info, let _ = info["name"] as? String, let email = info["email"] as? String, let id = info["id"] as? String{
            print("====facebookId: \(id)")
            NetworkingService.sharedInstance.getAuthorizationFromServer(username: email, password: "", facebookToken: userInfo.authenticationToken) { [unowned self] (accessToken, error) in
              if error != nil {
                print(error!)
              } else {
                // Save access token
                Helper.accessToken = accessToken!
                print("accessToken: \(Helper.accessToken)")
                self.performSegue(withIdentifier: "showHomeScreen", sender: self)
              }
            }
          }
        }
      }
    }
  }
  
  @IBAction func didTouchRegisterButton(_ sender: Any) {
    performSegue(withIdentifier: "showSignup", sender: self)
  }
  
  // Back to Login screen
  @IBAction func unwindToLoginScreen(segue:UIStoryboardSegue) {
  }
}

extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  func dismissKeyboard() {
    view.endEditing(true)
  }
}
