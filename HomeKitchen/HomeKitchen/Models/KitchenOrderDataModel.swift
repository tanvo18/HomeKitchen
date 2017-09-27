//
//  KitchenOrderDataModel.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/27/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

protocol KitchenOrderDataModelDelegate: class {
  func didRecieveKitchenOrder(data: [OrderInfo])
  func didFailKitchenOrderWithError(error: String)
}

class KitchenOrderDataModel {
  weak var delegate: KitchenOrderDataModelDelegate?
  
  func requestKitchenOrder() {
    var kitchenOrders: [OrderInfo] = []
    var result: ResultKitchenOrder?
    
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    let url = NetworkingService.baseURLString + "kitchen/orders"
    Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
      switch response.result {
      case .success:
        if let json = response.result.value as? [String: Any]{
          result = Mapper<ResultKitchenOrder>().map(JSON: json)
          kitchenOrders = result!.orderInfos
          self.delegate?.didRecieveKitchenOrder(data: kitchenOrders)
        }
      case .failure(let error):
        self.delegate?.didFailKitchenOrderWithError(error: "\(error)")
      }
    }
  }
}
