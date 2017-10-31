//
//  CreateReviewViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/31/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit
import Cosmos

class CreateReviewViewController: UIViewController {
  
  @IBOutlet weak var reviewTextView: UITextView!
  
  @IBOutlet weak var ratingView: CosmosView!
  let PLACEHOLDER_TEXT = "chia sẻ suy nghĩ về bếp ăn này"
  // Right button in navigation bar
  var rightButtonItem: UIBarButtonItem = UIBarButtonItem()
  var ratingPoint:Int = 3
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    reviewTextView.delegate = self
    reviewTextView.text = PLACEHOLDER_TEXT
    reviewTextView.textColor = .lightGray
    // Rating Point
    // Attention: we don't make function tapOutside to close keyboard when using ratingView, because it will make 
    // ratingView work wrong (can not click to rate)
    createRatingView()
    settingRightButtonItem()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

// MARK: TextField Delegate
extension CreateReviewViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView)
  {
    if (textView.text == PLACEHOLDER_TEXT)
    {
      textView.text = ""
      textView.textColor = .black
    }
    textView.becomeFirstResponder() //Optional
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = PLACEHOLDER_TEXT
      textView.textColor = UIColor.lightGray
    }
  }
}

// MARK: Function
extension CreateReviewViewController {
  
  func settingRightButtonItem() {
    self.rightButtonItem = UIBarButtonItem.init(
      title: "Đăng",
      style: .done,
      target: self,
      action: #selector(rightButtonAction(sender:))
    )
    self.navigationItem.rightBarButtonItem = rightButtonItem
  }
  
  func rightButtonAction(sender: UIBarButtonItem) {
    if checkNotNil() {
      let reviewMessage = reviewTextView.text
      NetworkingService.sharedInstance.sendKitchenReview(reviewMessage: reviewMessage!, reviewPoint: self.ratingPoint, kitchenId: Helper.kitchenId) {
        [unowned self] (message, error) in
        if error != nil {
          self.alertError(message: "Gửi bình luận thất bại")
        } else {
          self.alert(title: "Thông báo", message: "Thành công")
        }
      }
    } else {
      self.alertError(message: "Bạn phải nhập bình luận")
    }
  }
  
  func checkNotNil() -> Bool {
    if  reviewTextView.text.isEmpty {
      return false
    } else {
      return true
    }
  }
  
  func createRatingView() {
    ratingView.didFinishTouchingCosmos = { rating in
      print("====rating \(rating)")
      self.ratingPoint = Int(rating)
    }
  }

}
