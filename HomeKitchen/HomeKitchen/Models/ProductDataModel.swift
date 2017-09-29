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

// Get product when click to restaurant's detail
class ProductDataModel {
  
  weak var delegate: ProductDataModelDelegate?
  
  func requestProduct() {
    var products: [OrderItem] = []
    var result: ResultOrderInfo?
    
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    let url = NetworkingService.baseURLString + "kitchen/products"
    let parameters: Parameters = ["kitchenId" : Helper.kitchenId]
    Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
      switch response.result {
      case .success:
        if let json = response.result.value as? [String: Any]{
          result = Mapper<ResultOrderInfo>().map(JSON: json)
          if let result = result {
            products = result.orderInfo.products
            print("====count: \(products.count)")
            // Remember order info
            Helper.orderInfo = result.orderInfo
            // Assign status
            if Helper.orderInfo.id != 0 {
              Helper.orderInfo.status = "in_cart"
            } else {
              Helper.orderInfo.status = "pending"
            }
            
            self.delegate?.didRecieveProductUpdate(data: products)
          }
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
    //          result = Mapper<ResultOrderInfo>().map(JSON: object)
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
