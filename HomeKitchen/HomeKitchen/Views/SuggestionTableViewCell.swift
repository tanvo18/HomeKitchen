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
  
  @IBOutlet weak var priceLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configureWithItem(item: SuggestionItem) {
    productNameLabel.text = item.product.name
    quantityLabel.text = "\(item.quantity) X"
    priceLabel.text = "\(item.product.price)"
  }
  
}
