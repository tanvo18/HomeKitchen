//
//  RestaurantsViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/1/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import LNSideMenu

class RestaurantsViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func didTouchButtonMenu(_ sender: Any) {
    sideMenuManager?.toggleSideMenuView()
  }
  
  
  
}
