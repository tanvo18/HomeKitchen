//
//  ProductDataModel.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/6/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

protocol ProductDataModelDelegate: class {
  func didRecieveProductUpdate(data: [OrderItem])
  func didFailProductUpdateWithError(error: String)
}

class ProductDataModel {
  
  weak var delegate: ProductDataModelDelegate?
  
  func requestProduct() {
    var products: [OrderItem] = []
    var result: ResultProduct?
    
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    let parameters: Parameters = ["kitchenId" : Helper.kitchenId]
    Alamofire.request("http://ec2-34-201-3-13.compute-1.amazonaws.com:8081/kitchen/products", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
      switch response.result {
      case .success:
        if let json = response.result.value as? [String: Any]{
          result = Mapper<ResultProduct>().map(JSON: json)
          products = result!.orderInfo.products
         
          // Remember order info
          Helper.orderInfo = result!.orderInfo
          // Assign status
          if Helper.orderInfo.id != 0 {
            Helper.status = "in_cart"
          } else {
            Helper.status = "pending"
          }
          
          self.delegate?.didRecieveProductUpdate(data: products)
        }
      case .failure(let error):
        self.delegate?.didFailProductUpdateWithError(error: "\(error)")
      }
      
    }
    
    //    do {
    //      if let file = Bundle.main.url(forResource: "getorder", withExtension: "json") {
    //        let data = try Data(contentsOf: file)
    //        let json = try JSONSerialization.jsonObject(with: data, options: [])
    //        if let object = json as? [String: Any] {
    //          result = Mapper<ResultProduct>().map(JSON: object)
    //          products = result!.orderInfo.products
    //
    //        } else {
    //          print("JSON is invalid")
    //        }
    //      } else {
    //        print("no file")
    //      }
    //      delegate?.didRecieveProductUpdate(data: products)
    //    } catch {
    //      print(error.localizedDescription)
    //    }
  }
}
