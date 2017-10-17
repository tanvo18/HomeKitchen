//
//  PostDetailTableViewCell.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/17/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit
import Kingfisher

class PostDetailTableViewCell: UITableViewCell {
  
  // MARK: IBOutlet
  @IBOutlet weak var foodImageView: UIImageView!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var quantityLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configureWithItem(item: PostItem) {
    productNameLabel.text = item.productName
    quantityLabel.text = "\(item.quantity)"
    downloadImage(imageUrl: item.imageUrl)
  }
  
  // MARK: download image with url
  func downloadImage(imageUrl: String) {
    let url = URL(string: imageUrl)!
    ImageDownloader.default.downloadImage(with: url, options: [], progressBlock: nil) {
      (image, error, url, data) in
      self.foodImageView.image = image
    }
  }
  
}
