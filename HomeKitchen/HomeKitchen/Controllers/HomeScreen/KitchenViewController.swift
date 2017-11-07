//
//  KitchenViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/4/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import LNSideMenu
import Alamofire
import ObjectMapper
import ESPullToRefresh

class KitchenViewController: UIViewController {
  
  // MARK: IBOutlet
  @IBOutlet weak var tableView: UITableView!
  var kitchens: [Kitchen] = [] {
    didSet {
      // add kitchen from kitchens to kitchensRendering
      for kitchen in kitchens {
        kitchensRendering.append(kitchen)
      }
      tableView.reloadData()
      myIndicator.stopAnimating()
      print("====function doing \(kitchensRendering.count)")
    }
  }
  var kitchensRendering: [Kitchen] = []
  let kitchenModelDatasource = KitchenDataModel()
  let reuseableCell = "Cell"
  // Indicator
  let myIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
  var position: Int = 0
  // Checking user login or not, if login before, we have to get user information
  var isLogin: Bool = true
  let userModelDatasource = UserDataModel()
  // param for request list kitchen
  var page = 0
  // page on server
  let MAX_PAGE = 4
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "KitchenTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    // Declare KitchenDataModelDelegate
    kitchenModelDatasource.delegate = self
    // Hide Foot view
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    
    // Setup indicator
    myIndicator.center = view.center
    myIndicator.startAnimating()
    view.addSubview(myIndicator)
    // Adjust navigation bar
    self.settingForNavigationBar(title: "Trang chủ")
    // Add left bar button
    let menuButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(self.didTouchMenuButton))
    self.navigationItem.leftBarButtonItem  = menuButton
    // Get user information if login before
    if isLogin {
      getUserInformation()
    }
    // Right button in navigation bar
    settingRightButtonItem()
    // Get kitchen data in the first time
    kitchenModelDatasource.requestKitchen(status: "city", keyword: "Da Nang", city: "", page: 0)
    // Refresh and Load more
    self.tableView.es.addPullToRefresh { [weak self] in
      self?.refreshTableView()
    }
    self.tableView.es.addInfiniteScrolling { [weak self] in
      self?.loadMoreTableView()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // MARK: enable sidemenu
    sideMenuManager?.sideMenuController()?.sideMenu?.disabled = false
  }
  
}

// MARK: Tableview Delegate
extension KitchenViewController: UITableViewDelegate {
}

// MARK: Tableview Datasource
extension KitchenViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return kitchensRendering.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! KitchenTableViewCell
    cell.configureWithItem(kitchen: kitchensRendering[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 200
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    position = indexPath.row
    // Save kitchenID
    Helper.kitchenId = kitchensRendering[indexPath.row].id
    performSegue(withIdentifier: "showKitchenDetail", sender: self)
  }
}

// MARK: Function
extension KitchenViewController {
  func didTouchMenuButton(_ sender: Any) {
    sideMenuManager?.toggleSideMenuView()
  }
  
  func getUserInformation() {
    userModelDatasource.getUserInfo() {
      [unowned self] (user,error) in
      if error != nil {
        print(error!)
        self.alertError(message: "Không thể lấy thông tin khách hàng")
      } else {
        Helper.user = user
        print("====username: \(Helper.user.username)")
      }
    }
  }
  
  func settingRightButtonItem() {
    // Set nil for title if UIBarButton have an image to avoid bug button move down when alert message appears
    let rightButtonItem = UIBarButtonItem.init(
      title: nil,
      style: .done,
      target: self,
      action: #selector(rightButtonAction(sender:))
    )
    rightButtonItem.image = UIImage(named: "search-white")
    self.navigationItem.rightBarButtonItem = rightButtonItem
  }
  
  func rightButtonAction(sender: UIBarButtonItem) {
    performSegue(withIdentifier: "showSearchView", sender: self)
  }
  
  func refreshTableView() {
    print("refresh")
    kitchensRendering.removeAll()
    self.page = 0
    kitchenModelDatasource.requestKitchen(status: "city", keyword: "Da Nang", city: "", page: page)
    tableView.reloadData()
    self.tableView.es.stopPullToRefresh()
  }
  
  func loadMoreTableView() {
    print("loadmore")
    self.page += 1
    if self.page <= MAX_PAGE {
      kitchenModelDatasource.requestKitchen(status: "city", keyword: "Da Nang", city: "", page: page)
      self.tableView.es.stopLoadingMore()
    } else {
      self.tableView.es.noticeNoMoreData()
    }
  }
}

// MARK: KitchenDataModel Delegate
extension KitchenViewController: KitchenDataModelDelegate {
  func didRecieveKitchenUpdate(data: [Kitchen]) {
    kitchens = data
  }
  func didFailKitchenUpdateWithError(error: String) {
    print("error \(error)")
  }
}

extension KitchenViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showKitchenDetail" {
      if let destination = segue.destination as? KitchenDetailViewController {
        destination.kitchen = kitchensRendering[position]
      }
    }
  }
}










