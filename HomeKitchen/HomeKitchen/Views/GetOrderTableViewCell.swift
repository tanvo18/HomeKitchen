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
  
  @IBOutlet weak var buttonNotification: UIButton!
  
  @IBOutlet weak var deliveryDateLabel: UILabel!
  
  @IBOutlet weak var deliveryTimeLabel: UILabel!
  
  @IBOutlet weak var buttonMakeSuggestion: UIButton!

  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configureWithItem(orderInfo: OrderInfo, role: String) {
    if role == "customer" {
      nameLabel.text = orderInfo.kitchen?.name
      buttonMakeSuggestion.isHidden = true
    } else if role == "chef" {
      nameLabel.text = orderInfo.contactInfo.name
    }
    statusLabel.text = orderInfo.status
    deliveryDateLabel.text = orderInfo.deliveryDate
    deliveryTimeLabel.text = orderInfo.deliveryTime
  }
  
}
