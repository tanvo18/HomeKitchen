//
//  AnswerTableViewCell.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/17/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {
  
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var quantityLabel: UILabel!
  @IBOutlet weak var itemNameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configureWithItem(answerDetail: AnswerDetail) {
    itemNameLabel.text = answerDetail.productName
    quantityLabel.text = "\(answerDetail.quantity) X"
    priceLabel.text = "\(answerDetail.itemPrice)"
  }
  
}
