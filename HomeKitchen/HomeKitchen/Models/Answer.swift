//
//  Answer.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/17/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

class Answer: Mappable {
  
  var deliveryTime: String = ""
  var deliveryDate: String = ""
  var totalPrice: Int = 0
  var status: String = ""
  var answerDetails: [AnswerDetail] = []
  
  init() {}
  
  required convenience init?(map: Map) {
    self.init()
  }
  
  // Mappable
  func mapping(map: Map) {
    deliveryTime             <- map["delivery_time"]
    deliveryDate             <- map["delivery_date"]
    totalPrice               <- map["total_price"]
    status                   <- map["status"]
    answerDetails            <- map["answer_details"]
  }

}
