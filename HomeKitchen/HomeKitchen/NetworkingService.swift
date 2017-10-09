//
//  NetworkingService.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/22/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

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
    Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseString { response in
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
  func sendOrder(contact: ContactInfo, orderDate: String, deliveryDate: String, deliveryTime: String, status: String,
                 kitchenId: Int, orderedItems: [OrderItem], completion: @escaping (_ error: Error?) -> Void) {
    let url = NetworkingService.baseURLString + "orders"
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    
    let  parameters: Parameters = ["contact_information" : contact.toJSON(),
                                   "order_date": orderDate,
                                   "delivery_time" : deliveryTime,
                                   "status" : status,
                                   "delivery_date" : deliveryDate,
                                   "kitchen" : ["id" : Helper.kitchenId],
                                   "order_items" : orderedItems.toJSON()
    ]
    
    Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseString { response in
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
  func updateOrder(id: Int,contact: ContactInfo, orderDate: String, deliveryDate: String, deliveryTime: String, status: String, orderedItems: [OrderItem], completion: @escaping (_ error: Error?) -> Void) {
    let url = NetworkingService.baseURLString + "orders"
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    
    let  parameters: Parameters = ["id" : id,
                                   "contact_information" : contact.toJSON(),
                                   "order_date": orderDate,
                                   "delivery_time" : deliveryTime,
                                   "status" : status,
                                   "delivery_date" : deliveryDate,
                                   "order_items" : orderedItems.toJSON()
    ]
    
    Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseString { response in
      switch response.result {
      case .success:
        completion(nil)
      case .failure(let error):
        completion(error)
      }
      
    }
  }
  
  // Delete order
  func deleteOrder(id: Int,completion: @escaping (_ error: Error?) -> Void) {
    let url = NetworkingService.baseURLString + "orders" + "/" + "\(id)"
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    Alamofire.request(url, method: .delete, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseString
      { response in
        switch response.result {
        case .success:
          completion(nil)
        case .failure(let error):
          completion(error)
        }
    }
  }
  
  // Edit order
  func editContactInfo(birthday: String, gender: Int, name: String, phoneNumber: String, contactInfo: ContactInfo, completion: @escaping (_ message: String?, _ error: Error?) -> Void) {
    let url = NetworkingService.baseURLString + "users"
    
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    
    print("contact \(contactInfo.toJSON())")
    
    let  parameters: Parameters = ["birthday": birthday,
                                   "gender": gender,
                                   "name": name,
                                   "phone_number": phoneNumber,
                                   "contact_information": [contactInfo.toJSON()]
    ]
    
    Alamofire.request(url, method: .put,parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseString
      { response in
        switch response.result {
        case .success:
          if let message = response.result.value {
            completion(message,nil)
          }
        case .failure(let error):
          completion(nil,error)
        }
    }
  }
  
  // Using responseString instead of responseJSON
  func sendSuggestion(orderId: Int,deliveryTime: String, deliveryDate: String, totalPrice: Int, suggestionItems: [SuggestionItem], completion: @escaping (_ error: Error?) -> Void) {
    let url = NetworkingService.baseURLString + "users/suggestions"
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    
    let  parameters: Parameters = [ "order_id": orderId,
                                    "delivery_time": deliveryTime,
                                    "delivery_date": deliveryDate,
                                    "total_price": totalPrice,
                                    "suggestion_items": suggestionItems.toJSON()
    ]
    
    Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseString { response in
      switch response.result {
      case .success:
        completion(nil)
      case .failure(let error):
        completion(error)
      }
    }
  }
  
  /*
   This function use for customer response accept or decline suggestion in order
   */
  func responseSuggestion(suggestionId: Int, isAccepted: Bool, completion: @escaping(_ message: String?, _ error: Error?) -> Void) {
    let url = NetworkingService.baseURLString + "users/suggestions"
    
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    
    let  parameters: Parameters = [ "isAccepted" : isAccepted,
                                    "suggestionId" : suggestionId
    ]
    
    Alamofire.request(url, method: .put, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate(statusCode: 200..<300).responseString { response in
      switch response.result {
      case .success:
        if let message = response.result.value {
          completion(message,nil)
        } else {
          completion(nil, nil)
        }
      case .failure(let error):
        completion(nil,error)
      }
    }
  }
  
  /*
   This function use for chef response kitchen's order
   */
  func responseOrder(orderId: Int, isAccepted: Bool, completion: @escaping(_ message: String?, _ error: Error?) -> Void) {
    let url = NetworkingService.baseURLString + "kitchens/orders"
    
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    
    let  parameters: Parameters = [ "isAccepted" : isAccepted,
                                    "orderId" : orderId
    ]
    
    Alamofire.request(url, method: .put, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate(statusCode: 200..<300).responseString { response in
      switch response.result {
      case .success:
        if let message = response.result.value {
          completion(message,nil)
        } else {
          completion(nil, nil)
        }
      case .failure(let error):
        completion(nil,error)
      }
    }
  }
  
  // Create kitchen, we have to use responseString to get header
  func createKitchen(openingTime: String, closingTime: String, kitchenName: String, imageUrl: String, type: String, createdDate: String, address: Address, completion: @escaping(_ message: String?,_ error: Error?) -> Void ) {
    
    let url = NetworkingService.baseURLString + "kitchens"
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    
    let parameters: Parameters = ["open" : openingTime,
                                  "close" : closingTime,
                                  "name" : kitchenName,
                                  "image_url" : imageUrl,
                                  "type" : type,
                                  "created_date" : createdDate,
                                  "address" : address.toJSON()
    ]
    Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseString { response in
      switch response.result {
      case .success:
        if let message = response.result.value {
          print("====message \(message)")
          completion(message,nil)
        } else {
          completion(nil, nil)
        }
      case .failure(let error):
        completion(nil,error)
      }
    }
  }
}
