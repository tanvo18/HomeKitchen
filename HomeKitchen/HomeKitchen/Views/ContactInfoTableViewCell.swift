//
//  ContactInfoTableViewCell.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/20/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class ContactInfoTableViewCell: UITableViewCell {
  // MARK IBOutlet
  
  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var phoneLabel: UILabel!
  
  @IBOutlet weak var addressLabel: UILabel!
  
  @IBOutlet weak var radioButton: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func configureWithItem(contact: ContactInfo) {
    nameLabel.text = contact.name
    phoneLabel.text = contact.phoneNumber
    addressLabel.text = contact.address
    if contact.isChosen {
      radioButton.setImage(UIImage(named: "rad-button-check"), for: .normal)
    } else {
      radioButton.setImage(UIImage(named: "rad-button-uncheck"), for: .normal)
    }
  }
  
}
