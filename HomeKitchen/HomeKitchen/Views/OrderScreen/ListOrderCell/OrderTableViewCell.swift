//
//  OrderTableViewCell.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/7/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit
import Kingfisher

class OrderTableViewCell: UITableViewCell {
  
  @IBOutlet weak var foodImageView: UIImageView!
  
  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var typeLabel: UILabel!
  
  @IBOutlet weak var priceLabel: UILabel!
  
  @IBOutlet weak var buttonMinus: UIButton!
  
  @IBOutlet weak var buttonPlus: UIButton!
  
  @IBOutlet weak var quantitiesLabel: UILabel!
  
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
    downloadProductImage(imageUrl: product.imageUrl)
    
  }
  
  // MARK: download image with url
  func downloadProductImage(imageUrl: String) {
    let url = URL(string: imageUrl)!
    ImageDownloader.default.downloadImage(with: url, options: [], progressBlock: nil) {
      (image, error, url, data) in
      self.foodImageView.image = image
    }
  }
  
}
