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
  
  let userModelDatasource = UserDataModel()
  var myActivityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTextfield()
    self.hideKeyboardWhenTappedAround()
    // Setup indicator
    setUpActivityIndicator()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

// MARK: Function
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
  
  func setUpActivityIndicator()
  {
    //Create Activity Indicator
    myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    // Position Activity Indicator in the center of the main view
    myActivityIndicator.center = view.center
    myActivityIndicator.color = .white
    // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
    myActivityIndicator.hidesWhenStopped = true
    view.addSubview(myActivityIndicator)
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
        self.myActivityIndicator.startAnimating()
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
                // Save user information
                self.userModelDatasource.getUserInfo() {
                  [unowned self] (user,error) in
                  if error != nil {
                    print(error!)
                    self.alertError(message: "Không thể nhận được thông tin người dùng")
                  } else {
                    // Save user info
                    Helper.user = user
                    print("====nameOfUser \(user.name)")
                    self.myActivityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: "showHomeScreen", sender: self)
                  }
                }
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
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
}
