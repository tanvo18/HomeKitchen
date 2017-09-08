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
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var backgroundImage: UIImageView!
  
  var products: [Product] = []{
    didSet {
      tableView.reloadData()
    }
  }
  let reuseableCell = "Cell"
  let productModelDatasource = ProductDataModel()
  
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
    
    downloadBackgroundImage()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    productModelDatasource.requestProduct()
  }
  
}

extension KitchenDetailViewController: UITableViewDelegate {
  
}

extension KitchenDetailViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! TopOrderTableViewCell
    cell.configureWithItem(product: products[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "showListOrder", sender: self)
  }
}

extension KitchenDetailViewController: ProductDataModelDelegate {
  func didRecieveProductUpdate(data: [Product]) {
    products = data
  }
  func didFailProductUpdateWithError(error: String) {
    print("error \(error)")
  }
}

extension KitchenDetailViewController {
  // MARK: download image with url
  func downloadBackgroundImage() {
    let url = URL(string: "https://s3.amazonaws.com/demouploadimage/restaurantbg.png")!
    ImageDownloader.default.downloadImage(with: url, options: [], progressBlock: nil) {
      (image, error, url, data) in
      self.backgroundImage.image = image
    }
  }
}

