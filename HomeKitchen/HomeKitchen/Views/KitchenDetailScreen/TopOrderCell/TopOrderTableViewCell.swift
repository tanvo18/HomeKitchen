//
//  TopOrderTableViewCell.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/6/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit
import Kingfisher
import Cosmos

class TopOrderTableViewCell: UITableViewCell {
  
  @IBOutlet weak var foodImageView: UIImageView!
  
  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var typeLabel: UILabel!
  
  @IBOutlet weak var priceLabel: UILabel!
  
  @IBOutlet weak var separatorView: UIView!
  
  @IBOutlet weak var starRatingView: CosmosView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  // MARK: configure view cell
  func configureWithItem(product: Product) {
    nameLabel.text = product.name
    typeLabel.text = product.type
    priceLabel.text = "\(product.price)"
    starRatingView.settings.fillMode = .half
    if product.point <= 0 {
      starRatingView.isHidden = true
    } else {
      starRatingView.rating = product.point
    }
    downloadProductImage(imageUrl: product.imageUrl)
  }
  
  // MARK: download image with url
  func downloadProductImage(imageUrl: String) {
    if imageUrl != "" {
      let url = URL(string: imageUrl)!
      ImageDownloader.default.downloadImage(with: url, options: [], progressBlock: nil) {
        (image, error, url, data) in
        self.foodImageView.image = image
      }
    }
  }
}
