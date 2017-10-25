//
//  PostDataModel.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/17/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class PostDataModel {
  
  // Get list post of kitchen
  // Using responseJSON
  func getKitchenPosts(completion: @escaping(_ posts: [Post]?,_ error: Error?) -> Void) {
    var posts: [Post] = []
    var result: ResultPosts?
    
    let url = NetworkingService.baseURLString + "kitchens/posts"
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    
    Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
      switch response.result {
      case .success:
        if let json = response.result.value as? [String: Any] {
          result = Mapper<ResultPosts>().map(JSON: json)
          if let result = result {
            posts = result.posts
            completion(posts,nil)
          }
        }
      case .failure(let error):
        completion(nil,error)
      }
    }
  }
  
  // Get list post of customer
  // Using responseJSON
  func getCustomerPosts(completion: @escaping(_ posts: [Post]?,_ error: Error?) -> Void) {
    var posts: [Post] = []
    var result: ResultPosts?
    
    let url = NetworkingService.baseURLString + "users/posts"
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    
    Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
      switch response.result {
      case .success:
        if let json = response.result.value as? [String: Any] {
          result = Mapper<ResultPosts>().map(JSON: json)
          if let result = result {
            posts = result.posts
            completion(posts,nil)
          }
        }
      case .failure(let error):
        completion(nil,error)
      }
    }
  }
}
