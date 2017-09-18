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
    // Set title for back button in navigation bar
    navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // MARK: calculate price of item in cart
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
    // Click button in cell
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
  // Increase quantity of product
  func didTouchButtonPlus(sender: UIButton) {
    position = sender.tag
    products[position].quantity += 1
    addPrice(position: position)
    tableView.reloadData()
  }
  
  // Decrease quantity of product
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
  // Increase price on checkout view
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
  
  // Decrease price on checkout view
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
  // Calculate total price of items in cart
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
  
  // Empty product order
  func resetOrder() {
    totalPriceLabel.text = "0 item - 0 $"
    totalPrice = 0
    productQuantityInCart = 0
    tableView.reloadData()
  }
}

// MARK: IBAction
extension OrderViewController {
  @IBAction func didTouchButtonReset(_ sender: Any) {
    
    let alert = UIAlertController(title: "Warning", message: "Do you want to reset the cart?", preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
      action in
      self.resetOrder()
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)
    
    for orderItem in products {
      orderItem.quantity = 0
    }
  }
  
  // Go to OrderInfoScreen
  @IBAction func didTouchButtonContinue(_ sender: Any) {
    // Check empty cart
    if productQuantityInCart > 0 {
      performSegue(withIdentifier: "showOrderInfo", sender: self)
    } else {
      let alert = UIAlertController(title: "Error", message: "You don't have any product in your cart.", preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
  }
}