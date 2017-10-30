//
//  ResultReviews.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/30/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

class ResultReviews: Mappable {
  
  var reviews: [Review] = []
  
  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    reviews <- map["reviews"]
  }
}
