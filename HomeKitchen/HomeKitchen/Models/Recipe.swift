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
  
  var id: Int = 0
  var direction: String = ""
  var type: String = ""
  
  init() {
    
  }
  
  required convenience init?(map: Map) {
    self.init()
  }
  
  convenience init(direction: String,type: String) {
    self.init()
    self.direction = direction
    self.type = type
  }
  
  // Mappable
  func mapping(map: Map) {
    direction         <- map["direction"]
    type              <- map["type"]
  }
}
