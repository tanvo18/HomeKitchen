//
//  CustomerOrderDataModel.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/25/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

protocol CustomerOrderDataModelDelegate: class {
  func didRecieveCustomerOrder(data: [OrderInfo])
  func didFailUpdateWithError(error: String)
}

class CustomerOrderDataModel {
  weak var delegate: CustomerOrderDataModelDelegate?
  
  func requestCustomerOrder() {
    var customerOrders: [OrderInfo] = []
    var result: ResultCustomerOrder?
    
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    let url = NetworkingService.baseURLString + "order"
    Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
      switch response.result {
      case .success:
        if let json = response.result.value as? [String: Any]{
          result = Mapper<ResultCustomerOrder>().map(JSON: json)
          customerOrders = result!.orderInfos
          self.delegate?.didRecieveCustomerOrder(data: customerOrders)
        }
      case .failure(let error):
        self.delegate?.didFailUpdateWithError(error: "\(error)")
      }
      
    }
  }
}
