//
//  OrderInfoViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/15/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit
import CVCalendar
import Alamofire
import ObjectMapper
import AWSCore
import AWSS3
import Photos

class OrderInfoViewController: UIViewController {
  
  // MARK: IBOutlet
  
  @IBOutlet weak var timeTextField: UITextField!
  
  @IBOutlet weak var dateLabel: UILabel!
  
  @IBOutlet weak var tableView: UITableView!
  
  // For Calendar
  @IBOutlet weak var monthLabel: UILabel!
  
  let reuseableCell = "Cell"
  // Save index of tableview cell
  var position = 0
  let datePicker = UIDatePicker()
  var myActivityIndicator: UIActivityIndicatorView!
  // Items which customer ordered
  var orderedItems: [OrderItem] = []
  // Message for notification not nil required
  var message: String = ""
  // Post request
  var post: Post!
  // Distinguish Source ViewController
  var sourceViewController = ""
  // Index 
  var index: Int = 0
  // Count image uploaded
  var countImage: Int = 0
  // message of textview from post
  var textViewMessage: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Create datePicker for timeTextField
    createDatePicker()
    // Tapping dateLabel
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapDateLabel))
    dateLabel.isUserInteractionEnabled = true
    dateLabel.addGestureRecognizer(tap)
    // TableView Delegate
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "ContactInfoTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    // Hide Foot view
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    // Set current date and time
    dateLabel.text = setCurrentDate()
    timeTextField.text = setCurrentTime()
    self.settingForNavigationBar(title: "Order Information")
    // Setup indicator
    setUpActivityIndicator()
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}

// MARK: Tableview Delegate
extension OrderInfoViewController: UITableViewDelegate {
}

// MARK: Tableview Datasource
extension OrderInfoViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Helper.user.contactInformations.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! ContactInfoTableViewCell
    if Helper.user.contactInformations.count > 0 {
      let contact = Helper.user.contactInformations[indexPath.row]
      cell.configureWithItem(contact: contact)
      cell.radioButton.tag = indexPath.row
      cell.radioButton.addTarget(self, action: #selector(self.didTouchRadioButton), for: .touchUpInside)
      return cell
    } else {
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    position = indexPath.row
    performSegue(withIdentifier: "showEdit", sender: self)
  }
}


extension OrderInfoViewController {
  func createDatePicker() {
    // Format the display of datepicker
    datePicker.datePickerMode = .time
    
    timeTextField.inputView = datePicker
    
    // Create a toolbar
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    // Add a done button on this toolbar
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
    toolbar.setItems([doneButton], animated: true)
    timeTextField.inputAccessoryView = toolbar
    
  }
  
  func doneClicked() {
    // Format the date displays on textfield
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short
    
    timeTextField.text = dateFormatter.string(from: datePicker.date)
    self.view.endEditing(true)
  }
}

// MARK: Function
extension OrderInfoViewController {
  // Unhide calendar when tap date label
  func tapDateLabel(sender:UITapGestureRecognizer) {
    performSegue(withIdentifier: "showCalendar", sender: self)
  }
  
  // Check all textfield not empty
  func checkNotNil() -> Bool {
    if  timeTextField.text!.isEmpty {
      self.message = "Time is required"
      return false
    }
    if dateLabel.text! == "date" {
      self.message = "Date is required"
      return false
    }
    if Helper.user.contactInformations.isEmpty {
      self.message = "You have to add contact"
      return false
    }
    
    if !isContactChosen() {
      self.message = "You have to choose a contact"
      return false
    }
    
    return true
  }
  
  // Check is there any contact chosen, avoid customer didn't choose any contact
  func isContactChosen() -> Bool {
    for contact in Helper.user.contactInformations {
      if contact.isChosen == true {
        return true
      }
    }
    return false
  }
  
  // Click radio Button
  func didTouchRadioButton(sender: UIButton) {
    position = sender.tag
    let contacts = Helper.user.contactInformations
    for (index,contact) in contacts.enumerated() {
      if index == position {
        contact.isChosen = true
      }
      else {
        contact.isChosen = false
      }
    }
    tableView.reloadData()
  }
  
  func chosenContact() -> ContactInfo {
    var chosenContact: ContactInfo = ContactInfo()
    for contact in Helper.user.contactInformations {
      if contact.isChosen {
        chosenContact = contact
      }
    }
    return chosenContact
  }
  
  func setCurrentDate() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let result = formatter.string(from: date)
    return result
  }
  
  func setCurrentTime() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    let timeString = formatter.string(from: date)
    return timeString
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

  
  func sendOrderToServer() {
    if Helper.orderInfo.status == "in_cart" {
      NetworkingService.sharedInstance.updateOrder(id: Helper.orderInfo.id, contact: chosenContact(), orderDate: setCurrentDate(), deliveryDate: dateLabel.text!, deliveryTime: timeTextField.text!, status: "pending", orderedItems: orderedItems) { [unowned self] (error) in
        if error != nil {
          print(error!)
          self.alertError(message: "Cannot send order")
        } else {
          let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
            // // Go to HomeScreen
            self.performSegue(withIdentifier: "showHomeScreen", sender: self)
          })
          self.alertWithAction(message: "Order Successfully", action: ok)
        }
      }
    } else {
      NetworkingService.sharedInstance.sendOrder(contact: chosenContact(), orderDate: setCurrentDate(), deliveryDate: dateLabel.text!, deliveryTime: timeTextField.text!, status: "pending", kitchenId: Helper.kitchenId, orderedItems: orderedItems) { [unowned self] (error) in
        if error != nil {
          print(error!)
        } else {
          let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
            // // Go to HomeScreen
            self.performSegue(withIdentifier: "showHomeScreen", sender: self)
          })
          self.alertWithAction(message: "Order Successfully", action: ok)
        }
      }
    }
  }
  
  func sendPostRequestToServer() {
    NetworkingService.sharedInstance.sendPostRequest(requestDate: setCurrentDate(), deliveryDate: dateLabel.text!, deliveryTime: timeTextField.text!, message: textViewMessage!, kitchenId: Helper.kitchenId, contactInfo: chosenContact(), postItems: self.post.postItems) {
      [unowned self] (message, error) in
      if error != nil {
        print(error!)
        self.alertError(message: "Cannot send")
      } else {
        self.myActivityIndicator.stopAnimating()
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
          self.performSegue(withIdentifier: "showHomeScreen", sender: self)
        })
        self.alertWithAction(message: "Create Successfully", action: ok)
      }
    }
  }
}

// MARK: IBAction
extension OrderInfoViewController {
  
  @IBAction func didTouchButtonCheckout(_ sender: Any) {
    if checkNotNil() {
      if sourceViewController == "OrderViewController" {
        sendOrderToServer()
      } else if sourceViewController == "PostRequestViewController" {
        // upload all image in array to AWS
        for (index,item) in post.postItems.enumerated() {
          startUploadingImage(imageUrlFromPicker: item.selectedImageUrl, imageData: item.data, index: index)
        }
      }
    } else {
      let alert = UIAlertController(title: "Error", message: self.message, preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  @IBAction func didTouchButtonAdd(_ sender: Any) {
    self.performSegue(withIdentifier: "showAddContact", sender: self)
  }
  
  @IBAction func unwindToOrderInfoController(segue:UIStoryboardSegue) {
    if segue.source is CalendarViewController {
      if let senderVC = segue.source as? CalendarViewController {
        dateLabel.text = senderVC.datePicking
      }
    } else if segue.source is EditContactViewController {
      tableView.reloadRows(at: [IndexPath(row: position, section: 0)], with: .none)
    } else if segue.source is AddNewContactViewController {
      if let senderVC = segue.source as? AddNewContactViewController {
        let name = senderVC.nameTextField.text!
        let phoneNumber = senderVC.phoneTextField.text!
        let address = senderVC.addressTextField.text!
        let contact = ContactInfo(name: name, phoneNumber: phoneNumber, address: address)
        Helper.user.contactInformations.append(contact)
        // Reload tableview
        tableView.reloadData()
      }
    }
  }
}

// MARK: Generate image and interact with AWS S3
extension OrderInfoViewController {
  func generateImageUrl(fileName: String, imageData: Data?) -> URL
  {
    let fileURL = URL(fileURLWithPath: NSTemporaryDirectory().appending(fileName))
    let data = imageData
    do {
      try  data!.write(to: fileURL as URL)
    }
    catch {
      
    }
    return fileURL
  }
  
  func remoteImageWithUrl(fileName: String)
  {
    let fileURL = URL(fileURLWithPath: NSTemporaryDirectory().appending(fileName))
    do {
      try FileManager.default.removeItem(at: fileURL as URL)
    } catch
    {
      print(error)
    }
  }
  
  func startUploadingImage(imageUrlFromPicker: URL!, imageData: Data?, index: Int)
  {
    var localFileName:String?
    
    if let imageToUploadUrl = imageUrlFromPicker
    {
      let phResult = PHAsset.fetchAssets(withALAssetURLs: [imageToUploadUrl as URL], options: nil)
      localFileName = PHAssetResource.assetResources(for: phResult.firstObject!).first!.originalFilename
      print("=====\(localFileName!)")
    }
    
    if localFileName == nil
    {
      alertError(message: "You have to choose image")
      return
    }
    
    myActivityIndicator.startAnimating()
    
    // Configure AWS Cognito Credentials
    let myIdentityPoolId = "us-east-1:5c8b88b8-655b-4862-8d8b-9c242f0fd810"
    
    let credentialsProvider:AWSCognitoCredentialsProvider = AWSCognitoCredentialsProvider(regionType:AWSRegionType.USEast1, identityPoolId: myIdentityPoolId)
    
    let configuration = AWSServiceConfiguration(region:AWSRegionType.USEast1, credentialsProvider:credentialsProvider)
    
    AWSServiceManager.default().defaultServiceConfiguration = configuration
    
    // Set up AWS Transfer Manager Request
    let S3BucketName = "demouploadimage"
    
    // Create UUID for image
    let uuid = UUID().uuidString
    let remoteName = "\(uuid)" + "-post" + "-" + localFileName!
    
    let uploadRequest = AWSS3TransferManagerUploadRequest()
    uploadRequest?.body = generateImageUrl(fileName: remoteName, imageData :imageData) as URL
    uploadRequest?.key = remoteName
    uploadRequest?.bucket = S3BucketName
    uploadRequest?.contentType = "image/jpeg"
    
    let transferManager = AWSS3TransferManager.default()
    
    // Perform file upload
    transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: {  (task:AWSTask<AnyObject>) -> Any? in
      
      DispatchQueue.main.async() {
     //   self.myActivityIndicator.stopAnimating()
      }
      
      if let error = task.error {
        print("Upload failed with error: (\(error.localizedDescription))")
      }
      
      if task.result != nil {
        
        let s3URL = URL(string: "https://s3.amazonaws.com/\(S3BucketName)/\(uploadRequest!.key!)")!
        print("Uploaded to:\n\(s3URL)")
        
        // Remove locally stored file
        self.remoteImageWithUrl(fileName: uploadRequest!.key!)
        
        DispatchQueue.main.async() {
          // Saving url of image after upload
          self.post.postItems[index].imageUrl = "\(s3URL)"
          self.countImage += 1
          if self.countImage == self.post.postItems.count {
            self.sendPostRequestToServer()
          }
        
        }
      }
      else {
        print("Unexpected empty result.")
      }
      return nil
    })
    
  }
}

extension OrderInfoViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showEdit" {
      if let destination = segue.destination as? EditContactViewController {
        destination.contact = Helper.user.contactInformations[position]
      }
    } else if segue.identifier == "showCalendar" {
      if let destination = segue.destination as? CalendarViewController {
        destination.sourceViewController = "OrderInfoViewController"
      }
    }
  }
}

