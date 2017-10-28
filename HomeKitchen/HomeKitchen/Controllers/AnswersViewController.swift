//
//  AnswersViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/20/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class AnswersViewController: UIViewController {
  
  
  @IBOutlet weak var tableView: UITableView!
  var post: Post!
  let reuseableCell = "Cell"
  var index: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "AnswersTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    // Hide Foot view
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    self.settingForNavigationBar(title: "Danh sách trả lời yêu cầu")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}

// MARK: tableView Delegate
extension AnswersViewController: UITableViewDelegate {
}

// MARK: tableView Datasource
extension AnswersViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return post.answers.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! AnswersTableViewCell
    cell.configureWithItem(answer: post.answers[indexPath.row])
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    index = indexPath.row
    performSegue(withIdentifier: "showAnswerDetail", sender: self)
  }
}

extension AnswersViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showAnswerDetail" {
      if let destination = segue.destination as? AnswerDetailViewController {
        destination.answer = post.answers[index]
        destination.deliveryTime = post.deliveryTime
        destination.deliveryDate = post.deliveryDate
        destination.postItem = post.postItems
      }
    }
  }
}
