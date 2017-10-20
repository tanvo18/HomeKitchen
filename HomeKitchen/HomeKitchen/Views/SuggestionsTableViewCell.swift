//
//  SuggestionsTableViewCell.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/20/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class SuggestionsTableViewCell: UITableViewCell {
  
  @IBOutlet weak var idLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configureWithItem(suggestion: Suggestion) {
    idLabel.text = "\(suggestion.id)"
  }
}
