//
//  UI.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/22/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//
import UIKit
import LNSideMenu

extension UIViewController{
  
  func alert(title: String, message: String) {
    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
    let view = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    view.addAction(ok)
    self.present(view, animated: true, completion: nil)
  }
  
  func alertError(message: String) {
    let error = UIAlertAction(title: "Thoát", style: .default, handler: nil)
    let view = UIAlertController(title: "Lỗi", message: message, preferredStyle: UIAlertControllerStyle.alert)
    view.addAction(error)
    self.present(view, animated: true, completion: nil)
  }
  
  func alertWithAction(message: String, action: UIAlertAction) {
    let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(action)
    self.present(alert, animated: true, completion: nil)
  }
  
  func alertConfirmation(message: String, action: UIAlertAction) {
    let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: UIAlertControllerStyle.alert)
    let cancelAction = UIAlertAction(title: "Thoát", style: UIAlertActionStyle.cancel, handler: nil)
    alert.addAction(action)
    alert.addAction(cancelAction)
    self.present(alert, animated: true, completion: nil)
  }
  
  func dismissKeyboard() {
    view.endEditing(true)
  }
  
  func settingForNavigationBar(title: String) {
    // Set title for back button in navigation bar
    navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
//    navigationController?.navigationBar.tintColor = UIColor(red: CGFloat(170/255.0), green: CGFloat(151/255.0), blue: CGFloat(88/255.0), alpha: 1.0)
    navigationItem.title = title
  }

}

