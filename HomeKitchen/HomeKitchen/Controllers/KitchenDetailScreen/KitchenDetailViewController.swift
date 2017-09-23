//
//  KitchenDetailViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/6/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire

class KitchenDetailViewController: UIViewController {
  
  // MARK: IBOutlet
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet weak var pointLabel: UILabel!
  @IBOutlet weak var indicator: UIActivityIndicatorView!
  @IBOutlet weak var timeLabel: UILabel!
  var products: [OrderItem] = []{
    didSet {
      tableView.reloadData()
    }
  }
  // Items which customer ordered at Order Screen
  var orderedItems: [OrderItem] = []
  
  let reuseableCell = "Cell"
  let productModelDatasource = ProductDataModel()
  var imageUrl: String = ""
  var point: Double = 0.0
  var time: String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // MARK: Disable sidemenu
    sideMenuManager?.sideMenuController()?.sideMenu?.disabled = true
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "TopOrderTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    // MARK: KitchenDataModelDelegate
    productModelDatasource.delegate = self
    // Hide Foot view
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    // Start indicator
    indicator.startAnimating()
    downloadBackgroundImage()
    pointLabel.text = "\(point)"
    timeLabel.text = time
    // Request data through delagate
    productModelDatasource.requestProduct()
    // Set title for back button in navigation bar
    navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // When return HomeScreen
  override func willMove(toParentViewController parent: UIViewController?)
  {
    
    if parent == nil
    {
      print("====WillMove")
      // Current date
      let currentDate: String = chooseCurrentDate()
      // Create default contact
      var defaultContact: ContactInfo = ContactInfo()
      if Helper.user.contactInformations.isEmpty {
        // Default id for contact info = 69
        defaultContact.id = 69
      } else {
        defaultContact = Helper.user.contactInformations[0]
      }
      
      // There are 2 status represent for cart status: pending and in_cart
      if Helper.status == "pending" {
        if isExistProductInCart() {
          
          // add items customer ordered
          addOrderedItems()
          // send order with status in_cart
          NetworkingService.sharedInstance.sendOrder(contact: defaultContact, orderDate: currentDate, deliveryDate: "", deliveryTime: "", status: "in_cart", kitchenId: Helper.kitchenId, orderedItems: orderedItems) { (error) in
            if error != nil {
              print(error!)
            }
          }
        }
      } else if Helper.status == "in_cart" {
        if isExistProductInCart() {
          // add items customer ordered
          addOrderedItems()
          // Update with status in_cart
          NetworkingService.sharedInstance.updateOrder(id: Helper.orderInfo.id, contact: defaultContact, orderDate: currentDate, deliveryDate: Helper.orderInfo.deliveryDate, deliveryTime: Helper.orderInfo.deliveryTime, status: "in_cart", orderedItems: orderedItems) { (error) in
            if error != nil {
               print(error!)
            }
           
          }
        } else {
          // Delete order if there are nothing in cart
          NetworkingService.sharedInstance.deleteOrder(id: Helper.orderInfo.id) { (error) in
            if error != nil {
              print(error!)
            }
          }
        }
      }
    }
  }
  
  func isExistProductInCart() -> Bool {
    for item in products {
      if item.quantity > 0 {
        return true
      }
    }
    return false
  }
  
}

// MARK: tableView Delegate
extension KitchenDetailViewController: UITableViewDelegate {
  
}

// MARK: tableView Datasource
extension KitchenDetailViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! TopOrderTableViewCell
    cell.backgroundColor = .gray
    //  cell.configureWithItem(product: products[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
  
}

// MARK: ProductDataModelDelegate
extension KitchenDetailViewController: ProductDataModelDelegate {
  func didRecieveProductUpdate(data: [OrderItem]) {
    products = data
  }
  func didFailProductUpdateWithError(error: String) {
    print("error \(error)")
  }
}

extension KitchenDetailViewController {
  // MARK: download image with url
  func downloadBackgroundImage() {
    let url = URL(string: imageUrl)!
    ImageDownloader.default.downloadImage(with: url, options: [], progressBlock: nil) {
      (image, error, url, data) in
      self.backgroundImage.image = image
      self.indicator.stopAnimating()
      self.indicator.isHidden = true
    }
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
  
  func chooseCurrentDate() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let result = formatter.string(from: date)
    return result
  }
}

// MARK: IBAction
extension KitchenDetailViewController {
  @IBAction func didTouchDeliveryButton(_ sender: Any) {
    performSegue(withIdentifier: "showListOrder", sender: self)
  }
}

extension KitchenDetailViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showListOrder" {
      if let destination = segue.destination as? OrderViewController {
        destination.products = products
      }
    }
  }
}



