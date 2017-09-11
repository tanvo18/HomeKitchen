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
  
  var products: [Product] = []{
    didSet {
      if Global.cart.products.isEmpty {
        Global.cart.products = products
        totalPriceLabel.text = "0 item - 0 $"
        totalPrice = 0
        productQuantityInCart = 0
      } else {
        products = Global.cart.products
        calculatePriceInCart()
      }
      tableView.reloadData()
    }
  }
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
    position = sender.tag
//    Global.cart.products[position].quantity += 1
    addPrice(position: position)
    tableView.reloadData()
  }
  
  // MARK: click button minus
  func didTouchButtonMinus(sender: UIButton) {
    position = sender.tag
//    if products[position].quantity > 0 {
//      Global.cart.products[position].quantity -= 1
//      subtractPrice(position: position)
//    }
    tableView.reloadData()
  }
}

extension OrderViewController {
  func addPrice(position: Int) {
    totalPrice += Global.cart.products[position].price
    productQuantityInCart += 1
    if productQuantityInCart <= 1 {
      totalPriceLabel.text = "\(productQuantityInCart) item - \(totalPrice)"
    } else {
      totalPriceLabel.text = "\(productQuantityInCart) items - \(totalPrice)"
    }
  }
  
  func subtractPrice(position: Int) {
    totalPrice -= Global.cart.products[position].price
    productQuantityInCart -= 1
    if productQuantityInCart <= 1 {
      totalPriceLabel.text = "\(productQuantityInCart) item - \(totalPrice)"
    } else {
      totalPriceLabel.text = "\(productQuantityInCart) items - \(totalPrice)"
    }
  }
  
  func calculatePriceInCart() {
    var price = 0
    var quantity = 0
    for item in Global.cart.products {
//      price += item.price * item.quantity
//      quantity += item.quantity
    }
    if quantity <= 1 {
      totalPriceLabel.text = "\(quantity) item - \(price)"
    } else {
      totalPriceLabel.text = "\(quantity) items - \(price)"
    }
    totalPrice = price
    productQuantityInCart = quantity
  }
}
