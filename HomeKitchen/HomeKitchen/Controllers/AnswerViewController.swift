//
//  AnswerViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/17/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {
  
  // MARK: IBOutlet
  @IBOutlet weak var acceptedButton: UIButton!
  @IBOutlet weak var declinedButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  
  var answers: [Answer] = []
  var answer: Answer!
  let reuseableCell = "Cell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // get first element in answers
    answer = answers[0]
    // Hide buttons with chef
    if Helper.role == "chef" {
      acceptedButton.isHidden = true
      declinedButton.isHidden = true
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}


