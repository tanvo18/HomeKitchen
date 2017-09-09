//
//  OrderViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/7/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var products: [Product] = []{
    didSet {
      tableView.reloadData()
    }
  }
  let reuseableCell = "Cell"
  let productModelDatasource = ProductDataModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // MARK: Disable sidemenu
    sideMenuManager?.sideMenuController()?.sideMenu?.disabled = true
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    // MARK: KitchenDataModelDelegate
    productModelDatasource.delegate = self
    // Hide Foot view
    tableView.tableFooterView = UIView(frame: CGRect.zero)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    productModelDatasource.requestProduct()
  }
}

extension OrderViewController: UITableViewDelegate {
  
}

extension OrderViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! OrderTableViewCell
    cell.configureWithItem(product: products[indexPath.row])
    // click button plus and button minus
    cell.buttonPlus.tag = indexPath.row
    cell.buttonPlus.addTarget(self, action: #selector(self.didTouchButtonPlus), for: .touchUpInside)
    cell.buttonMinus.tag = indexPath.row
    cell.buttonMinus.addTarget(self, action: #selector(self.didTouchButtonMinus), for: .touchUpInside)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
}

extension OrderViewController: ProductDataModelDelegate {
  func didRecieveProductUpdate(data: [Product]) {
    products = data
  }
  func didFailProductUpdateWithError(error: String) {
    print("error \(error)")
  }
}

extension OrderViewController {
  // MARK: click button plus
  func didTouchButtonPlus(sender: UIButton) {
    let position = sender.tag
    tableView.reloadData()
  }
  
  // MARK: click button minus
  func didTouchButtonMinus(sender: UIButton) {
    let position = sender.tag
    tableView.reloadData()
  }
}
