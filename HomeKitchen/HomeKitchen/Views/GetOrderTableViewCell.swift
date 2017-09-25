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
  
  @IBOutlet weak var imageViewCell: UIImageView!
  
  @IBOutlet weak var deliveryDateLabel: UILabel!
  
  @IBOutlet weak var deliveryTimeLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configureWithItem(orderInfo: OrderInfo) {
    nameLabel.text = orderInfo.kitchen.name
    statusLabel.text = orderInfo.status
    deliveryDateLabel.text = orderInfo.deliveryDate
    deliveryTimeLabel.text = orderInfo.deliveryTime
  }
  
}
