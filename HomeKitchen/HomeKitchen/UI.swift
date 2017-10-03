//
//  UI.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/22/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//
import UIKit

extension UIViewController{
  
  func alert(title: String, message: String) {
    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
    let view = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    view.addAction(ok)
    self.present(view, animated: true, completion: nil)
  }
  
  func dismissKeyboard() {
    view.endEditing(true)
  }
  
  func alertWithAction(message: String, action: UIAlertAction) {
    let alert = UIAlertController(title: "Notification", message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(action)
    self.present(alert, animated: true, completion: nil)
  }
}

