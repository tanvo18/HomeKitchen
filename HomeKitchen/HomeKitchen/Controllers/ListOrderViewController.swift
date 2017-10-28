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
  
  @IBOutlet weak var statusTextField: UITextField!
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
  // Status for request list order by chef
  var listStatus: [String] = ["pending","accepted","negotiating","denied"]
  // Default status
  var selectedStatus: String = "pending"
  
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
    var title = ""
    if Helper.role == "chef" {
      title = "Đơn hàng của bếp"
    } else if Helper.role == "customer" {
      title = "Đơn hàng của tôi"
      statusTextField.isHidden = true
    }
    self.settingForNavigationBar(title: title)
    createStatusPicker()
    createToolbar()
    // Set default content for textfield
    statusTextField.text = selectedStatus
    // Request Data
    if Helper.role == "customer" {
      customerOrderModelDatasource.requestCustomerOrder()
    } else if Helper.role == "chef" {
      selectedStatus = "pending"
      kitchenOrderModelDatasource.requestKitchenOrder(status: selectedStatus)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

// MARK: tableView Delegate
extension ListOrderViewController: UITableViewDelegate {
}

// MARK: tableView Datasource
extension ListOrderViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return orderInfos.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! GetOrderTableViewCell
    // Distinguish role
    let role = Helper.role
    cell.configureWithItem(orderInfo: orderInfos[indexPath.row], role: role, status: selectedStatus)
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

extension ListOrderViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return listStatus.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return listStatus[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedStatus = listStatus[row]
    statusTextField.text = selectedStatus
  }
}

// MARK: Function
extension ListOrderViewController {
  func didTouchMenuButton(sender: UIButton) {
    sideMenuManager?.toggleSideMenuView()
  }
  
  func didTouchButtonNotification(sender: UIButton) {
    index = sender.tag
    if orderInfos[index].suggestions.isEmpty {
      let title = "Message"
      let message = "This Order doesn't have any suggestion"
      self.alert(title: title, message: message)
    } else {
     performSegue(withIdentifier: "showListSuggestion", sender: self)
    }
  }
  
  func createStatusPicker() {
    let statusPicker = UIPickerView()
    statusPicker.delegate = self
    statusTextField.inputView = statusPicker
  }
  
  // Toolbar for statusPicker
  func createToolbar() {
    // Create a toolbar
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    // Add a done button on this toolbar
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
    toolbar.setItems([doneButton], animated: true)
    statusTextField.inputAccessoryView = toolbar
  }
  
  // Click done button on toolbar of statusPicker
  func doneClicked() {
    self.dismissKeyboard()
    kitchenOrderModelDatasource.requestKitchenOrder(status: selectedStatus)
  }
}

extension ListOrderViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showOrderDetail" {
      if let destination = segue.destination as? OrderDetailViewController {
        destination.orderInfo = orderInfos[index]
        /*
         follow status which chef choose to show list: pending, accepted ...
         */
        destination.chefOrderStatus = selectedStatus
      }
    } else if segue.identifier == "showListSuggestion" {
      if let destination = segue.destination as? SuggestionsViewController {
        destination.suggestions = orderInfos[index].suggestions
      }
    }
  }
}


