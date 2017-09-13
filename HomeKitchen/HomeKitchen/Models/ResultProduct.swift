//
//  ResultProduct.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/6/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

class ResultProduct: Mappable {
  
  var orderInfo: OrderInfo = OrderInfo()
  
  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    orderInfo <- map["order"]
  }
}
