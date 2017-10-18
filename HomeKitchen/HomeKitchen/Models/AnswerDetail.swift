//
//  AnswerDetail.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/17/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

class AnswerDetail: Mappable {
  
  // retrive info from json
  var postItemId: Int = 0
  var itemPrice: Int = 0
  // provide by matching to postItem
  var productName: String = ""
  var quantity: Int = 0
  
  init() {}
  
  required convenience init?(map: Map) {
    self.init()
  }
  
  convenience init(postItemId: Int, itemPrice: Int) {
    self.init()
    self.postItemId = postItemId
    self.itemPrice = itemPrice
  }
  
  // Mappable
  func mapping(map: Map) {
    postItemId            <- map["post_item_id"]
    itemPrice             <- map["price_item"]
  }
  
}
