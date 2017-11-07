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
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var indicator: UIActivityIndicatorView!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var kitchenNameLabel: UILabel!
  @IBOutlet weak var popularFoodLabel: UILabel!
  // Foot View Outlet
  @IBOutlet weak var phoneLabel: UILabel!
  @IBOutlet weak var typeLabel: UILabel!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var buttonShowReviews: UIButton!
  
  var products: [OrderItem] = []{
    didSet {
      // sorted product totalOrderAmount
      products.sort{ $0.product!.totalOrderAmount > $1.product!.totalOrderAmount}
      if products.count < TOP_ORDER_ROW_QUANTITIES {
        heightOfRows = 0
        popularFoodLabel.isHidden = true
      } else {
        // Calculate height for tableview (tableView has 3 rows)
        heightOfRows = 3 * heightForOneRow
        popularFoodLabel.isHidden = false
      }
      updateViewConstraints()
      tableView.reloadData()
    }
  }
  
  var reviews: [Review] = []
  
  // Items which customer ordered at Order Screen
  var orderedItems: [OrderItem] = []
  
  let reuseableCell = "Cell"
  let productModelDatasource = ProductDataModel()
  let reviewDataModel = ReviewDataModel()
  var kitchen: Kitchen?
  let TOP_ORDER_ROW_QUANTITIES: Int = 3
  var heightOfRows: CGFloat = 0
  var heightForOneRow: CGFloat = 120
  
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
    parseDataForLabel()
    // Request data through delagate
    productModelDatasource.requestProduct()
    // Request kitchen reviews
    getKitchenReviews()
    // Set title for back button in navigation bar
    self.settingForNavigationBar(title: "Thông tin bếp")
    // Disable scroll tableview
    tableView.isScrollEnabled = false
  }
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
    tableHeightConstraint.constant = heightOfRows
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
      if Helper.orderInfo.status == "pending" {
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
      } else if Helper.orderInfo.status == "in_cart" {
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
    if products.count < TOP_ORDER_ROW_QUANTITIES {
      return 0
    } else {
      return products.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! TopOrderTableViewCell
    if products.count >= TOP_ORDER_ROW_QUANTITIES {
      cell.configureWithItem(product: products[indexPath.row].product!)
      // Hide separator of last row
      if indexPath.row == 2 {
        cell.separatorView.isHidden = true
      }
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return heightForOneRow
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

// MARK: Function
extension KitchenDetailViewController {
  
  func parseDataForLabel() {
    guard let kitchenName = kitchen?.name, let point = kitchen?.point, let openTime = kitchen?.open, let closeTime = kitchen?.close, let address = kitchen?.address, let imageUrl = kitchen?.imageUrl else {
      return
    }
    downloadBackgroundImage(imageUrl: imageUrl)
    
    pointLabel.text = "\(Double(round(10*point)/10))"
    timeLabel.text = "\(openTime) - \(closeTime)"
    addressLabel.text = address.address + " " + address.district + " " + address.city
    kitchenNameLabel.text = kitchenName
    if point < 0 {
      pointLabel.isHidden = true
    }
    // Foot view
    phoneLabel.text = kitchen?.address?.phoneNumber
    typeLabel.text = kitchen?.type
    descriptionTextView.text = kitchen?.description
  }
  
  // MARK: download image with url
  func downloadBackgroundImage(imageUrl: String) {
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
  
  func getKitchenReviews() {
    reviewDataModel.getKitchenReviews(kitchenId: Helper.kitchenId) {
      [unowned self] (kitchenReviews,error) in
      if error != nil {
        print(error!)
      } else {
        self.reviews = kitchenReviews
      }
    }
  }
}

// MARK: IBAction
extension KitchenDetailViewController {
  @IBAction func didTouchDeliveryButton(_ sender: Any) {
    performSegue(withIdentifier: "showOrderScreen", sender: self)
  }
  
  @IBAction func didTouchPostRequestButton(_ sender: Any) {
    performSegue(withIdentifier: "showPostRequest", sender: self)
  }
  
  @IBAction func didTouchReviewButton(_ sender: Any) {
    performSegue(withIdentifier: "showReviews", sender: self)
  }
}

extension KitchenDetailViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showOrderScreen" {
      if let destination = segue.destination as? OrderViewController {
        destination.products = products
      }
    } else if segue.identifier == "showReviews" {
      if let destination = segue.destination as? KitchenReviewsViewController {
        destination.reviews = reviews
      }
    }
  }
}



