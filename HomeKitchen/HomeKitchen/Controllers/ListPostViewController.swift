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
  @IBOutlet var tabButtons: [UIButton]!
  
  // list image appear when click and not click tab
  let tabButtonClickedImage: [String] = ["tab-pending-yellow","tab-accepted-yellow","tab-denied-yellow"]
  let tabButtonNotClickedImage: [String] = ["tab-pending-gray","tab-accepted-gray","tab-denied-gray"]
  
  let reuseableCell = "Cell"
  var posts: [Post] = [] {
    didSet {
      // Default displayingPosts follow status pending
      initDisplayingPosts(status: STATUS_PENDING)
      tableView.reloadData()
    }
  }
  
  // posts displaying to tableview follow status
  var displayingPosts: [Post] = []
  
  let postDataModel = PostDataModel()
  var index: Int = 0
  // constant for status
  let STATUS_PENDING = "pending"
  let STATUS_ACCEPTED = "accepted"
  let STATUS_DENIED = "denied"
  
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
    // Init Menu Button
    let menuButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(self.didTouchMenuButton))
    self.navigationItem.leftBarButtonItem  = menuButton
    getPostsFromServer()
    // When start, pending button is yellow, default is status pending
    setImageForTabButton(index: 0)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // MARK: enable sidemenu
    sideMenuManager?.sideMenuController()?.sideMenu?.disabled = false
  }
  
}

// MARK: tableView Delegate
extension ListPostViewController: UITableViewDelegate {
}

// MARK: tableView Datasource
extension ListPostViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return displayingPosts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! ListPostTableViewCell
    cell.configureWithItem(post: displayingPosts[indexPath.row], role: Helper.role)
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
  
  func didTouchMenuButton(_ sender: Any) {
    sideMenuManager?.toggleSideMenuView()
  }
  
  func initDisplayingPosts(status: String) {
    for post in posts {
      if post.status == status {
        displayingPosts.append(post)
      }
    }
  }
  
  func getPostsFromServer() {
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
  
  func setImageForTabButton(index: Int) {
    // 3 tab buttons
    for position in 0..<3 {
      if position == index {
        tabButtons[position].setBackgroundImage(UIImage(named: tabButtonClickedImage[position]), for: .normal)
      } else {
        tabButtons[position].setBackgroundImage(UIImage(named: tabButtonNotClickedImage[position]), for: .normal)
      }
    }
  }
}

// MARK: IBAction
extension ListPostViewController {
  // All tab buttons using this function
  @IBAction func didTouchTabButton(_ sender: UIButton) {
    print("====tag \(sender.tag)")
    switch sender.tag {
    case 0:
      setImageForTabButton(index: 0)
      displayingPosts.removeAll()
      initDisplayingPosts(status: STATUS_PENDING)
      tableView.reloadData()
    case 1:
      setImageForTabButton(index: 1)
      displayingPosts.removeAll()
      initDisplayingPosts(status: STATUS_ACCEPTED)
      tableView.reloadData()
    case 2:
      setImageForTabButton(index: 2)
      displayingPosts.removeAll()
      initDisplayingPosts(status: STATUS_DENIED)
      tableView.reloadData()
    default:
      break
    }
  }
}

extension ListPostViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showPostDetail" {
      if let destination = segue.destination as? PostDetailViewController {
        destination.post = displayingPosts[index]
      }
    } else if segue.identifier == "showListAnswer" {
      if let destination = segue.destination as? AnswersViewController {
        destination.post = displayingPosts[index]
      }
    }
  }
}
