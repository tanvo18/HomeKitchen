//
//  Address.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/5/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

class Address: Mappable {
  
  var city: String = ""
  var district: String = ""
  var address: String = ""
  var phoneNumber: String = ""
  
  init() {}
  
  required convenience init?(map: Map) {
    self.init()
  }
  
  convenience init(city: String, district: String, address: String, phoneNumber: String) {
    self.init()
    self.city = city
    self.district = district
    self.address = address
    self.phoneNumber = phoneNumber
  }
  
  // Mappable
  func mapping(map: Map) {
    city            <- map["city"]
    district        <- map["district"]
    address         <- map["address"]
    phoneNumber     <- map["phonenumber"]
  }
}
