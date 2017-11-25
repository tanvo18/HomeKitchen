//
//  ListOrderViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/24/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class ListOrderViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var topSpaceTableView: NSLayoutConstraint!
  
  @IBOutlet var tabButtons: [UIButton]!
  
  // list image appear when click and not click tab
  let tabButtonClickedImage: [String] = ["tab-pending-yellow","tab-negotiating-yellow","tab-accepted-yellow","tab-denied-yellow"]
  let tabButtonNotClickedImage: [String] = ["tab-pending-gray","tab-negotiating-gray","tab-accepted-gray","tab-denied-gray"]
  
  let reuseableCell = "Cell"
  var orderInfos: [OrderInfo] = [] {
    didSet {
      if Helper.role == ROLE_CUSTOMER {
        // the first time have status = pending
        initDisplayingCustomerOrders(status: STATUS_PENDING)
        tableView.reloadData()
      } else if Helper.role == ROLE_CHEF {
        tableView.reloadData()
      }
      myActivityIndicator.stopAnimating()
    }
  }
  // Set title if dont have any order
  let notiLabel: UILabel = UILabel()
  // Save index of table row
  var index: Int = 0
  let customerOrderModelDatasource = CustomerOrderDataModel()
  let kitchenOrderModelDatasource = KitchenOrderDataModel()
  // Status for request list order by chef
  var listStatus: [String] = ["Đang chờ duyệt","Đã chấp nhận","Thương lượng","Từ chối"]
  // Default status
  var selectedStatus: String = "Đang chờ duyệt"
  var myActivityIndicator: UIActivityIndicatorView!
  // constant for status
  let STATUS_PENDING = "pending"
  let STATUS_ACCEPTED = "accepted"
  let STATUS_DENIED = "denied"
  let STATUS_NEGOTIATING = "negotiating"
  
  // We will use orderInfos for entire this class if role = chef
  // And use displayingCustomerOrders for entire this class if role = customer
  // Because API of 2 roles are different, role chef need status and role customer doesn't need
  // role chef will click tab button and then load data from server
  // role customer get all data in the first time and will filter data for displayingCustomerOrders
  // this array for role customer
  var displayingCustomerOrders: [OrderInfo] = []
  let ROLE_CHEF = "chef"
  let ROLE_CUSTOMER = "customer"
  // variable using for role chef and customer
  var orderInfo: OrderInfo = OrderInfo()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "GetOrderTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    // Hide Foot view
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    // Declare customerOrderModelDatasource
    customerOrderModelDatasource.delegate = self
    // Declare kitchenOrderModelDatasource
    kitchenOrderModelDatasource.delegate = self
    // Add left bar button
    let menuButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(self.didTouchMenuButton))
    self.navigationItem.leftBarButtonItem  = menuButton
    let title = ""
    self.settingForNavigationBar(title: title)
    setUpActivityIndicator()
    // When start, pending button is yellow, default is status pending
    setImageForTabButton(index: 0)
    // Request Data
    if Helper.role == ROLE_CUSTOMER {
      myActivityIndicator.startAnimating()
      customerOrderModelDatasource.requestCustomerOrder()
      self.settingForNavigationBar(title: "Quản lý đơn hàng")
    } else if Helper.role == ROLE_CHEF {
      myActivityIndicator.startAnimating()
      // Change to english status
      selectedStatus = "pending"
      kitchenOrderModelDatasource.requestKitchenOrder(status: selectedStatus)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // MARK: enable sidemenu
    sideMenuManager?.sideMenuController()?.sideMenu?.disabled = false
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

// MARK: tableView Delegate
extension ListOrderViewController: UITableViewDelegate {
}

// MARK: tableView Datasource
extension ListOrderViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if Helper.role == ROLE_CUSTOMER {
      return displayingCustomerOrders.count
    } else {
      return orderInfos.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! GetOrderTableViewCell
    // Distinguish role
    let role = Helper.role
    // Distinguish orderInfo of orderInfos or displayingCustomerOrders
    if role == ROLE_CHEF {
      self.orderInfo = orderInfos[indexPath.row]
    } else if role == ROLE_CUSTOMER {
      self.orderInfo = displayingCustomerOrders[indexPath.row]
    }
    
    cell.configureWithItem(orderInfo: self.orderInfo, role: role, status: selectedStatus)
    // Handle button on cell
    cell.buttonNotification.tag = indexPath.row
    cell.buttonNotification.addTarget(self, action: #selector(self.didTouchButtonNotification), for: .touchUpInside)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Save index
    index = indexPath.row
    performSegue(withIdentifier: "showOrderDetail", sender: self)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
}

// MARK: CustomerOrderDataModel Delegate
extension ListOrderViewController: CustomerOrderDataModelDelegate {
  func didRecieveCustomerOrder(data: [OrderInfo]) {
    orderInfos = data
  }
  func didFailUpdateWithError(error: String) {
    print(error)
  }
}

// MARK: KitchenOrderDataModel Delegate
extension ListOrderViewController: KitchenOrderDataModelDelegate {
  func didRecieveKitchenOrder(data: [OrderInfo]) {
    orderInfos = data
  }
  
  func didFailKitchenOrderWithError(error: String) {
    print(error)
  }
}


// MARK: Function
extension ListOrderViewController {
  func didTouchMenuButton(sender: UIButton) {
    sideMenuManager?.toggleSideMenuView()
  }
  
  func didTouchButtonNotification(sender: UIButton) {
    index = sender.tag
    if Helper.role == ROLE_CHEF {
      self.orderInfo = orderInfos[index]
    } else if Helper.role == ROLE_CUSTOMER {
      self.orderInfo = displayingCustomerOrders[index]
    }
    
    if self.orderInfo.suggestions.isEmpty {
      let title = "Thông báo"
      let message = "Không có đề nghị nào"
      self.alert(title: title, message: message)
    } else {
      performSegue(withIdentifier: "showListSuggestion", sender: self)
    }
  }
  
  func setUpActivityIndicator()
  {
    //Create Activity Indicator
    myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    // Position Activity Indicator in the center of the main view
    myActivityIndicator.center = view.center
    
    // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
    myActivityIndicator.hidesWhenStopped = true
    
    myActivityIndicator.backgroundColor = .white
    
    view.addSubview(myActivityIndicator)
  }
  
  func initDisplayingCustomerOrders(status: String) {
    for orderInfo in orderInfos {
      if orderInfo.status == status {
        displayingCustomerOrders.append(orderInfo)
      }
    }
  }
  
  func setImageForTabButton(index: Int) {
    // 4 tab buttons
    for position in 0..<4 {
      if position == index {
        tabButtons[position].setBackgroundImage(UIImage(named: tabButtonClickedImage[position]), for: .normal)
      } else {
        tabButtons[position].setBackgroundImage(UIImage(named: tabButtonNotClickedImage[position]), for: .normal)
      }
    }
  }
  
}

// MARK: IBAction
extension ListOrderViewController {
  @IBAction func didTouchTabButton(_ sender: UIButton) {
    myActivityIndicator.startAnimating()
    print("====tag \(sender.tag)")
    if Helper.role == ROLE_CHEF {
      switch sender.tag {
      case 0:
        myActivityIndicator.startAnimating()
        tabButtons[sender.tag].backgroundColor = UIColor.gray
        orderInfos.removeAll()
        selectedStatus = STATUS_PENDING
        kitchenOrderModelDatasource.requestKitchenOrder(status: STATUS_PENDING)
        // Set image
        setImageForTabButton(index: 0)
      case 1:
        myActivityIndicator.startAnimating()
        orderInfos.removeAll()
        selectedStatus = STATUS_NEGOTIATING
        kitchenOrderModelDatasource.requestKitchenOrder(status: STATUS_NEGOTIATING)
        // Set image
        setImageForTabButton(index: 1)
      case 2:
        myActivityIndicator.startAnimating()
        orderInfos.removeAll()
        selectedStatus = STATUS_ACCEPTED
        kitchenOrderModelDatasource.requestKitchenOrder(status: STATUS_ACCEPTED)
        // Set image
        setImageForTabButton(index: 2)
      case 3:
        myActivityIndicator.startAnimating()
        orderInfos.removeAll()
        selectedStatus = STATUS_DENIED
        kitchenOrderModelDatasource.requestKitchenOrder(status: STATUS_DENIED)
        // Set image
        setImageForTabButton(index: 3)
      default:
        break
      }
    } else if Helper.role == ROLE_CUSTOMER {
      switch sender.tag {
      case 0:
        myActivityIndicator.startAnimating()
        displayingCustomerOrders.removeAll()
        initDisplayingCustomerOrders(status: STATUS_PENDING)
        tableView.reloadData()
        myActivityIndicator.stopAnimating()
        // Set image
        setImageForTabButton(index: 0)
      case 1:
        myActivityIndicator.startAnimating()
        displayingCustomerOrders.removeAll()
        initDisplayingCustomerOrders(status: STATUS_NEGOTIATING)
        tableView.reloadData()
        myActivityIndicator.stopAnimating()
        // Set image
        setImageForTabButton(index: 1)
      case 2:
        myActivityIndicator.startAnimating()
        displayingCustomerOrders.removeAll()
        initDisplayingCustomerOrders(status: STATUS_ACCEPTED)
        tableView.reloadData()
        myActivityIndicator.stopAnimating()
        // Set image
        setImageForTabButton(index: 2)
      case 3:
        myActivityIndicator.startAnimating()
        displayingCustomerOrders.removeAll()
        initDisplayingCustomerOrders(status: STATUS_DENIED)
        tableView.reloadData()
        myActivityIndicator.stopAnimating()
        // Set image
        setImageForTabButton(index: 3)
      default:
        break
      }
    }
  }
}

extension ListOrderViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showOrderDetail" {
      if let destination = segue.destination as? OrderDetailViewController {
        destination.orderInfo = orderInfos[index]
        // Change to English for selectedStatus
        switch selectedStatus {
        case "Đang chờ duyệt":
          selectedStatus = STATUS_PENDING
        case "Đã chấp nhận":
          selectedStatus = STATUS_ACCEPTED
        case "Thương lượng":
          selectedStatus = STATUS_NEGOTIATING
        case "Từ chối":
          selectedStatus = STATUS_DENIED
        default :
          break
        }
        /*
         follow status which chef choose to show list: pending, accepted ...
         */
        destination.chefOrderStatus = selectedStatus
      }
    } else if segue.identifier == "showListSuggestion" {
      if let destination = segue.destination as? SuggestionsViewController {
        if Helper.role == ROLE_CHEF {
          self.orderInfo = orderInfos[index]
        } else if Helper.role == ROLE_CUSTOMER {
          self.orderInfo = displayingCustomerOrders[index]
        }
        
        destination.suggestions = orderInfo.suggestions
        destination.orderStatus = orderInfo.status
      }
    }
  }
}


