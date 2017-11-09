//
//  SearchViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 11/6/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit
import ESPullToRefresh

class SearchViewController: UIViewController {
  
  // MARK: IBOutlet
  @IBOutlet weak var criteriaLabel: UILabel!
  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var locationLabel: UILabel!
  
  @IBOutlet weak var tableView: UITableView!
  // array contains all kitchens request from server when load more (1 load more return a specific quantities of kitchen)
  var kitchens: [Kitchen] = [] {
    didSet {
      // add kitchen from kitchens to kitchensRendering
      for kitchen in kitchens {
        kitchensRendering.append(kitchen)
      }
      tableView.reloadData()
      myActivityIndicator.stopAnimating()
      print("====function doing \(kitchensRendering.count)")
    }
  }
  
  let kitchenModelDatasource = KitchenDataModel()
  // Indicator
  var myActivityIndicator: UIActivityIndicatorView!
  let reuseableCell = "Cell"
  var position: Int = 0
  var searchText: String = ""
  // array contains all kitchens after load more (add many kitchens in many load more time)
  var kitchensRendering: [Kitchen] = []
  // param for request list kitchen
  var page = 0
  // page on server
  let MAX_PAGE = 4
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Tapping criteria label
    let tap = UITapGestureRecognizer(target: self, action: #selector(tapCriteriaLabel))
    criteriaLabel.isUserInteractionEnabled = true
    criteriaLabel.addGestureRecognizer(tap)
    // Tapping location label
    let tapLocation = UITapGestureRecognizer(target: self, action: #selector(tapLocationLabel))
    locationLabel.isUserInteractionEnabled = true
    locationLabel.addGestureRecognizer(tapLocation)
    // Setup indicator
    setUpActivityIndicator()
    // TableView
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "SearchingTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    self.settingForNavigationBar(title: "Tìm kiếm")
    // MARK: Search TextField
    searchTextField.delegate = self
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
  
}

// MARK: Tableview Delegate
extension SearchViewController: UITableViewDelegate {
}

// MARK: Tableview Datasource
extension SearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return kitchensRendering.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! SearchingTableViewCell
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

// MARK: KitchenDataModel Delegate
extension SearchViewController: KitchenDataModelDelegate {
  func didRecieveKitchenUpdate(data: [Kitchen]) {
    kitchens = data
  }
  func didFailKitchenUpdateWithError(error: String) {
    print("error \(error)")
  }
}

// MARK: Search TextField Delegate
extension SearchViewController: UITextFieldDelegate {
  /**
   This function recognize when enter any character to TextField
   It will query TextField's content and name of shoes in array shoesResults
   */
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if string.isEmpty
    {
      searchText = String(searchText.characters.dropLast())
    }
    else
    {
      searchText = textField.text!+string
    }
    
    print("===text \(searchText)")
    return true
  }
}

// MARK: Function
extension SearchViewController {
  func tapCriteriaLabel(sender:UITapGestureRecognizer) {
    performSegue(withIdentifier: "showCriteria", sender: self)
  }
  
  func tapLocationLabel(sender:UITapGestureRecognizer) {
    performSegue(withIdentifier: "showLocation", sender: self)
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
  
  func refreshTableView() {
    print("refresh")
    // Remove all data
    kitchensRendering.removeAll()
    self.page = 0
    if criteriaLabel.text! == "Thành phố" {
      kitchenModelDatasource.requestKitchen(status: "city", keyword: "Da Nang", city: "", page: page)
    } else if criteriaLabel.text! == "Đánh giá" {
      kitchenModelDatasource.requestKitchen(status: "review", keyword: "", city: "Da Nang", page: page)
    }
    tableView.reloadData()
    self.tableView.es.stopPullToRefresh()
  }
  
  func loadMoreTableView() {
    print("loadmore")
    self.page += 1
    if self.page <= MAX_PAGE {
      if criteriaLabel.text! == "Thành phố" {
        kitchenModelDatasource.requestKitchen(status: "city", keyword: "Da Nang", city: "", page: page)
      } else if criteriaLabel.text! == "Đánh giá" {
        kitchenModelDatasource.requestKitchen(status: "review", keyword: "", city: "Da Nang", page: page)
      }
      self.tableView.es.stopLoadingMore()
    } else {
      self.tableView.es.noticeNoMoreData()
    }
  }
  
}

// MARK: IBAction
extension SearchViewController {
  @IBAction func unwindToSearchViewController(segue:UIStoryboardSegue) {
    if segue.source is CriteriaViewController {
      if let senderVC = segue.source as? CriteriaViewController {
        criteriaLabel.text = senderVC.selectedCriteria
      }
    } else if segue.source is LocationViewController {
      if let senderVC = segue.source as? LocationViewController {
        locationLabel.text = senderVC.selectedLocation
      }
    }
  }
}

extension SearchViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showKitchenDetail" {
      if let destination = segue.destination as? KitchenDetailViewController {
        destination.kitchen = kitchensRendering[position]
      }
    } else if segue.identifier == "showCriteria" {
      if let destination = segue.destination as? CriteriaViewController {
        destination.sourceViewController = "SearchViewController"
      }
    } else if segue.identifier == "showLocation" {
      if let destination = segue.destination as? LocationViewController {
        destination.sourceViewController = "SearchViewController"
        destination.locations = Helper.cityLocations
      }
    }
  }
}

