//
//  CreateKitchenTableViewCell.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/8/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class CreateKitchenTableViewCell: UITableViewCell {
  
  @IBOutlet weak var imageViewCell: UIImageView!
  
  @IBOutlet weak var textFieldCell: UITextField!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configureWithItem(title: String) {
    textFieldCell.placeholder = title
  }
  
}
