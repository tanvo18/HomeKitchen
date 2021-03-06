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
  
  var nViewController: UIViewController? = nil
  
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
    switch sectionIndex {
    case 0:
      switch index {
      case 0:
        nViewController = storyboard?.instantiateViewController(withIdentifier: "KitchenViewController")
      default:
        break
      }
    case 1:
      switch index {
      case 0:
        nViewController = storyboard?.instantiateViewController(withIdentifier: "EditUserInfoViewController")
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
      case 3:
        Helper.role = "chef"
        nViewController = storyboard?.instantiateViewController(withIdentifier: "CreateKitchenViewController")
      default:
        break
      }
    case 3:
      switch index {
      case 0:
          // Clear UserDefault
          UserDefaults.standard.removeObject(forKey: Helper.USER_DEFAULT_AUTHEN_TOKEN)
          UserDefaults.standard.removeObject(forKey: Helper.USER_DEFAULT_USERNAME)
          // Clear Facebook
          let loginManager = LoginManager()
          loginManager.logOut()
          // Hide navigation bar
          self.navigationBar.isHidden = true
          nViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
      default:
        break
      }
    default:
      break
    }
    
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
