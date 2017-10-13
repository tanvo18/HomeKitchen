//
//  MakeSuggestionViewCell.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/27/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class MakeSuggestionViewCell: UITableViewCell {
  
  
  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var quantityLabel: UILabel!
  
  @IBOutlet weak var priceTextField: UITextField!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configureWithItem(orderItem: OrderItem) {
    guard let productName =  orderItem.product?.name, let productPrice = orderItem.product?.price else {
      return
    }
    quantityLabel.text = "\(orderItem.quantity) X"
    nameLabel.text = productName
    priceTextField.text = "\(productPrice)"
  }
  
}
