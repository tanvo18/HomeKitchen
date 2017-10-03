//
//  SuggestionItem.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/25/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

class SuggestionItem: Mappable {
  
  var id: Int = 0
  var quantity: Int = 0
  var price: Int = 0
  var product: Product?
  
  init() {}
  
  required convenience init?(map: Map) {
    self.init()
  }
  
  convenience init(quantity: Int, price: Int, product: Product) {
    self.init()
    self.quantity = quantity
    self.price = price
    self.product = product
  }
  
  // Mappable
  func mapping(map: Map) {
    id                    <- map["id"]
    quantity              <- map["quantity"]
    price                 <- map["price"]
    product               <- map["item"]
  }
}
