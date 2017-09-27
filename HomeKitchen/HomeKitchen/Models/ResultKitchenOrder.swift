//
//  ResultKitchenOrder.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/27/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

class ResultKitchenOrder {
  
  var orderInfos: [OrderInfo] = []
  
  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    orderInfos <- map["orders"]
  }
}
