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
  var type: String = ""
  var description: String = ""
  var imageUrl: String = ""
  var point: Double = 0.0
  var isOpened: Bool = false
  var address: Address?
  var cart: OrderInfo?
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
    type            <- map["type"]
    description     <- map["description"]
    imageUrl        <- map["image_url"]
    point           <- map["point"]
    isOpened        <- map["isopened"]
    address         <- map["address"]
    cart            <- map["cart"]
    products        <- map["products"]
  }
}
