//
//  ListOrderViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/24/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class ListOrderViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  let reuseableCell = "Cell"
  var orderInfos: [OrderInfo] = [] {
    didSet {
    
      tableView.reloadData()
    }
  }
  // Save index of table row
  var index: Int = 0
  let customerOrderModelDatasource = CustomerOrderDataModel()
  let kitchenOrderModelDatasource = KitchenOrderDataModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "GetOrderTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    // Hide Foot view
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    // Declare customerOrderModelDatasource
    customerOrderModelDatasource.delegate = self
    // Declare kitchenOrderModelDatasource
    kitchenOrderModelDatasource.delegate = self
    // Add left bar button
    let menuButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(self.didTouchMenuButton))
    self.navigationItem.leftBarButtonItem  = menuButton
    // Set title for back button in navigation bar
    navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
   
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if Helper.role == "customer" {
      customerOrderModelDatasource.requestCustomerOrder()
    } else if Helper.role == "chef" {
      kitchenOrderModelDatasource.requestKitchenOrder()
    }
  }
}

extension ListOrderViewController: UITableViewDelegate {
}

extension ListOrderViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return orderInfos.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! GetOrderTableViewCell
    // Distinguish role
    let role = Helper.role
    cell.configureWithItem(orderInfo: orderInfos[indexPath.row], role: role)
    // Handle button on cell
    cell.buttonNotification.tag = indexPath.row
    cell.buttonNotification.addTarget(self, action: #selector(self.didTouchButtonNotification), for: .touchUpInside)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Save index
    index = indexPath.row
    performSegue(withIdentifier: "showOrderDetail", sender: self)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
}

// MARK: CustomerOrderDataModel Delegate
extension ListOrderViewController: CustomerOrderDataModelDelegate {
  func didRecieveCustomerOrder(data: [OrderInfo]) {
    orderInfos = data
  }
  func didFailUpdateWithError(error: String) {
    print(error)
  }
}

// MARK: KitchenOrderDataModel Delegate
extension ListOrderViewController: KitchenOrderDataModelDelegate {
  func didRecieveKitchenOrder(data: [OrderInfo]) {
    orderInfos = data
  }
  
  func didFailKitchenOrderWithError(error: String) {
    print(error)
  }
}

extension ListOrderViewController {
  func didTouchMenuButton(sender: UIButton) {
    sideMenuManager?.toggleSideMenuView()
  }
  
  func didTouchButtonNotification(sender: UIButton) {
    if orderInfos[index].suggestions.isEmpty {
      let title = "Message"
      let message = "This Order doesn't have any suggestion"
      self.alert(title: title, message: message)
    } else {
     performSegue(withIdentifier: "showListSuggestion", sender: self)
    }
  }
}

extension ListOrderViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showOrderDetail" {
      if let destination = segue.destination as? OrderDetailViewController {
        destination.orderInfo = orderInfos[index]
      }
    } else if segue.identifier == "showListSuggestion" {
      if let destination = segue.destination as? SuggestionViewController {
        destination.suggestions = orderInfos[index].suggestions
      }
    }
  }
}


