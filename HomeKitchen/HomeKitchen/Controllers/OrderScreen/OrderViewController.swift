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
  // Items which customer ordered
  var orderedItems: [OrderItem] = []
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
    settingForNavigationBar()
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
    if let product = products[indexPath.row].product {
      cell.configureWithItem(product: product, quantity: products[indexPath.row].quantity)
    }
    // Click button in cell
    cell.buttonPlus.tag = indexPath.row
    cell.buttonPlus.addTarget(self, action: #selector(self.didTouchButtonPlus), for: .touchUpInside)
    cell.buttonMinus.tag = indexPath.row
    cell.buttonMinus.addTarget(self, action: #selector(self.didTouchButtonMinus), for: .touchUpInside)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
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
    if let productPrice = products[position].product?.price {
      totalPrice += productPrice
    }
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
    if let productPrice = products[position].product?.price {
      totalPrice -= productPrice
    }
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
      if let productPrice = orderItem.product?.price {
        price += productPrice * orderItem.quantity
      }
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
  
  // Add ordered item to orderedItems
  func addOrderedItems() {
    // Reset orderedItems avoid similar items
    orderedItems.removeAll()
    for item in products {
      if item.quantity > 0 {
        orderedItems.append(item)
      }
    }
  }
  
  func settingForNavigationBar() {
    // Set title for back button in navigation bar
    navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    navigationController?.navigationBar.tintColor = UIColor(red: CGFloat(170/255.0), green: CGFloat(151/255.0), blue: CGFloat(88/255.0), alpha: 1.0)
    navigationItem.title = "Menu"
  }
}

// MARK: IBAction
extension OrderViewController {
  @IBAction func didTouchResetButton(_ sender: Any) {
    
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
  @IBAction func didTouchContinueButton(_ sender: Any) {
    // Check empty cart
    if productQuantityInCart > 0 {
      addOrderedItems()
      performSegue(withIdentifier: "showOrderInfo", sender: self)
    } else {
      let alert = UIAlertController(title: "Error", message: "You don't have any product in your cart.", preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
  }
}

extension OrderViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showOrderInfo" {
      if let destination = segue.destination as? OrderInfoViewController {
        destination.orderedItems = orderedItems
      }
    }
  }
}
