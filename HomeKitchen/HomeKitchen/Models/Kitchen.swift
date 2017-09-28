//
//  Kitchen.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/5/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

class Kitchen: Mappable {
  
  var id: Int = 0
  var open: String = ""
  var close: String = ""
  var name: String = ""
  var imageUrl: String = ""
  var point: Double = 0.0
  var address: Address = Address()
  var cart: OrderInfo = OrderInfo()
  var products: [Product] = []
  
  init() {}
  
  required convenience init?(map: Map) {
    self.init()
  }
  
  // Mappable
  func mapping(map: Map) {
    id              <- map["id"]
    open            <- map["open"]
    close           <- map["close"]
    name            <- map["name"]
    imageUrl        <- map["image_url"]
    point           <- map["point"]
    address         <- map["address"]
    cart            <- map["cart"]
    products        <- map["products"]
  }
}
