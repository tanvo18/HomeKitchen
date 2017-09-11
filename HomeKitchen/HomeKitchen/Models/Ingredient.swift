//
//  Ingredient.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/6/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

class Ingredient: Mappable {
  
  var detail: String = ""
  
  init() {}
  
  required convenience init?(map: Map) {
    self.init()
  }
  
  convenience init(detail: String) {
    self.init()
    self.detail = detail
  }
  
  // Mappable
  func mapping(map: Map) {
    detail         <- map["detail"]
  }
}
