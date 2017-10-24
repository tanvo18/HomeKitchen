//
//  PostRequestViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/13/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit
import AWSCore
import AWSS3
import Photos

class PostRequestViewController: UIViewController {
  
  // MARK: IBOutlet
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var textViewMessage: UITextView!
  
  let reuseable = "Cell"
  var post: Post = Post()
  var index: Int = 0
  var selectedImageUrl: URL!
  var myActivityIndicator: UIActivityIndicatorView!
  // Param for post to server
  var foodImageView: UIImageView!
  var foodImageViews: [UIImageView] = []
  // message of textview
  var message: String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: reuseable)
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    settingRightButtonItem()
    self.settingForNavigationBar(title: "Post Request")
    // MARK: Disable sidemenu
    sideMenuManager?.sideMenuController()?.sideMenu?.disabled = true
    // Tab outside to close keyboard
    let tapOutside: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
    view.addGestureRecognizer(tapOutside)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}

// MARK: tableView Delegate
extension PostRequestViewController: UITableViewDelegate {
  
}

// MARK: tableView Datasource
extension PostRequestViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return post.postItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseable) as! PostTableViewCell
    cell.quantityLabel.text = "\(post.postItems[indexPath.row].quantity)"
    // Set default image for imageview
    cell.imageViewCell.image = UIImage(named: "photoalbum")
    // Handle button in cell
    cell.buttonPlus.tag = indexPath.row
    cell.buttonPlus.addTarget(self, action: #selector(self.didTouchButtonPlus), for: .touchUpInside)
    cell.buttonMinus.tag = indexPath.row
    cell.buttonMinus.addTarget(self, action: #selector(self.didTouchButtonMinus), for: .touchUpInside)
    // Handle textfield in row
    cell.nameTextField.tag = indexPath.row
    cell.nameTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    
    // Reference imageview in foodImageViews to imageViewCell
    if !foodImageViews.isEmpty {
      foodImageViews[indexPath.row] = cell.imageViewCell
    }
    // Handle imageView in row
    cell.imageViewCell.tag = indexPath.row
    // Tapping imageviewCell
    let tapImage = UITapGestureRecognizer(target: self, action: #selector(displayImagePicker(sender:)))
    cell.imageViewCell.isUserInteractionEnabled = true
    cell.imageViewCell.addGestureRecognizer(tapImage)
    return cell
  }
}

// MARK: Function
extension PostRequestViewController {
  // Increase quantity of postItem
  func didTouchButtonPlus(sender: UIButton) {
    index = sender.tag
    post.postItems[index].quantity += 1
    tableView.reloadData()
  }
  
  // Decrease quantity of postItem
  func didTouchButtonMinus(sender: UIButton) {
    index = sender.tag
    if post.postItems[index].quantity > 0 {
      post.postItems[index].quantity -= 1
    }
    tableView.reloadData()
  }
  
  // Catching price textfield change number
  func textFieldDidChange(textField: UITextField) {
    index = textField.tag
    if !textField.text!.isEmpty {
      post.postItems[index].productName = textField.text!
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
    rightButtonItem.image = UIImage(named: "barbutton-plus")
    self.navigationItem.rightBarButtonItem = rightButtonItem
    self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: CGFloat(170/255.0), green: CGFloat(151/255.0), blue: CGFloat(88/255.0), alpha: 1.0)
  }
  
  func rightButtonAction(sender: UIBarButtonItem) {
    post.postItems.append(PostItem())
    // Add imageView for foodImageViews
    foodImageViews.append(UIImageView())
    tableView.reloadData()
  }
  
  // A product is valid when it has quantity > 0 and a name
  func isValidProduct() -> Bool {
    for item in post.postItems {
      if item.productName.isEmpty || item.quantity == 0 {
        return false
      }
    }
    return true
  }
  
}

// MARK: Function of UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension PostRequestViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
  // Show image picker
  func displayImagePicker(sender:UITapGestureRecognizer) {
    // Save index of imageViewCell
    let imageView = sender.view
    self.index = imageView!.tag
    let myPickerController = UIImagePickerController()
    myPickerController.delegate = self;
    myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
    self.present(myPickerController, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
  {
    selectedImageUrl = info[UIImagePickerControllerReferenceURL] as! URL
    
    // Saving Url
    post.postItems[index].selectedImageUrl = selectedImageUrl
    
    // display image to imageview in cell
    foodImageView = foodImageViews[index]
    foodImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    foodImageView.backgroundColor = UIColor.clear
    foodImageView.contentMode = UIViewContentMode.scaleAspectFit
    
    // Make data from image and saving to item
    let data = UIImageJPEGRepresentation(foodImageView.image!, 0.6)
    post.postItems[index].data = data
    self.dismiss(animated: true, completion: nil)
  }
  
}

// MARK: IBAction
extension PostRequestViewController {
  @IBAction func didTouchContinueButton(_ sender: Any) {
    if post.postItems.count > 0 {
      if isValidProduct() {
        // Take message from textView
        message = textViewMessage.text
        
        print("====message: \(message)")
        
        
        performSegue(withIdentifier: "showOrderInfo", sender: self)
      } else {
        self.alertError(message: "Not valid product")
      }
    } else {
      self.alertError(message: "You have to create at least a post")
    }
  }
}

extension PostRequestViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showOrderInfo" {
      if let destination = segue.destination as? OrderInfoViewController {
        destination.post = post 
        destination.sourceViewController = "PostRequestViewController"
        destination.textViewMessage = message
      }
    }
  }
}
