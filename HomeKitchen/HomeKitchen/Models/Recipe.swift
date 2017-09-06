//
//  Recipe.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/6/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

class Recipe: Mappable {
  
  var direction: String = ""
  var type: String = ""
  var ingredients: [Ingredient] = []
  
  init() {
    
  }
  
  required convenience init?(map: Map) {
    self.init()
  }
  
  convenience init(direction: String, type: String, ingredients: [Ingredient]) {
    self.init()
    self.direction = direction
    self.type = type
    self.ingredients = ingredients
  }
  
  // Mappable
  func mapping(map: Map) {
    direction                <- map["direction"]
    type                     <- map["type"]
    ingredients              <- map["ingredients"]
  }
}