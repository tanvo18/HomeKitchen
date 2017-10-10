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
    
    var products: [Product] = []
    var cart: OrderInfo? = OrderInfo()
    var orderItems: [OrderItem] = []
    var result: ResultOrderInfo?
    
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    let kitchenId = Helper.kitchenId
    let url = NetworkingService.baseURLString + "kitchens/\(kitchenId)/products"
    Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
      switch response.result {
      case .success:
        if let json = response.result.value as? [String: Any]{
          result = Mapper<ResultOrderInfo>().map(JSON: json)
          guard let result = result else {
            return
          }
          products = result.kitchen!.products
          cart = result.kitchen?.cart
          if cart == nil {
            print("====nil cart")
            for product in products {
              let orderItem = OrderItem(product: product)
              orderItems.append(orderItem)
            }
            
            Helper.orderInfo.status = "pending"
          } else {
            // Save cart
            Helper.orderInfo = cart!
            Helper.orderInfo.status = "in_cart"
            
            orderItems = (cart?.products)!
            print("orderItems count:\(orderItems.count)")
            // compare id to add remain product to order items
            for product in products {
              if !self.isMatchProductId(id: product.id, orderItems: orderItems) {
                let orderItem = OrderItem(product: product)
                orderItems.append(orderItem)
              }
            }
          }
          
          self.delegate?.didRecieveProductUpdate(data: orderItems)
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
  
  func isMatchProductId(id: Int,orderItems: [OrderItem]) -> Bool {
    for item in orderItems {
      if id == item.product?.id{
        return true
      }
    }
    return false
  }
}
