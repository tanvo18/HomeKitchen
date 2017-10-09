//
//  CustomTimeTableViewCell.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/8/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class CustomTimeTableViewCell: UITableViewCell {
  
  
  @IBOutlet weak var imageViewCell: UIImageView!
  
  @IBOutlet weak var openingTextField: UITextField!
  
  @IBOutlet weak var closingTextField: UITextField!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
