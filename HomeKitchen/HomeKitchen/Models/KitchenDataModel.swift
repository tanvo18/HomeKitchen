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
  
  func requestKitchen() {
    var kitchens: [Kitchen] = []
    var result: ResultKitchen?
    
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    let url = NetworkingService.baseURLString + "kitchens/all"
    Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
      switch response.result {
      case .success:
        if let json = response.result.value as? [String: Any]{
          result = Mapper<ResultKitchen>().map(JSON: json)
          if let result = result {
            kitchens = result.kitchens
            self.delegate?.didRecieveKitchenUpdate(data: kitchens)
          }
        }
      case .failure(let error):
        self.delegate?.didFailKitchenUpdateWithError(error: "\(error)")
      }
      
    }
  }
}
