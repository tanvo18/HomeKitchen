//
//  UserDataModel.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/19/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

protocol UserDataModelDelegate: class {
  func didRecieveUserUpdate(data: User)
  func didFailUserUpdateWithError(error: String)
}

class UserDataModel {
  weak var delegate: UserDataModelDelegate?
  func requestUserInfo() {
    var user: User = User()
    var result: ResultUser?
    
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    Alamofire.request("http://ec2-34-201-3-13.compute-1.amazonaws.com:8081/user", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
      switch response.result {
      case .success:
        print("====result User")
        if let json = response.result.value as? [String: Any]{
          result = Mapper<ResultUser>().map(JSON: json)
          user = result!.user
          
          print("====info \(user.contactInformations.count)")
          
          self.delegate?.didRecieveUserUpdate(data: user)
        }
      case .failure(let error):
        self.delegate?.didFailUserUpdateWithError(error: "\(error)")
      }
      
    }
  }
}
