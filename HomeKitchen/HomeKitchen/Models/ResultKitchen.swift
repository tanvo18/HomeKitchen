//
//  ResultKitchen.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/5/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

class ResultKitchen: Mappable {
  var kitchens: [Kitchen] = []
  
  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    kitchens <- map["kitchens"]
  }
}
