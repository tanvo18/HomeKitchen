//
//  PostTableViewCell.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/15/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
  
  @IBOutlet weak var imageViewCell: UIImageView!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var buttonMinus: UIButton!
  @IBOutlet weak var buttonPlus: UIButton!
  @IBOutlet weak var quantityLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configureWithItem(item: PostItem) {
    quantityLabel.text = "\(item.quantity)"
  }
  
}
