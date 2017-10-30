//
//  ReviewDataModel.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/30/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class ReviewDataModel {
  
  // Get reviews of kitchen
  // Using responseJSON
  func getKitchenReviews(kitchenId: Int, completion: @escaping(_ reviews: [Review],_ error: Error?) -> Void) {
    var reviews: [Review] = []
    var result: ResultReviews?
    
    let url = NetworkingService.baseURLString + "kitchens/\(kitchenId)/reviews"
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    
    Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
      switch response.result {
      case .success:
        if let json = response.result.value as? [String: Any] {
          result = Mapper<ResultReviews>().map(JSON: json)
          if let result = result {
            reviews = result.reviews
            completion(reviews,nil)
          }
        }
      case .failure(let error):
        completion(reviews,error)
      }
    }
  }
}
