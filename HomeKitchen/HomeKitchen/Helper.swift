//
//  Helper.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/20/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation

class Helper {
  static var accessToken: String = ""
  static var kitchenId: Int = 0
  static var user: User = User()
  static var orderInfo: OrderInfo = OrderInfo()
  // Saving role 
  // Chef has 2 roles: chef and customer
  static var role: String = ""
}
