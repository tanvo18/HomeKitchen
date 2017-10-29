//
//  LeftMenuTableViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/1/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

protocol LeftMenuDelegate: class {
  func didSelectItemAtIndex(index idx: Int, sectionIndex: Int)
}


class LeftMenuTableViewController: UIViewController {
  
  // MARK: IBOutlets
  @IBOutlet weak var menuTableView: UITableView!
  @IBOutlet weak var userNameLabel: UILabel!
  
  // MARK: Properties
  let kCellIdentifier = "menuCell"
  // Header for table section
  let headerTitles = ["TRANG CHỦ", "KHÁCH HÀNG","BẾP","THOÁT"]
  let data = [["Trang chủ"],["Thông tin khách hàng","Đơn hàng của tôi","Yêu cầu của tôi"],["Quản lý đơn hàng","Quản lý yêu cầu","Quản lý bếp","Tạo bếp"],["Đăng xuất"]]
  let images = [["kitchen-white"],["user-white","paper-white","paper-white"],["cart-white","cart-white","knife-spoon-white","fork-knife-white"],["logout-white"]]
  weak var delegate: LeftMenuDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    let nib = UINib(nibName: "MenuTableViewCell", bundle: nil)
    menuTableView.register(nib, forCellReuseIdentifier: kCellIdentifier)
    // Set title for slide menu
    userNameLabel.text = "Chào mừng " + Helper.user.name
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    //    menuTableView.reloadSections(IndexSet(integer: 0), with: .none)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
}

extension LeftMenuTableViewController: UITableViewDataSource {
  // MARK: - Table view data source
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data[section].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath) as! MenuTableViewCell
    cell.titleLabel.text = data[indexPath.section][indexPath.row]
    cell.imageViewCell.image = UIImage(named: images[indexPath.section][indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section < headerTitles.count {
      return headerTitles[section]
    }
    return nil
  }
  
}

extension LeftMenuTableViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let delegate = delegate {
      delegate.didSelectItemAtIndex(index: indexPath.row, sectionIndex: indexPath.section)
    }
  }
}

