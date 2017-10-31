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
  static var districtLocations: [String] = ["Hải Châu","Hoà Vang","Cẩm Lệ","Liên Chiểu","Ngũ Hành Sơn","Sơn Trà","Thanh Khê","Hoàng Sa"]
  static let defaultImageUrl = "https://s3.amazonaws.com/demouploadimage/photoalbum.png"
  // Image for section 1 CreateKitchenViewCell
  static let createKitchenCellSection1 = ["home-line","type-line","location-line","phone-line"]
  // Image for section 2 CreateKitchenViewCell
  static let createKitchenCellSection2 = ["clock-line"]
  static let USER_DEFAULT_AUTHEN_TOKEN = "user_auth_token"
}
