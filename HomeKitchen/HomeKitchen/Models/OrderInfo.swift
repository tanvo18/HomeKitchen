//
//  OrderInfo.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/13/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

class OrderInfo: Mappable {
  var id: Int = 0
  var orderDate: String = ""
  var deliveryTime: String = ""
  var deliveryDate: String = ""
  var totalAmount: Int = 0
  var products: [OrderItem] = []
  
  init() {}
  
  required convenience init?(map: Map) {
    self.init()
  }
  
  // Mappable
  func mapping(map: Map) {
    id                    <- map["id"]
    orderDate             <- map["order_date"]
    deliveryTime             <- map["delivery_time"]
    deliveryDate             <- map["delivery_date"]
    totalAmount           <- map["total_amount"]
    products              <- map["products"]
  }
}
