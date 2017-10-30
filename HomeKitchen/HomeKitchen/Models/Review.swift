//
//  Review.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/30/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

class Review: Mappable {
  
  var point: Int = 0
  var message: String = ""
  var user: User?
  
  init() {}
  
  required convenience init?(map: Map) {
    self.init()
  }
  
  // Mappable
  func mapping(map: Map) {
    point            <- map["point"]
    message          <- map["message"]
    user             <- map["user"]
  }
}
