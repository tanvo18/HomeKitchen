//
//  Suggestion.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/25/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

class Suggestion: Mappable {
  
  var id: Int = 0
  var status: String = ""
  var deliveryTime: String = ""
  var deliveryDate: String = ""
  var totalPrice: Int = 0
  var suggestItems: [SuggestionItem] = []
  
  init() {}
  
  required convenience init?(map: Map) {
    self.init()
  }
  
  // Mappable
  func mapping(map: Map) {
    id                        <- map["id"]
    status                    <- map["status"]
    deliveryTime              <- map["delivery_time"]
    deliveryDate              <- map["delivery_date"]
    totalPrice                <- map["total_price"]
    suggestItems              <- map["suggestion_items"]
  }
}
