//
//  ResultProductReviews.swift
//  HomeKitchen
//
//  Created by Tan Vo on 11/4/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

class ResultProductReviews: Mappable {
  
  var reviews: [Review] = []
  
  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    reviews <- map["product_reviews"]
  }
}
