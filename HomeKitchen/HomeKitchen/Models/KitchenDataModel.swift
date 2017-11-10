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
  
  /*
   params for this function
   there are 4 type in this function depend on param status, param which no need on function will be ""
   switch(status)
   case "city":  need param (status,keyword,page)  -> filter by city
   case "category": need param (status,keyword,city,page -> filter by category
   case "review": need param (status,city,page) -> filter by review
   case "name": need param (status,text,city,page) -> search by name of kitchen and city
   **/
  func requestKitchen(status: String, keyword: String, city: String,searchText: String, page: Int) {
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
                                  "text" : searchText,
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
