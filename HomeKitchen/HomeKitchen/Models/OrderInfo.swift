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
  var username: String = ""
  var deliveryTime: String = ""
  var deliveryDate: String = ""
  var contactInfo: ContactInfo = ContactInfo()
  var status: String = ""
  var totalAmount: Int = 0
  var products: [OrderItem] = []
  var suggestions: [Suggestion] = []
  var kitchen: Kitchen = Kitchen()
  
  init() {}
  
  required convenience init?(map: Map) {
    self.init()
  }
  
  // Mappable
  func mapping(map: Map) {
    id                    <- map["id"]
    orderDate             <- map["order_date"]
    username              <- map["username"]
    deliveryTime          <- map["delivery_time"]
    deliveryDate          <- map["delivery_date"]
    contactInfo           <- map["contact_information"]
    status                <- map["status"]
    totalAmount           <- map["total_amount"]
    products              <- map["products"]
    suggestions           <- map["suggestions"]
    kitchen               <- map["kitchen"]
  }
}
