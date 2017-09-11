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
  
  init() {}
  
  required convenience init?(map: Map) {
    self.init()
  }
  
  convenience init(id: Int, open: String, close: String, name: String, imageUrl: String, point: Double, address: Address) {
    self.init()
    self.id = id
    self.open = open
    self.close = close
    self.name = name
    self.imageUrl = imageUrl
    self.point = point
    self.address = address
  }
  
  // Mappable
  func mapping(map: Map) {
    id              <- map["id"]
    open            <- map["open"]
    close           <- map["close"]
    name            <- map["name"]
    imageUrl        <- map["imageUrl"]
    point           <- map["point"]
    address         <- map["address"]
  }
}
