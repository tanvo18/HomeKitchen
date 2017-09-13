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
  @IBOutlet weak var totalPriceLabel: UILabel!
  var products: [OrderItem] = []
  let reuseableCell = "Cell"
  let productModelDatasource = ProductDataModel()
  var position: Int = 0
  var totalPrice: Int = 0
  var productQuantityInCart = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // MARK: Disable sidemenu
    sideMenuManager?.sideMenuController()?.sideMenu?.disabled = true
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    // Hide Foot view
    tableView.tableFooterView = UIView(frame: CGRect.zero)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // MARK: calculate price if orderItem has any item with quantity > 0
    calculatePriceInCart()
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
    cell.configureWithItem(product: products[indexPath.row].product, quantity: products[indexPath.row].quantity)
    //    // click button plus and button minus
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

extension OrderViewController {
  func didTouchButtonPlus(sender: UIButton) {
    position = sender.tag
    products[position].quantity += 1
    addPrice(position: position)
    tableView.reloadData()
  }
  
  func didTouchButtonMinus(sender: UIButton) {
    position = sender.tag
    if products[position].quantity > 0 {
      products[position].quantity -= 1
      subtractPrice(position: position)
    }
    tableView.reloadData()
  }
}

extension OrderViewController {
  func addPrice(position: Int) {
    totalPrice += products[position].product.price
    productQuantityInCart += 1
    if productQuantityInCart <= 1 {
      totalPriceLabel.text = "\(productQuantityInCart) item - \(totalPrice) $"
    }
    else {
      totalPriceLabel.text = "\(productQuantityInCart) items - \(totalPrice) $"
    }
  }
  
  func subtractPrice(position: Int) {
    totalPrice -= products[position].product.price
    productQuantityInCart -= 1
    if productQuantityInCart <= 1 {
      totalPriceLabel.text = "\(productQuantityInCart) item - \(totalPrice) $"
    }
    else {
      totalPriceLabel.text = "\(productQuantityInCart) items - \(totalPrice) $"
    }
  }
}

extension OrderViewController {
  func calculatePriceInCart() {
    var price = 0
    var quantity = 0
    for orderItem in products {
      price += orderItem.product.price * orderItem.quantity
      quantity += orderItem.quantity
    }
    if quantity <= 1 {
      totalPriceLabel.text = "\(quantity) item - \(price) $"
    } else {
      totalPriceLabel.text = "\(quantity) items - \(price) $"
    }
    totalPrice = price
    productQuantityInCart = quantity
  }
}

// MARK: IBAction
extension OrderViewController {
  @IBAction func didTouchButtonReset(_ sender: Any) {
    for orderItem in products {
      orderItem.quantity = 0
    }
    totalPriceLabel.text = "0 item - 0 $"
    totalPrice = 0
    productQuantityInCart = 0
    tableView.reloadData()
  }
}
