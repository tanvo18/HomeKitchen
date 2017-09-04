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
  var birthday: Date = Date()
  var gender: Int = 0
  var phoneNumber: String = ""
  var role: String = ""
  var name: String = ""
  
  init() {
    
  }
  
  required convenience init?(map: Map) {
    self.init()
  }
  
  convenience init(username: String, birthday: Date, gender: Int, phoneNumber: String, role: String, name: String) {
    self.init()
    self.username = username
    self.birthday = birthday
    self.gender = gender
    self.phoneNumber = phoneNumber
    self.role = role
    self.name = name
  }
  
  func mapping(map: Map) {
    
    username          <- map["username"]
    birthday          <- map["birthday"]
    gender            <- map["gender"]
    phoneNumber       <- map["phoneNumber"]
    role              <- map["role"]
    name              <- map["name"]
    
  }
}
