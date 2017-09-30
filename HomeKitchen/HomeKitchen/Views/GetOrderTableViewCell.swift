//
//  GetOrderTableViewCell.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/24/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class GetOrderTableViewCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var statusLabel: UILabel!
  
  @IBOutlet weak var calendarLabel: UILabel!
  
  @IBOutlet weak var buttonNotification: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configureWithItem(orderInfo: OrderInfo, role: String) {
    if orderInfo.status != "in_cart" {
      if role == "customer" {
        nameLabel.text = orderInfo.kitchen?.name
      } else if role == "chef" {
        nameLabel.text = orderInfo.contactInfo?.name
      }
      statusLabel.text = orderInfo.status
      calendarLabel.text = orderInfo.orderDate
    }
  }
  
}
