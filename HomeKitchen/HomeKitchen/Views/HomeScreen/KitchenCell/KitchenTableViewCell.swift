//
//  KitchenTableViewCell.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/4/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit
import Kingfisher

class KitchenTableViewCell: UITableViewCell {
  
  @IBOutlet weak var kitchenNameLabel: UILabel!
  
  @IBOutlet weak var addressLabel: UILabel!
  
  @IBOutlet weak var timeLabel: UILabel!
  
  @IBOutlet weak var qualityLabel: UILabel!
  
  @IBOutlet weak var pointLabel: UILabel!
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  
  @IBOutlet weak var myIndicator: UIActivityIndicatorView!
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  // MARK: configure view cell
  func configureWithItem(kitchen: Kitchen) {
    kitchenNameLabel.text = kitchen.name
    addressLabel.text = "\(kitchen.address.address) \(kitchen.address.district) \(kitchen.address.city)"
    timeLabel.text = "\(kitchen.open) to \(kitchen.close)"
    pointLabel.text = "\(kitchen.point)"
    switch kitchen.point {
    case let point where point <= 1:
      qualityLabel.text = "VERY BAD"
    case let point where point <= 2:
      qualityLabel.text = "BAD"
    case let point where point <= 3:
      qualityLabel.text = "FAIR"
    case let point where point <= 4:
      qualityLabel.text = "GOOD"
    case let point where point < 5:
      qualityLabel.text = "VERY GOOD"
    case let point where point == 5:
      qualityLabel.text = "EXCELLENT"
    default:
      break
    }
    downloadImage(imageUrl: kitchen.imageUrl)
  }
  
  // MARK: download image with url
  func downloadImage(imageUrl: String) {
    myIndicator.startAnimating()
    let url = URL(string: imageUrl)!
    ImageDownloader.default.downloadImage(with: url, options: [], progressBlock: nil) {
      (image, error, url, data) in
      self.backgroundImageView.image = image
      // stop indicator
      self.myIndicator.stopAnimating()
      self.myIndicator.isHidden = true
    }
  }
}





