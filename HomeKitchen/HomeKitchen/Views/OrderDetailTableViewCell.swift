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
    guard let productName = orderItem.product?.name, let productPrice = orderItem.product?.price  else {
      return
    }
    quantityLabel.text = "\(orderItem.quantity) X"
    nameProductLabel.text = productName
    priceLabel.text = "\(productPrice)"
  }
}