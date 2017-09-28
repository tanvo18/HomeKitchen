//
//  OrderItem.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/11/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

class OrderItem: Mappable {
  
  var quantity: Int = 0
  var product: Product = Product()
  // orderItemPrice is product price X quantity = price of OrderItem
  var orderItemPrice: Int = 0
  
  init() {}
  
  required convenience init?(map: Map) {
    self.init()
  }
  
  convenience init(quantity: Int = 0, orderItemPrice: Int = 0, product: Product) {
    self.init()
    self.quantity = quantity
    self.product = product
    self.orderItemPrice = orderItemPrice
  }
  
  // Mappable
  func mapping(map: Map) {
    quantity        <- map["quantity"]
    product         <- map["item"]
    orderItemPrice  <- map["price"]
  }
}
