//
//  AnswersTableViewCell.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/20/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class AnswersTableViewCell: UITableViewCell {
  
  @IBOutlet weak var idLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func configureWithItem(answer: Answer) {
    idLabel.text = "\(answer.id)"
  }
}
