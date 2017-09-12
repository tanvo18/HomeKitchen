//
//  ProductDataModel.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/6/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol ProductDataModelDelegate: class {
  func didRecieveProductUpdate(data: [OrderItem])
  func didFailProductUpdateWithError(error: String)
}

class ProductDataModel {
  
  weak var delegate: ProductDataModelDelegate?
  
  func requestProduct() {
    var products: [OrderItem] = []
    var result: ResultProduct?
    do {
      if let file = Bundle.main.url(forResource: "product", withExtension: "json") {
        let data = try Data(contentsOf: file)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        if let object = json as? [String: Any] {
          result = Mapper<ResultProduct>().map(JSON: object)
          products = result!.products
          
        } else {
          print("JSON is invalid")
        }
      } else {
        print("no file")
      }
      delegate?.didRecieveProductUpdate(data: products)
    } catch {
      print(error.localizedDescription)
    }
  }
}
