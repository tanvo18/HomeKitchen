//
//  SMNavigationController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/1/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import LNSideMenu

class SMNavigationController: LNSideMenuNavigationController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Custom side menu
    initialCustomMenu(pos: .left)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  fileprivate func initialCustomMenu(pos position: Position) {
    let menu = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeftMenuTableViewController") as! LeftMenuTableViewController
    menu.delegate = self
    sideMenu = LNSideMenu(navigation: self, menuPosition: position, customSideMenu: menu)
    sideMenu?.delegate = self
    sideMenu?.enableDynamic = true
    // Moving down the menu view under navigation bar
    sideMenu?.underNavigationBar = true
  }
  
  fileprivate func setContentVC(_ index: Int) {
    print("Did select item at index: \(index)")
//    var nViewController: UIViewController? = nil
//    if let viewController = viewControllers.first , viewController is NextViewController {
//      nViewController = storyboard?.instantiateViewController(withIdentifier: "ViewController")
//    } else {
//      nViewController = storyboard?.instantiateViewController(withIdentifier: "NextViewController")
//    }
//    if let viewController = nViewController {
//      self.setContentViewController(viewController)
//    }
    // Test moving up/down the menu view
    if let sm = sideMenu, sm.isCustomMenu {
      sideMenu?.underNavigationBar = false
    }
  }
}

extension SMNavigationController: LNSideMenuDelegate {
  func sideMenuWillOpen() {
    print("sideMenuWillOpen")
  }
  
  func sideMenuWillClose() {
    print("sideMenuWillClose")
  }
  
  func sideMenuDidClose() {
    print("sideMenuDidClose")
  }
  
  func sideMenuDidOpen() {
    print("sideMenuDidOpen")
  }
  
  func didSelectItemAtIndex(_ index: Int) {
    setContentVC(index)
  }
}

extension SMNavigationController: LeftMenuDelegate {
  func didSelectItemAtIndex(index idx: Int) {
    sideMenu?.toggleMenu() { [unowned self] _ in
      self.setContentVC(idx)
    }
  }
}
