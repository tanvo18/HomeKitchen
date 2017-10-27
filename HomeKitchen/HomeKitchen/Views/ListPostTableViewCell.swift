//
//  ListPostTableViewCell.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/17/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class ListPostTableViewCell: UITableViewCell {
  
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var notificationButton: UIButton!
  @IBOutlet weak var statusImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configureWithItem(post: Post, role: String) {
    if role == "customer" {
      nameLabel.text = post.kitchen?.name
      statusLabel.text = post.status
    } else if role == "chef" {
      nameLabel.text = post.contactInfo?.name
      statusLabel.text = post.status
    }
    timeLabel.text = post.requestDate
    if post.status == "accepted" {
      statusImageView.image = UIImage(named: "checkmark-green")
    } else if post.status == "denied"{
      statusImageView.image = UIImage(named: "icon-redtriangle")
    } else {
      statusImageView.image = UIImage(named: "icon-yellowtriangle")
    }
  }
}
