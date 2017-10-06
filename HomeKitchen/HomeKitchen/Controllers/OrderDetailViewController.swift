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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "OrderDetailTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    // Hide Foot view
    tableView.tableFooterView = UIView(frame: CGRect.zero)
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
}

extension OrderDetailViewController {
  func parseDataForLabel() {
    idLabel.text = "\(orderInfo.id)"
    orderDateLabel.text = orderInfo.orderDate
    deliveryTimeLabel.text = orderInfo.deliveryTime
    deliveryDateLabel.text = orderInfo.deliveryDate
    statusLabel.text = orderInfo.status
    totalLabel.text = "\(orderInfo.totalAmount)"
    if Helper.role == "customer" {
      informationLabel.text = "kitchen's information"
      nameLabel.text = orderInfo.kitchen?.name
      addressLabel.text = orderInfo.kitchen?.address?.address
      makeSuggestionButton.isHidden = true
      acceptedButton.isHidden = true
      declinedButton.isHidden = true
    } else if Helper.role == "chef" {
      informationLabel.text = "customer's information"
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
