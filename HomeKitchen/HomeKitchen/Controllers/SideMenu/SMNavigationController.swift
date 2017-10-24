//
//  SMNavigationController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/1/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import LNSideMenu
import FacebookLogin
import FacebookCore

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
  
  fileprivate func setContentVC(_ index: Int, _ sectionIndex: Int) {
    print("Did select item at index: \(index)")
    print("section: \(sectionIndex)")
    var nViewController: UIViewController? = nil
    switch sectionIndex {
    case 0:
      switch index {
      case 0:
        nViewController = storyboard?.instantiateViewController(withIdentifier: "RestaurantViewController")
      default:
        break
      }
    case 1:
      switch index {
      case 0:
        break
      case 1:
        Helper.role = "customer"
        nViewController = storyboard?.instantiateViewController(withIdentifier: "ListOrderViewController")
      case 2:
        Helper.role = "customer"
        nViewController = storyboard?.instantiateViewController(withIdentifier: "ListPostViewController")
      default:
        break
      }
    case 2:
      switch index {
      case 0:
        Helper.role = "chef"
        nViewController = storyboard?.instantiateViewController(withIdentifier: "ListOrderViewController")
      case 1:
        Helper.role = "chef"
        nViewController = storyboard?.instantiateViewController(withIdentifier: "ListPostViewController")
      case 2:
        Helper.role = "chef"
        nViewController = storyboard?.instantiateViewController(withIdentifier: "EditKitchenViewController")
      default:
        break
      }
    case 3:
      switch index {
      case 0:
        let loginManager = LoginManager()
        loginManager.logOut()
        nViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
      default:
        break
      }
    default:
      break
    }
    
    
//    switch index {
//    case 0:
//      nViewController = storyboard?.instantiateViewController(withIdentifier: "RestaurantViewController")
//    case 1:
//      Helper.role = "customer"
//      nViewController = storyboard?.instantiateViewController(withIdentifier: "ListOrderViewController")
//    case 2:
//      Helper.role = "chef"
//      nViewController = storyboard?.instantiateViewController(withIdentifier: "ListOrderViewController")
//    case 3:
//      Helper.role = "chef"
//      nViewController = storyboard?.instantiateViewController(withIdentifier: "CreateKitchenViewController")
//    case 4:
//      Helper.role = "chef"
//      nViewController = storyboard?.instantiateViewController(withIdentifier: "EditKitchenViewController")
//    case 5:
//      Helper.role = "chef"
//      nViewController = storyboard?.instantiateViewController(withIdentifier: "ListPostViewController")
//    case 6:
//      Helper.role = "customer"
//      nViewController = storyboard?.instantiateViewController(withIdentifier: "ListPostViewController")
//    case 7:
//      let loginManager = LoginManager()
//      loginManager.logOut()
//      nViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
//      
//    default:
//      break
//    }
    if let viewController = nViewController {
      self.setContentViewController(viewController)
    }
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
    //   setContentVC(index)
  }
}

extension SMNavigationController: LeftMenuDelegate {
  func didSelectItemAtIndex(index idx: Int, sectionIndex: Int) {
    sideMenu?.toggleMenu() { [unowned self] _ in
      print("====itemIndex")
      self.setContentVC(idx,sectionIndex)
    }
  }
}
