//
//  ResultUser.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/19/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

class ResultUser: Mappable {
  var user: User = User()
  
  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    user <- map["user"]
  }
}
