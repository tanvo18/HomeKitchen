//
//  ContactInfo.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/19/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

class ContactInfo: Mappable {
  
  var id: Int = 0
  var name: String = ""
  var phoneNumber: String = ""
  var address: String = ""
  
  init() {}
  
  required convenience init?(map: Map) {
    self.init()
  }
  
  convenience init(id: Int, name: String, phoneNumber: String, address: String) {
    self.init()
    self.id = id
    self.name = name
    self.phoneNumber = phoneNumber
    self.address = address
  }
  
  func mapping(map: Map) {
    id            <- map["id"]
    name          <- map["name"]
    phoneNumber   <- map["phone_number"]
    address       <- map["address"]
  }
}
