//
//  LocationTableViewCell.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/9/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
  
  @IBOutlet weak var locationLabel: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
