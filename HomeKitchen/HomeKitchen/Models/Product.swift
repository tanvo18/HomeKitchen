//
//  Product.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/6/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

class Product: Mappable {
  
  var id: Int = 0
  var price: Int = 0
  var totalOrderAmount: Int = 0
  var type: String = ""
  var imageUrl: String = ""
  var name: String = ""
  var recipe: Recipe?
  
  init() {}
  
  required convenience init?(map: Map) {
    self.init()
  }
  
  // Mappable
  func mapping(map: Map) {
    id                       <- map["id"]
    price                    <- map["product_price"]
    totalOrderAmount         <- map["order_amt"]
    type                     <- map["type"]
    imageUrl                 <- map["image_url"]
    name                     <- map["name"]
    recipe                   <- map["recipe"]
  }
}
