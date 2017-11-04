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
  func getAuthorizationFromServer(username: String, password: String, facebookToken: String, loginMethod: String, completion: @escaping(_ token: String?,_ error: Error?) -> Void ) {
    
    var parameters: Parameters = [:]
    if loginMethod == Helper.LOGIN_BY_FACEBOOK {
      parameters = ["username" : username,
      "password" : password,
      "token" : facebookToken]
    } else if loginMethod == Helper.LOGIN_BY_NORMAL_USER {
      // parameters don't have token
      parameters = ["username" : username,
                    "password" : password ]
    }
    
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
  
  // Edit ContactInfo
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
  
  // Edit User Infomation
  func editUserInfo(birthday: String, gender: Int, name: String, phoneNumber: String, contactInfos: [ContactInfo], completion: @escaping (_ message: String?, _ error: Error?) -> Void) {
    let url = NetworkingService.baseURLString + "users"
    
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    
    let  parameters: Parameters = ["birthday": birthday,
                                   "gender": gender,
                                   "name": name,
                                   "phone_number": phoneNumber,
                                   "contact_information": contactInfos.toJSON()
    ]
    
    print("====param: \(parameters.description)")
    
    Alamofire.request(url, method: .put,parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseString
      { response in
        switch response.result {
        case .success:
          if let message = response.result.value {
            print("====message \(message)")
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
    let url = NetworkingService.baseURLString + "users/suggestions?suggestionId=\(suggestionId)&isAccepted=\(isAccepted)"
    
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    
    Alamofire.request(url, method: .put, encoding: URLEncoding.default, headers: headers).validate(statusCode: 200..<300).responseString { response in
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
  func responseOrder(orderId: Int, status: String, completion: @escaping(_ message: String?, _ error: Error?) -> Void) {
    let url = NetworkingService.baseURLString + "kitchens/orders?orderId=\(orderId)&status=\(status)"
    
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    
    Alamofire.request(url, method: .put, encoding: URLEncoding.default, headers: headers).validate(statusCode: 200..<300).responseString { response in
      
      switch response.result {
      case .success:
        print("====message \(response.result.value!)")
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
   This function use for chef send Answer
   */
  func sendAnswer(postId: Int, deliveryDate: String, deliveryTime: String, answerDetails: [AnswerDetail], completion: @escaping (_ error: Error?) -> Void) {
    let url = NetworkingService.baseURLString + "kitchens/answers"
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    
    let  parameters: Parameters = [ "post_id" : postId,
                                    "delivery_date" : deliveryDate,
                                    "delivery_time" : deliveryTime,
                                    "answer_details" : answerDetails.toJSON()
    ]
    print("====param \(parameters.description)")
    Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseString { response in
      switch response.result {
      case .success:
        print("====message \(response.result.value!)")
        completion(nil)
      case .failure(let error):
        completion(error)
      }
    }
  }
  
  /*
   This function use for chef decline post request
   */
  func declinePost(postId: Int, completion: @escaping(_ message: String?, _ error: Error?) -> Void) {
    let url = NetworkingService.baseURLString + "kitchens/posts/\(postId)"
    
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    
    Alamofire.request(url, method: .put, encoding: URLEncoding.default, headers: headers).validate(statusCode: 200..<300).responseString { response in
      switch response.result {
      case .success:
        print("====message \(response.result.value!)")
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
   This function use for customer responses answer
   */
  func responseAnswer(answerId: Int, isAccepted: Bool, acceptedDate: String, completion: @escaping(_ message: String?, _ error: Error?) -> Void) {
    
    let url = NetworkingService.baseURLString + "users/answers?isAccepted=\(isAccepted)&answerId=\(answerId)&accepted_date=\(acceptedDate)"
    
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    
    Alamofire.request(url, method: .put, encoding: URLEncoding.default, headers: headers).validate(statusCode: 200..<300).responseString { response in
      switch response.result {
      case .success:
        print("====message \(response.result.value!)")
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
  
  // Create kitchen
  func createKitchen(openingTime: String, closingTime: String, kitchenName: String, imageUrl: String, type: String, description: String, createdDate: String, address: Address, completion: @escaping(_ message: String?,_ error: Error?) -> Void) {
    
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
                                  "description" : description,
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
  
  // Edit kitchen
  // Using responseString
  func editKitchen(id: Int, openingTime: String, closingTime: String, kitchenName: String, imageUrl: String, type: String, description: String, address: Address, completion: @escaping(_ message: String?,_ error: Error?) -> Void) {
    
    let url = NetworkingService.baseURLString + "kitchens"
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    
    let parameters: Parameters = ["id" : id,
                                  "open" : openingTime,
                                  "close" : closingTime,
                                  "name" : kitchenName,
                                  "image_url" : imageUrl,
                                  "type" : type,
                                  "description" : description,
                                  "address" : address.toJSON()
    ]
    Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseString { response in
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
  
  // Get kitchen information
  // Using responseJSON
  func getKitchenInfo(completion: @escaping(_ kitchen: Kitchen?,_ error: Error?) -> Void) {
    var kitchen: Kitchen?
    var result: ResultKitchenInfo?
    
    let url = NetworkingService.baseURLString + "kitchens"
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    
    Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
      switch response.result {
      case .success:
        if let json = response.result.value as? [String: Any] {
          result = Mapper<ResultKitchenInfo>().map(JSON: json)
          if let result = result {
            kitchen = result.kitchen
            completion(kitchen,nil)
          }
        }
      case .failure(let error):
        completion(nil,error)
      }
    }
  }
  
  // Create product for kitchen
  func createProduct(productName: String, productPrice: String, type: String, imageUrl: String, status: String, completion: @escaping(_ message: String?,_ error: Error?) -> Void) {
    let url = NetworkingService.baseURLString + "kitchens/products"
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    
    let parameters: Parameters = ["product_price" : productPrice,
                                  "name" : productName,
                                  "type" : type,
                                  "image_url" : imageUrl,
                                  "status" : status
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
  
  // Edit product for Kitchen
  func editProduct(id: Int, productName: String, productPrice: String, type: String, imageUrl: String, status: String, completion: @escaping(_ message: String?,_ error: Error?) -> Void) {
    let url = NetworkingService.baseURLString + "kitchens/products"
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    
    let parameters: Parameters = ["id" : id,
                                  "product_price" : productPrice,
                                  "name" : productName,
                                  "type" : type,
                                  "image_url" : imageUrl,
                                  "status" : status
    ]
    
    Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseString { response in
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
  
  // Delete product for Kitchen
  func deleteProduct(productId: Int, completion: @escaping(_ message: String?,_ error: Error?) -> Void) {
    let url = NetworkingService.baseURLString + "kitchens/products/\(productId)"
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    
    Alamofire.request(url, method: .delete, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseString { response in
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
  
  // Create product for kitchen
  func sendPostRequest(requestDate:String, deliveryDate: String, deliveryTime: String, message: String, kitchenId: Int, contactInfo: ContactInfo, postItems: [PostItem], completion: @escaping(_ message: String?,_ error: Error?) -> Void) {
    let url = NetworkingService.baseURLString + "users/posts"
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    
    let parameters: Parameters = ["req_date" : requestDate,
                                  "delivery_time" : deliveryTime,
                                  "delivery_date" : deliveryDate,
                                  "message" : message,
                                  "kitchen" : ["id" : kitchenId],
                                  "contact_information" : contactInfo.toJSON(),
                                  "post_items" : postItems.toJSON()
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
  
  // Send review of kitchen
  func sendKitchenReview(reviewMessage: String, reviewPoint: Int, kitchenId: Int, completion: @escaping(_ message: String?,_ error: Error?) -> Void) {
    let url = NetworkingService.baseURLString + "kitchens/\(kitchenId)/reviews"
    let headers: HTTPHeaders = [
      "Authorization": Helper.accessToken,
      "Accept": "application/json"
    ]
    
    let parameters: Parameters = ["point" : reviewPoint,
                                  "message" : reviewMessage,
                                  "kitchen" : ["id" : kitchenId]
    ]
    Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseString { response in
      switch response.result {
      case .success:
        if let message = response.result.value {
          print("====message \(message)")
          completion(message,nil)
        }
      case .failure(let error):
        completion(nil,error)
      }
    }
  }
  
  // Sign up
  func signUp(username: String, password: String, completion: @escaping(_ message: String?,_ error: Error?) -> Void) {
    let url = NetworkingService.baseURLString + "register"
    
    let parameters: Parameters = ["username" : username,
                                  "password" : password
    ]
    
    Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).validate(statusCode: 200..<300).responseString { response in
      
      switch response.result {
      case .success:
        if let message = response.result.value {
          print("====message \(message)")
          completion(message,nil)
        }
      case .failure(let error):
        completion(nil,error)
      }
    }
  }
}
