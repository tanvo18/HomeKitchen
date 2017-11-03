//
//  LocationViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/9/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  let reuseable = "Cell"
  var selectedLocation = ""
  var locations: [String] = []
  // Recognize viewcontroller
  var viewcontroller = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // MARK: Disable sidemenu
    sideMenuManager?.sideMenuController()?.sideMenu?.disabled = true
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: reuseable)
    tableView.tableFooterView = UIView(frame: CGRect.zero)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

// MARK: tableView Delegate
extension LocationViewController: UITableViewDelegate {
  
}

// MARK: tableView Datasource
extension LocationViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return locations.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseable) as! LocationTableViewCell
    cell.locationLabel.text = locations[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedLocation = locations[indexPath.row]
    if viewcontroller == "CreateKitchenViewController" {
      performSegue(withIdentifier: "unwindToCreateKitchenController", sender: self)
    } else if viewcontroller == "EditKitchenViewController" {
      performSegue(withIdentifier: "unwindToEditKitchenController", sender: self)
    }
  }
}

