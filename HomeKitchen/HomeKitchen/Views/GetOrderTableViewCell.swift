//
//  GetOrderTableViewCell.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/24/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class GetOrderTableViewCell: UITableViewCell {
  
  // MARK: IBOutlet
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var calendarLabel: UILabel!
  @IBOutlet weak var buttonNotification: UIButton!
  @IBOutlet weak var statusImageView: UIImageView!
  @IBOutlet weak var notificationLabel: UILabel!
  
  var newMessage = 0
  var didHaveDeniedMessage: Bool = false
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configureWithItem(orderInfo: OrderInfo, role: String, status: String) {
    if role == "customer" {
      nameLabel.text = orderInfo.kitchen?.name
      statusLabel.text = orderInfo.status
    } else if role == "chef" {
      nameLabel.text = orderInfo.contactInfo?.name
      statusLabel.text = status
    }
    calendarLabel.text = orderInfo.orderDate
    
    // Change status to vietnamese
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
    
    // Set image
    if orderInfo.status == "accepted" || status == "accepted" {
      statusImageView.image = UIImage(named: "checkmark-green")
    } else if orderInfo.status == "denied" || status == "denied" {
      statusImageView.image = UIImage(named: "icon-redtriangle")
    } else{
      statusImageView.image = UIImage(named: "icon-yellowtriangle")
    }
    
    // Round label
    notificationLabel.layer.masksToBounds = true
    notificationLabel.layer.cornerRadius = notificationLabel.frame.size.width / 2
    
    // Set number for notiLabel
    self.newMessage = 0
    for suggestion in orderInfo.suggestions {
      if suggestion.status == "pending" {
        self.newMessage += 1
      }
    }
    notificationLabel.text = "\(newMessage)"
    
    for suggestion in orderInfo.suggestions {
      if suggestion.status == "denied" {
        didHaveDeniedMessage = true
      }
    }
    
    print("====didHaveDenied \(didHaveDeniedMessage) ")
    // If we dont have a pending message and have a denied message then set ! for notification label
    // If we have a pending message then set number for notification label
    if self.newMessage == 0 && didHaveDeniedMessage == false {
      notificationLabel.isHidden = true
    } else if self.newMessage == 0 && didHaveDeniedMessage == true {
      print("====bingo ")
      notificationLabel.isHidden = false
      notificationLabel.text = "!"
    } else {
      notificationLabel.isHidden = false
    }
    // Reset didHaveDeniedMessage to avoid keeping old value to new row in another status
    didHaveDeniedMessage = false
  }
}
