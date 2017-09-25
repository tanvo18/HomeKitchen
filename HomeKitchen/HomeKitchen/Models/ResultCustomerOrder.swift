//
//  ResultCustomerOrder.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/25/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

// Get customer's orders
class ResultCustomerOrder: Mappable {
  
  var orderInfos: [OrderInfo] = []
  
  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    orderInfos <- map["orders"]
  }
}
