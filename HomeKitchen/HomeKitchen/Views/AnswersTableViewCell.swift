//
//  AnswersTableViewCell.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/20/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class AnswersTableViewCell: UITableViewCell {
  
  @IBOutlet weak var deliveryDateLabel: UILabel!
  @IBOutlet weak var deliveryTimeLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var statusImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configureWithItem(answer: Answer) {
    deliveryDateLabel.text = answer.deliveryDate
    deliveryTimeLabel.text = answer.deliveryTime
    statusLabel.text = answer.status
    if answer.status == "accepted" {
      statusImageView.image = UIImage(named: "checkmark-green")
    } else if answer.status == "denied"{
      statusImageView.image = UIImage(named: "icon-redtriangle")
    } else {
      statusImageView.image = UIImage(named: "icon-yellowtriangle")
    }
    
    // change status to vietnamese
    switch statusLabel.text! {
    case "accepted":
      statusLabel.text = "Đã chấp nhận"
    case "denied":
      statusLabel.text = "Từ chối"
    case "pending":
      statusLabel.text = "Đang chờ duyệt"
    case "negotiating":
      statusLabel.text = "Thương lượng"
    default:
      break
    }
  }
}
