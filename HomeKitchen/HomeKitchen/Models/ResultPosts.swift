//
//  ResultPosts.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/17/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

class ResultPosts: Mappable {
  
  var posts: [Post] = []
  
  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    posts <- map["posts"]
  }
}
