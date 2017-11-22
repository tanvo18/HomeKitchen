//
//  SuggestionTableViewCell.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/26/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class SuggestionTableViewCell: UITableViewCell {
  
  @IBOutlet weak var productNameLabel: UILabel!
  
  @IBOutlet weak var quantityLabel: UILabel!
  
  @IBOutlet weak var itemPriceLabel: UILabel!
  
  @IBOutlet weak var separatorView: UIView!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configureWithItem(item: SuggestionItem) {
    guard let productName = item.product?.name else {
      return
    }
    productNameLabel.text = productName
    quantityLabel.text = "\(item.quantity) X"
    itemPriceLabel.text = "\(item.price)"
  }
  
}
