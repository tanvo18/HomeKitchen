//
//  ResultOrderInfo.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/24/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

// Get customer's order (customer's Cart) when click to restaurant's detail
class ResultOrderInfo: Mappable {
  
  var orderInfo: OrderInfo = OrderInfo()
  
  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    orderInfo <- map["order"]
  }
}

