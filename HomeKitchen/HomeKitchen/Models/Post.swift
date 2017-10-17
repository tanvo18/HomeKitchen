//
//  Post.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/13/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

class Post: Mappable {
  
  var id: Int = 0
  var username: String = ""
  var status: String = ""
  var kitchen: Kitchen?
  var requestDate: String = ""
  var deliveryTime: String = ""
  var deliveryDate: String = ""
  var message: String = ""
  var kitchenId: Int = 0
  var contactInfo: ContactInfo?
  var postItems: [PostItem] = []
  var answers: [Answer] = []
  
  init() {}
  
  required convenience init?(map: Map) {
    self.init()
  }
  
  // Mappable
  func mapping(map: Map) {
    id                   <- map["id"]
    username             <- map["username"]
    status               <- map["status"]
    kitchen              <- map["kitchen"]
    requestDate          <- map["req_date"]
    deliveryTime         <- map["delivery_time"]
    deliveryDate         <- map["delivery_date"]
    message              <- map["message"]
    kitchenId            <- map["kitchen_id"]
    contactInfo          <- map["contact_information"]
    postItems            <- map["post_items"]
    answers              <- map["answers"]
  }
  
}
