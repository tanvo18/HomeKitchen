//
//  User.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/3/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {

  var username: String = ""
  var birthday: String = ""
  var gender: Int = 1
  var phoneNumber: String = ""
  var role: String = ""
  var name: String = ""
  var contactInformations: [ContactInfo] = []
  
  init() {}
  
  required convenience init?(map: Map) {
    self.init()
  }
  
  func mapping(map: Map) {
    username                         <- map["username"]
    birthday                         <- map["birthday"]
    gender                           <- map["gender"]
    phoneNumber                      <- map["phone_number"]
    role                             <- map["role"]
    name                             <- map["name"]
    contactInformations              <- map["contact_information"]
  }
}
