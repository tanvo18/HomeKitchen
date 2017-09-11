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
  var type: String = ""
  var imageUrl: String = ""
  var name: String = ""
  var recipe: Recipe = Recipe()
  
  init() {}
  
  required convenience init?(map: Map) {
    self.init()
  }
  
  convenience init(id: Int, price: Int, type: String, imageUrl: String, name: String, recipe: Recipe) {
    self.init()
    self.id = id
    self.price = price
    self.type = type
    self.imageUrl = imageUrl
    self.name = name
    self.recipe = recipe
  }
  
  // Mappable
  func mapping(map: Map) {
    id            <- map["id"]
    price         <- map["price"]
    type          <- map["type"]
    imageUrl      <- map["imageUrl"]
    name          <- map["name"]
    recipe        <- map["recipe"]
  }
}
