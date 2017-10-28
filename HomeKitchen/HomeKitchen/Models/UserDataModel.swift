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

class UserDataModel {
  
  func getUserInfo(completion: @escaping (_ data: User, _ error: Error?) -> Void) {
    var user: User = User()
    var result: ResultUser?
    
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    let url = NetworkingService.baseURLString + "users"
    Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
      switch response.result {
      case .success:
        if let json = response.result.value as? [String: Any]{
          result = Mapper<ResultUser>().map(JSON: json)
          if let result = result {
            user = result.user
            completion(user,nil)
          }
        }
      case .failure(let error):
        completion(user,error)
      }
    }
  }
}
