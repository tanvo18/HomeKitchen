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
      myIndicator.stopAnimating()
    }
  }
  let kitchenModelDatasource = KitchenDataModel()
  let reuseableCell = "Cell"
  // Indicator
  let myIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
  var position: Int = 0
  
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
    // Set title for back button in navigation bar
    navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // MARK: enable sidemenu
    sideMenuManager?.sideMenuController()?.sideMenu?.disabled = false
    kitchenModelDatasource.requestKitchen()
  }
}

// MARK: Tableview Delegate
extension KitchenViewController: UITableViewDelegate {
}

// MARK: Tableview Datasource
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
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    position = indexPath.row
    performSegue(withIdentifier: "showKitchenDetail", sender: self)
  }
  
}

// MARK: IBAction
extension KitchenViewController {
  @IBAction func didTouchButtonMenu(_ sender: Any) {
    sideMenuManager?.toggleSideMenuView()
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
        destination.imageUrl = kitchens[position].imageUrl
        destination.point = kitchens[position].point
        destination.time = "\(kitchens[position].open)-\(kitchens[position].close)"
      }
    }
  }
}








