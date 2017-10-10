//
//  ResultKitchenInfo.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/10/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

class ResultKitchenInfo: Mappable {
  var kitchen: Kitchen?
  
  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    kitchen <- map["kitchen"]
  }
}
