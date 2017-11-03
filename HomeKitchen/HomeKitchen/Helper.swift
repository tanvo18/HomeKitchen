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
  static var districtLocations = [["Ba Đình","Hoàn Kiếm","Hai Bà Trưng","Đống Đa","Tây Hồ","Cầu Giấy"],["Hải Châu","Hoà Vang","Cẩm Lệ","Liên Chiểu","Ngũ Hành Sơn","Sơn Trà","Thanh Khê","Hoàng Sa"],["Quận 1","Quận 2","Quận 3","Quận 4","Quận 5","Quận 6","Quận 7","Quận 8","Quận 9","Quận 10","Quận 11","Quận 12","Bình Tân","Bình Thạnh","Gò Vấp","Phú Nhuận","Tân Bình","Tân Phú","Thủ Đức"]]
  static var cityLocations: [String] = ["Hà Nội","Đà Nẵng","TP.Hồ Chí Minh"]
  static let defaultImageUrl = "https://s3.amazonaws.com/demouploadimage/photoalbum.png"
  // Image for section 1 CreateKitchenViewCell
  static let createKitchenCellSection1 = ["home-line","type-line","location-line","phone-line"]
  // Image for section 2 CreateKitchenViewCell
  static let createKitchenCellSection2 = ["clock-line"]
  static let USER_DEFAULT_AUTHEN_TOKEN = "user_auth_token"
  static let USER_DEFAULT_USERNAME = "username"
}
