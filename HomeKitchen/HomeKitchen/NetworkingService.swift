//
//  NetworkingService.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/22/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import Alamofire

class NetworkingService {
  
  static let sharedInstance = NetworkingService()
  
  private init() {
  }
  
  static var baseURLString:String {
    return "http://ec2-34-201-3-13.compute-1.amazonaws.com:8081/"
  }
  
  // Post Json to get Authorization, we have to use responseString to get header
  func getAuthorizationFromServer(username: String, password: String, facebookToken: String, completion: @escaping(_ token: String?,_ error: Error?) -> Void ) {
    let parameters: Parameters = ["username" : username,
                                  "password" : password,
                                  "token" : facebookToken]
    let url = NetworkingService.baseURLString + "login"
    Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString { response in
      switch response.result {
      case .success:
        if let authorizationToken = response.response?.allHeaderFields["Authorization"] as? String {
          completion(authorizationToken,nil)
        }
      case .failure(let error):
        completion(nil,error)
      }
    }
  }
  
  // Using responseString instead of responseJSON
  // Send order to server
  func sendOrder(contact: ContactInfo, orderDate: String, deliveryDate: String, deliveryTime: String,
                 kitchenId: Int, orderedItems: [OrderItem], completion: @escaping (_ error: Error?) -> Void) {
    let url = NetworkingService.baseURLString + "order"
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    
    let  parameters: Parameters = ["contact_information" : contact.toJSON(),
                                   "order_date": orderDate,
                                   "delivery_time" : deliveryTime,
                                   "status" : Helper.status,
                                   "delivery_date" : deliveryDate,
                                   "kitchen" : ["id" : Helper.kitchenId],
                                   "products" : orderedItems.toJSON()
    ]
    
    Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString { response in
      switch response.result {
      case .success:
        completion(nil)
      case .failure(let error):
        completion(error)
      }
    }
  }
  
  // Using responseString instead of responseJSON
  // Update order to server when order is not a new order
  func updateOrder(id: Int,contact: ContactInfo, orderDate: String, deliveryDate: String, deliveryTime: String, orderedItems: [OrderItem], completion: @escaping (_ error: Error?) -> Void) {
    let url = NetworkingService.baseURLString + "order"
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    
    // Change Helper status for checkout
    Helper.status = "pending"
    
    let  parameters: Parameters = ["id" : id,
                                   "contact_information" : contact.toJSON(),
                                   "order_date": orderDate,
                                   "delivery_time" : deliveryTime,
                                   "status" : Helper.status,
                                   "delivery_date" : deliveryDate,
                                   "products" : orderedItems.toJSON()
    ]
    
    Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString { response in
      switch response.result {
      case .success:
        completion(nil)
      case .failure(let error):
        completion(error)
      }
      
    }
  }
}