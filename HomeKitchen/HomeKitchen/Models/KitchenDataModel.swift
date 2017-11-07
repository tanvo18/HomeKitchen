//
//  KitchenDataModel.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/5/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

protocol KitchenDataModelDelegate: class {
  func didRecieveKitchenUpdate(data: [Kitchen])
  func didFailKitchenUpdateWithError(error: String)
}

class KitchenDataModel {
  
  weak var delegate: KitchenDataModelDelegate?
  
  func requestKitchen(status: String, keyword: String, city: String, page: Int) {
    var kitchens: [Kitchen] = []
    var result: ResultKitchen?
    
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    let url = NetworkingService.baseURLString + "kitchens/filter"
    
    let parameters: Parameters = ["status" : status,
                                  "key_word" : keyword,
                                  "city" : city,
                                  "page" : page
    ]
    
    Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
      switch response.result {
      case .success:
        if let json = response.result.value as? [String: Any]{
          result = Mapper<ResultKitchen>().map(JSON: json)
          if let result = result {
            // Receive all kitchens on server
            let allKitchens = result.kitchens
            // Filter valid kitchen which is opened
            for kitchen in allKitchens {
              if kitchen.isOpened {
                 kitchens.append(kitchen)
              }
            }
            self.delegate?.didRecieveKitchenUpdate(data: kitchens)
          }
        }
      case .failure(let error):
        self.delegate?.didFailKitchenUpdateWithError(error: "\(error)")
      }
      
    }
  }
}
