//
//  PostItem.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/13/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

class PostItem: Mappable {
  
  var id: Int = 0
  var productName: String = ""
  // This url for post to server
  var imageUrl: String = ""
  var quantity: Int = 0
  // This url for saving url from photoPicker
  var selectedImageUrl: URL!
  // Data of image
  var data: Data?
  var price: Int = 0
  // Check if product in post have image
  var didPickImage: Bool = false
  
  init() {}
  
  required convenience init?(map: Map) {
    self.init()
  }
  
  // Mappable
  func mapping(map: Map) {
    id               <- map["id"]
    productName      <- map["product_name"]
    imageUrl         <- map["image_url"]
    quantity         <- map["quantity"]
  }
}
