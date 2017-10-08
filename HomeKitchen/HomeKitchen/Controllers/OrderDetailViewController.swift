//
//  OrderDetailViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/24/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController {
  
  // MARK: IBOutlet
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var idLabel: UILabel!
  
  @IBOutlet weak var orderDateLabel: UILabel!
  
  @IBOutlet weak var deliveryTimeLabel: UILabel!
  
  @IBOutlet weak var deliveryDateLabel: UILabel!
  
  @IBOutlet weak var statusLabel: UILabel!
  
  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var addressLabel: UILabel!
  
  @IBOutlet weak var informationLabel: UILabel!
  
  @IBOutlet weak var makeSuggestionButton: UIButton!
  
  @IBOutlet weak var totalLabel: UILabel!
  
  @IBOutlet weak var acceptedButton: UIButton!
  
  @IBOutlet weak var declinedButton: UIButton!
  
  let reuseableCell = "Cell"
  
  var orderInfo: OrderInfo = OrderInfo()
  var orderId: Int = 0
  var isAccepted: Bool = true
  
  // Status for order of role chef
  var chefOrderStatus = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "OrderDetailTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    // Hide Foot view
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    self.settingForNavigationBar(title: "Order's detail")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    parseDataForLabel()
  }
  
}

extension OrderDetailViewController: UITableViewDelegate {
}

extension OrderDetailViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return orderInfo.products.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! OrderDetailTableViewCell
    cell.configureWithItem(orderItem: orderInfo.products[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
}

// MARK: IBAction
extension OrderDetailViewController {
  @IBAction func didTouchMakeSuggestionButton(_ sender: Any) {
  performSegue(withIdentifier: "showMakeSuggestion", sender: self)
  }
  
  @IBAction func didTouchAcceptedButton(_ sender: Any) {
    orderId = orderInfo.id
    isAccepted = true
    NetworkingService.sharedInstance.responseOrder(orderId: orderId, isAccepted: isAccepted) {
      (message,error) in
      if error != nil {
        print(error!)
        self.alertError(message: "Request cannot be done")
      } else {
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
          // Go to List order screen
          self.performSegue(withIdentifier: "showListOrder", sender: self)
        })
        self.alertWithAction(message: "Accept Successfully", action: ok)
      }
    }
  }
  
  @IBAction func didTouchDeclinedButton(_ sender: Any) {
    orderId = orderInfo.id
    isAccepted = false
    NetworkingService.sharedInstance.responseOrder(orderId: orderId, isAccepted: isAccepted) {
      (message,error) in
      if error != nil {
        print(error!)
        self.alertError(message: "Request cannot be done")
      } else {
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
          // Go to List order screen
          self.performSegue(withIdentifier: "showListOrder", sender: self)
        })
        self.alertWithAction(message: "Decline Successfully", action: ok)
      }
    }
  }
}

extension OrderDetailViewController {
  func parseDataForLabel() {
    idLabel.text = "\(orderInfo.id)"
    orderDateLabel.text = orderInfo.orderDate
    deliveryTimeLabel.text = orderInfo.deliveryTime
    deliveryDateLabel.text = orderInfo.deliveryDate
    totalLabel.text = "\(orderInfo.totalAmount)"
    if Helper.role == "customer" {
      informationLabel.text = "kitchen's information"
      statusLabel.text = orderInfo.status
      nameLabel.text = orderInfo.kitchen?.name
      addressLabel.text = orderInfo.kitchen?.address?.address
      makeSuggestionButton.isHidden = true
      acceptedButton.isHidden = true
      declinedButton.isHidden = true
    } else if Helper.role == "chef" {
      informationLabel.text = "customer's information"
      statusLabel.text = chefOrderStatus
      nameLabel.text = orderInfo.contactInfo?.name
      addressLabel.text = orderInfo.contactInfo?.address
    }
  }
  
}

extension OrderDetailViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showMakeSuggestion" {
      if let destination = segue.destination as? MakeSuggestionViewController {
        destination.orderInfo = orderInfo
      }
    }
  }
}
