//
//  KitchenDetailViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/6/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit
import Kingfisher

class KitchenDetailViewController: UIViewController {
  
  // MARK: IBOutlet
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet weak var pointLabel: UILabel!
  @IBOutlet weak var indicator: UIActivityIndicatorView!
  @IBOutlet weak var timeLabel: UILabel!
  var products: [OrderItem] = []{
    didSet {
      tableView.reloadData()
    }
  }
  
  let reuseableCell = "Cell"
  let productModelDatasource = ProductDataModel()
  var imageUrl: String = ""
  var point: Double = 0.0
  var time: String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // MARK: Disable sidemenu
    sideMenuManager?.sideMenuController()?.sideMenu?.disabled = true
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "TopOrderTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    // MARK: KitchenDataModelDelegate
    productModelDatasource.delegate = self
    // Hide Foot view
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    // Start indicator
    indicator.startAnimating()
    downloadBackgroundImage()
    pointLabel.text = "\(point)"
    timeLabel.text = time
    // Request data through delagate
    productModelDatasource.requestProduct()
    // Set title for back button in navigation bar
    navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

// MARK: tableView Delegate
extension KitchenDetailViewController: UITableViewDelegate {
  
}

// MARK: tableView Datasource
extension KitchenDetailViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! TopOrderTableViewCell
    cell.backgroundColor = .gray
    //  cell.configureWithItem(product: products[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
  
}

// MARK: ProductDataModelDelegate
extension KitchenDetailViewController: ProductDataModelDelegate {
  func didRecieveProductUpdate(data: [OrderItem]) {
    products = data
  }
  func didFailProductUpdateWithError(error: String) {
    print("error \(error)")
  }
}

extension KitchenDetailViewController {
  // MARK: download image with url
  func downloadBackgroundImage() {
    let url = URL(string: imageUrl)!
    ImageDownloader.default.downloadImage(with: url, options: [], progressBlock: nil) {
      (image, error, url, data) in
      self.backgroundImage.image = image
      self.indicator.stopAnimating()
      self.indicator.isHidden = true
    }
  }
}

// MARK: IBAction
extension KitchenDetailViewController {
  @IBAction func didTouchDeliveryButton(_ sender: Any) {
    performSegue(withIdentifier: "showListOrder", sender: self)
  }
}

extension KitchenDetailViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showListOrder" {
      if let destination = segue.destination as? OrderViewController {
        destination.products = products
      }
    }
  }
}



