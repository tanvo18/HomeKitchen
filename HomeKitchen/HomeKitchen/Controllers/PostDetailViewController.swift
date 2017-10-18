//
//  PostDetailViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/17/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {
  
  // MARK: IBOutlet
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var idLabel: UILabel!
  @IBOutlet weak var requestDateLabel: UILabel!
  @IBOutlet weak var deliveryDateLabel: UILabel!
  @IBOutlet weak var deliveryTimeLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var informationLabel: UILabel!
  @IBOutlet weak var answerButton: UIButton!
  @IBOutlet weak var declinedButton: UIButton!
  
  let reuseableCell = "Cell"
  var post: Post = Post()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "PostDetailTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    // Hide Foot view
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    self.settingForNavigationBar(title: "Post Detail")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    parseDataForLabel()
  }
}

// MARK: tableView Delegate
extension PostDetailViewController: UITableViewDelegate {
}

// MARK: tableView Datasource
extension PostDetailViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return post.postItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! PostDetailTableViewCell
    cell.configureWithItem(item: post.postItems[indexPath.row])
    return cell
  }
}

// MARK: function
extension PostDetailViewController {
  func parseDataForLabel() {
    idLabel.text = "\(post.id)"
    requestDateLabel.text = post.requestDate
    deliveryTimeLabel.text = post.deliveryTime
    deliveryDateLabel.text = post.deliveryDate
    if Helper.role == "customer" {
      informationLabel.text = "thông tin nhà hàng"
      statusLabel.text = post.status
      nameLabel.text = post.kitchen?.name
      addressLabel.text = post.kitchen?.address?.address
      answerButton.isHidden = true
      declinedButton.isHidden = true
    } else if Helper.role == "chef" {
      informationLabel.text = "thông tin khách hàng"
      statusLabel.text = post.status
      nameLabel.text = post.contactInfo?.name
      addressLabel.text = post.contactInfo?.address
    }
  }
}

// MARK: IBAction
extension PostDetailViewController {
  @IBAction func didTouchAnswerButton(_ sender: Any) {
    performSegue(withIdentifier: "showCreateAnswer", sender: self)
  }
  
  @IBAction func didTouchDeclinedButton(_ sender: Any) {
    NetworkingService.sharedInstance.declinePost(postId: post.id) {
      [unowned self] (message,error) in
      if error != nil {
        print(error!)
        self.alertError(message: "Cannot decline")
      } else {
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
          self.performSegue(withIdentifier: "showListPost", sender: self)
        })
        self.alertWithAction(message: "Decline Successfully", action: ok)
      }
    }
  }
}

extension PostDetailViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showCreateAnswer" {
      if let destination = segue.destination as? CreateAnswerViewController {
        destination.postItems = post.postItems
        destination.deliveryDateOfPost = post.deliveryDate
        destination.deliveryTimeOfPost = post.deliveryTime
        destination.postId = post.id
      }
    }
  }
}
