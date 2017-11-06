//
//  SearchViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 11/6/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
  
  // MARK: IBOutlet
  @IBOutlet weak var criteriaLabel: UILabel!
  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var tableView: UITableView!
  
  var kitchens: [Kitchen] = [] {
    didSet {
      tableView.reloadData()
      myActivityIndicator.stopAnimating()
    }
  }
  // Indicator
  var myActivityIndicator: UIActivityIndicatorView!
  let reuseableCell = "Cell"
  var position: Int = 0
  var searchText: String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Tapping criteria label
    let tap = UITapGestureRecognizer(target: self, action: #selector(tapCriteriaLabel))
    criteriaLabel.isUserInteractionEnabled = true
    criteriaLabel.addGestureRecognizer(tap)
    // Setup indicator
    setUpActivityIndicator()
    // TableView
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "SearchingTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    self.settingForNavigationBar(title: "Tìm kiếm")
    // MARK: Search TextField
    searchTextField.delegate = self
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
    return kitchens.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! SearchingTableViewCell
    cell.configureWithItem(kitchen: kitchens[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 200
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    position = indexPath.row
    // Save kitchenID
    Helper.kitchenId = kitchens[indexPath.row].id
    performSegue(withIdentifier: "showKitchenDetail", sender: self)
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
  
}

// MARK: IBAction
extension SearchViewController {
  @IBAction func unwindToSearchViewController(segue:UIStoryboardSegue) {
    if segue.source is CriteriaViewController {
      if let senderVC = segue.source as? CriteriaViewController {
        print("====senderVC \(senderVC.selectedCriteria)")
        criteriaLabel.text = senderVC.selectedCriteria
      }
    }
  }
}

extension SearchViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showKitchenDetail" {
      if let destination = segue.destination as? KitchenDetailViewController {
        destination.kitchen = kitchens[position]
      }
    }
  }
}

