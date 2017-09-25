//
//  OrderDetailTableViewCell.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/24/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class OrderDetailTableViewCell: UITableViewCell {
  
  @IBOutlet weak var quantityLabel: UILabel!
  
  @IBOutlet weak var nameProductLabel: UILabel!
  
  @IBOutlet weak var priceLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configureWithItem(orderItem: OrderItem) {
    quantityLabel.text = "\(orderItem.quantity) X"
    nameProductLabel.text = orderItem.product.name
    priceLabel.text = "\(orderItem.product.price)"
  }
}
