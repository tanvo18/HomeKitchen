//
//  ReviewsTableViewCell.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/30/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit
import Cosmos
class ReviewsTableViewCell: UITableViewCell {
  
  // MARK: IBOutlet
  
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var cosmosView: CosmosView!
  @IBOutlet weak var contentTextView: UITextView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configureWithReview(review: Review) {
    usernameLabel.text = review.user?.name
    cosmosView.rating = Double(review.point)
    contentTextView.text = review.message
    // Disable contentTextView
    contentTextView.isUserInteractionEnabled = false
    // Disable rating view
    cosmosView.isUserInteractionEnabled = false
  }
}
