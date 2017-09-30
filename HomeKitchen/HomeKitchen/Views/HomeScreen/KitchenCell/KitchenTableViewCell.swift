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
    guard let address = kitchen.address?.address, let district = kitchen.address?.district, let city = kitchen.address?.city else {
      return
    }
    kitchenNameLabel.text = kitchen.name
    addressLabel.text = "\(address) \(district) \(city)"
    timeLabel.text = "\(kitchen.open) to \(kitchen.close)"
    pointLabel.text = "\(kitchen.point)"
    switch kitchen.point {
    case let point where point <= Constant.verybadPoint:
      qualityLabel.text = "VERY BAD"
    case let point where point <= Constant.badPoint:
      qualityLabel.text = "BAD"
    case let point where point <= Constant.fairPoint:
      qualityLabel.text = "FAIR"
    case let point where point <= Constant.goodPoint:
      qualityLabel.text = "GOOD"
    case let point where point < Constant.excellentPoint:
      qualityLabel.text = "VERY GOOD"
    case let point where point == Constant.excellentPoint:
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





