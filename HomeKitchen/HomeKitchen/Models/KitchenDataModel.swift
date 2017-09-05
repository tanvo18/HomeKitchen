//
//  KitchenDataModel.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/5/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol KitchenDataModelDelegate: class {
  func didRecieveKitchenUpdate(data: [Kitchen])
  func didFailKitchenUpdateWithError(error: String)
}

class KitchenDataModel {
  
  weak var delegate: KitchenDataModelDelegate?
  
  func requestKitchen() {
    var kitchens: [Kitchen] = []
    var result: ResultKitchen?
    
    do {
      if let file = Bundle.main.url(forResource: "getrestaurants", withExtension: "json") {
        let data = try Data(contentsOf: file)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        if let object = json as? [String: Any] {
          print("====bingo")
          result = Mapper<ResultKitchen>().map(JSON: object)
          kitchens = result!.kitchens
          
        } else {
          print("JSON is invalid")
        }
      } else {
        print("no file")
      }
      delegate?.didRecieveKitchenUpdate(data: kitchens)
    } catch {
      print(error.localizedDescription)
    }
  }
}
