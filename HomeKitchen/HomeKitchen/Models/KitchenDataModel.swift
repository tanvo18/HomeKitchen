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
    let url = NetworkingService.baseURLString + "kitchen/list"
    Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
      switch response.result {
      case .success:
        if let json = response.result.value as? [String: Any]{
          result = Mapper<ResultKitchen>().map(JSON: json)
          kitchens = result!.kitchens
          self.delegate?.didRecieveKitchenUpdate(data: kitchens)
        }
      case .failure(let error):
        self.delegate?.didFailKitchenUpdateWithError(error: "\(error)")
      }
      
    }
  }
}
