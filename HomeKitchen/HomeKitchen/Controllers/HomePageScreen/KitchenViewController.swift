//
//  KitchenViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/4/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import LNSideMenu

class KitchenViewController: UIViewController {
  
  // MARK: IBOutlet
  @IBOutlet weak var tableView: UITableView!
  
  var kitchens: [Kitchen] = [] {
    didSet {
      tableView.reloadData()
      myActivityIndicator.stopAnimating()
    }
  }
  let kitchenModelDatasource = KitchenDataModel()
  let reuseableCell = "Cell"
  // Indicator
  let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "KitchenTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    
    // MARK: KitchenDataModelDelegate
    kitchenModelDatasource.delegate = self
    // Hide Foot view
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    
    // Start Activity Indicator
    myActivityIndicator.center = view.center
    myActivityIndicator.startAnimating()
    view.addSubview(myActivityIndicator)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    kitchenModelDatasource.requestKitchen()
  }
  
  @IBAction func didTouchButtonMenu(_ sender: Any) {
    sideMenuManager?.toggleSideMenuView()
  }
  
}

extension KitchenViewController: UITableViewDelegate {
  
}

extension KitchenViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return kitchens.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! KitchenTableViewCell
    cell.configureWithItem(kitchen: kitchens[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 200
  }

}

extension KitchenViewController: KitchenDataModelDelegate {
  func didRecieveKitchenUpdate(data: [Kitchen]) {
    kitchens = data
  }
  func didFailKitchenUpdateWithError(error: String) {
    print("error \(error)")
  }
}








