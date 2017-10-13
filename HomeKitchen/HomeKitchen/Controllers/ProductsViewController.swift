//
//  ProductsViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/11/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  let reuseable = "Cell"
  var products: [Product] = []
  var index: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "ProductsTableViewCell", bundle: nil), forCellReuseIdentifier: reuseable)
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    settingRightButtonItem()
    self.settingForNavigationBar(title: "Kitchen's Products")
    // MARK: Disable sidemenu
    sideMenuManager?.sideMenuController()?.sideMenu?.disabled = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
// MARK: tableView Delegate
extension ProductsViewController: UITableViewDelegate {
  
}

// MARK: tableView Datasource
extension ProductsViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseable) as! ProductsTableViewCell
    cell.configureWithItem(product: products[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.index = indexPath.row
    // Go to edit product screen
    performSegue(withIdentifier: "showEditProduct", sender: self)
    
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
        NetworkingService.sharedInstance.deleteProduct(productId: self.products[indexPath.row].id) {
          [unowned self] (message,error) in
          if error != nil {
            print(error!)
            self.alertError(message: "cannot delete")
          } else {
            self.products.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
          }
        }
      })
      self.alertConfirmation(message: "Are you sure", action: ok)
    }
  }
}

// MARK: Function
extension ProductsViewController {
  func settingRightButtonItem() {
    // Set nil for title if UIBarButton have an image to avoid bug button move down when alert message appears
    let rightButtonItem = UIBarButtonItem.init(
      title: nil,
      style: .done,
      target: self,
      action: #selector(rightButtonAction(sender:))
    )
    rightButtonItem.image = UIImage(named: "barbutton-plus")
    self.navigationItem.rightBarButtonItem = rightButtonItem
    self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: CGFloat(170/255.0), green: CGFloat(151/255.0), blue: CGFloat(88/255.0), alpha: 1.0)
  }
  
  func rightButtonAction(sender: UIBarButtonItem) {
    performSegue(withIdentifier: "showCreateProduct", sender: self)
  }
}

extension ProductsViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showEditProduct" {
      if let destination = segue.destination as? EditProductViewController {
        destination.product = products[index]
      }
    }
  }
}


