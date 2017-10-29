//
//  ListPostViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/17/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class ListPostViewController: UIViewController {
  
  // MARK: IBOutlet
  @IBOutlet weak var tableView: UITableView!
  let reuseableCell = "Cell"
  var posts: [Post] = [] {
    didSet {
      
      tableView.reloadData()
    }
  }
  let postDataModel = PostDataModel()
  var index: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "ListPostTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    // Hide Foot view
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    var title = ""
    if Helper.role == "chef" {
      title = "Danh sách yêu cầu"
    } else if Helper.role == "customer" {
      title = "Yêu cầu của tôi"
    }
    self.settingForNavigationBar(title: title)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if Helper.role == "chef" {
      // Get list post
      postDataModel.getKitchenPosts() {
        [unowned self] (kitchenPosts,error) in
        if error != nil {
          print(error!)
        } else {
          if let kitchenPosts = kitchenPosts {
            self.posts = kitchenPosts
          }
        }
      }
    } else if Helper.role == "customer" {
      // Get list post
      postDataModel.getCustomerPosts() {
        [unowned self] (kitchenPosts,error) in
        if error != nil {
          print(error!)
        } else {
          if let kitchenPosts = kitchenPosts {
            self.posts = kitchenPosts
          }
        }
      }
    }
    
    
  }
  
}

// MARK: tableView Delegate
extension ListPostViewController: UITableViewDelegate {
}

// MARK: tableView Datasource
extension ListPostViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! ListPostTableViewCell
    cell.configureWithItem(post: posts[indexPath.row], role: Helper.role)
    // Handle button on cell
    cell.notificationButton.tag = indexPath.row
    cell.notificationButton.addTarget(self, action: #selector(self.didTouchNotificationButton), for: .touchUpInside)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.index = indexPath.row
    performSegue(withIdentifier: "showPostDetail", sender: self)
  }
}

// MARK: Function
extension ListPostViewController {
  func didTouchNotificationButton(sender: UIButton) {
    index = sender.tag
    if posts[index].answers.isEmpty {
      let title = "Thông báo"
      let message = "Không có đề nghị nào"
      self.alert(title: title, message: message)
    } else {
      performSegue(withIdentifier: "showListAnswer", sender: self)
    }
    
  }
}

extension ListPostViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showPostDetail" {
      if let destination = segue.destination as? PostDetailViewController {
        destination.post = posts[index]
      }
    } else if segue.identifier == "showListAnswer" {
      if let destination = segue.destination as? AnswersViewController {
        destination.post = posts[index]
      }
    }
  }
}
