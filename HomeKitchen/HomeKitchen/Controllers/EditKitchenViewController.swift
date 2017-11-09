//
//  EditKitchenViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/10/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit
import ObjectMapper
import Kingfisher
import AWSCore
import AWSS3
import Photos

class EditKitchenViewController: UIViewController {
  
  // MARK: IBOutlet
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var districtLabel: UILabel!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var countryLabel: UILabel!
  @IBOutlet weak var kitchenCoverImageView: UIImageView!
  @IBOutlet weak var descriptionTextView: UITextView!
  var myActivityIndicator: UIActivityIndicatorView!
  
  // MARK: UITextField
  var openingTimeTextField: UITextField!
  var closingTimeTextField: UITextField!
  var kitchenNameTF: UITextField!
  var typeTF: UITextField!
  var streetAddressTF: UITextField!
  var phoneNumberTF: UITextField!
  var isReadyForEdit: Bool = false
  var kitchen: Kitchen? {
    didSet {
      // avoid reset data in the second time
      if isFirstTime {
        parseKitchenData()
        tableView.reloadData()
        downloadImage(imageUrl: kitchen!.imageUrl)
        isFirstTime = false
        imageUrl = kitchen!.imageUrl
        myActivityIndicator.stopAnimating()
      }
    }
  }
  
  let reuseableCreateCell = "CreateCell"
  let reuseableTimeCell = "TimeCell"
  let data = [["Kitchen's name", "Bussiness type", "Street address","Phone number"],["Opening time"]]
  let headerTitles = ["Thông tin bắt buộc", "Thông tin thêm"]
  let sectionOnePlaceHolder = ["Tên bếp", "Kiểu bếp", "Địa chỉ","Số điện thoại"]
  let datePicker = UIDatePicker()
  
  // Recognize function tapCity or tapDistrict
  var distinguishFunction = ""
  let FUNCTION_TAP_DISTRICT = "tab_district"
  let FUNCTION_TAP_CITY = "tab_city"
  let INVALID_CITY = "Thành phố"
  // Recognize index of city in array to choose district
  var cityIndex = 0
  
  var selectedImageUrl: URL!
  // Check the first time go to EditKitchen Controller to set image
  var isFirstTime: Bool = true
  // Param for post to server
  var imageUrl: String = ""
  // Right button in navigation bar
  var rightButtonItem: UIBarButtonItem = UIBarButtonItem()
  
  // Type of kitchens
  var listType: [String] = ["Ăn chay","Bánh","Ăn vặt","Cơm văn phòng","Đồ nướng","Đặc sản miền Bắc","Đặc sản miền Trung","Đặc sản miền Nam"]
  var selectedType: String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "CreateKitchenTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCreateCell)
    tableView.register(UINib(nibName: "CustomTimeTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableTimeCell)
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    // Tab outside to close keyboard
    let tapOutside: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
    view.addGestureRecognizer(tapOutside)
    
    // Tapping cityLabel
    let tapCity = UITapGestureRecognizer(target: self, action: #selector(tapCityLabel))
    cityLabel.isUserInteractionEnabled = true
    cityLabel.addGestureRecognizer(tapCity)
    // Tapping districtLabel
    let tap = UITapGestureRecognizer(target: self, action: #selector(tapDistrictLabel))
    districtLabel.isUserInteractionEnabled = true
    districtLabel.addGestureRecognizer(tap)
    // Tapping kitchenCoverImageView
    let tapImage = UITapGestureRecognizer(target: self, action: #selector(displayImagePicker))
    kitchenCoverImageView.isUserInteractionEnabled = true
    kitchenCoverImageView.addGestureRecognizer(tapImage)
    // Navigation bar
    self.settingForNavigationBar(title: "Thông tin bếp ăn")
    settingRightButtonItem()
    // Set image default when start controller
    kitchenCoverImageView.image = UIImage(named: "photoalbum")
    // Setup indicator
    setUpActivityIndicator()
    // Start indicator for download image
    myActivityIndicator.startAnimating()
    // Init Menu Button
    let menuButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(self.didTouchMenuButton))
    self.navigationItem.leftBarButtonItem  = menuButton
    // Disable tableview scroll
    tableView.isScrollEnabled = false
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // MARK: enable sidemenu
    sideMenuManager?.sideMenuController()?.sideMenu?.disabled = false
    requestKitchenInfo()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}

// MARK: tableView Delegate
extension EditKitchenViewController: UITableViewDelegate {
  
}

// MARK: tableView Datasource
extension EditKitchenViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data[section].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 1 && indexPath.row == 0 {
      let timeCell = tableView.dequeueReusableCell(withIdentifier: reuseableTimeCell) as! CustomTimeTableViewCell
      // Be careful when reference a textField with cell because if tableview small and cell is hide from view this will lead nil for reference variables and crash
      openingTimeTextField = timeCell.openingTextField
      closingTimeTextField = timeCell.closingTextField
      timeCell.openingTextField.text = kitchen?.open
      timeCell.closingTextField.text = kitchen?.close
      createPickerForOpeningTF(timeTextField: openingTimeTextField)
      createPickerForClosingTF(timeTextField: closingTimeTextField)
      // Set image for imageViewCell section 2
      timeCell.imageViewCell.image = UIImage(named: Helper.createKitchenCellSection2[indexPath.row])
      // Disable textField when not ready for edit
      if isReadyForEdit {
        timeCell.backgroundColor = .white
        timeCell.isUserInteractionEnabled = true
      } else {
        timeCell.backgroundColor = .lightGray
        timeCell.isUserInteractionEnabled = false
      }
      return timeCell
    } else {
      let createKitchenCell = tableView.dequeueReusableCell(withIdentifier: reuseableCreateCell) as! CreateKitchenTableViewCell
      // Set image for imageViewCell section 1
      createKitchenCell.imageViewCell.image = UIImage(named: Helper.createKitchenCellSection1[indexPath.row])
      // Be careful when reference a textField with cell because if tableview small and cell is hide from view this will lead nil for reference variables and crash
      if indexPath.row == 0 {
        kitchenNameTF = createKitchenCell.textFieldCell
        createKitchenCell.textFieldCell.text = kitchen?.name
      } else if indexPath.row == 1 {
        typeTF = createKitchenCell.textFieldCell
        createKitchenCell.textFieldCell.text = kitchen?.type
        // Create picker for type row
        createTypePicker(textField: createKitchenCell.textFieldCell)
        createToolbar(textField: createKitchenCell.textFieldCell)
        
      } else if indexPath.row == 2 {
        streetAddressTF = createKitchenCell.textFieldCell
        createKitchenCell.textFieldCell.text = kitchen?.address?.address
      } else if indexPath.row == 3 {
        // Set number type for phone number textfield
        createKitchenCell.textFieldCell.keyboardType = .numberPad
        phoneNumberTF = createKitchenCell.textFieldCell
        createKitchenCell.textFieldCell.text = kitchen?.address?.phoneNumber
      }
      createKitchenCell.configureWithItem(title: sectionOnePlaceHolder[indexPath.row])
      // Disable textField when not ready for edit
      if isReadyForEdit {
        createKitchenCell.backgroundColor = .white
        createKitchenCell.isUserInteractionEnabled = true
      } else {
        createKitchenCell.backgroundColor = .lightGray
        createKitchenCell.isUserInteractionEnabled = false
      }
      
      return createKitchenCell
    }
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section < headerTitles.count {
      return headerTitles[section]
    }
    return nil
  }
}

// MARK: Function
extension EditKitchenViewController {
  func createPickerForOpeningTF(timeTextField: UITextField) {
    // Format the display of datepicker
    datePicker.datePickerMode = .time
    // using Great Britain for 24 hour system
    datePicker.locale = Locale(identifier: "en_GB")
    timeTextField.inputView = datePicker
    // Create a toolbar
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    // Add a done button on this toolbar
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(didTouchOpeningDoneButton))
    toolbar.setItems([doneButton], animated: true)
    timeTextField.inputAccessoryView = toolbar
  }
  
  func didTouchOpeningDoneButton() {
    // Format the date displays on textfield
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short
    // Change 12 hour system to 24 hour system
    let dateAsString = dateFormatter.string(from: datePicker.date)
    dateFormatter.dateFormat = "h:mm a"
    let date = dateFormatter.date(from: dateAsString)
    
    dateFormatter.dateFormat = "HH:mm"
    let date24 = dateFormatter.string(from: date!)
    openingTimeTextField.text = date24
    self.view.endEditing(true)
  }
  
  func createPickerForClosingTF(timeTextField: UITextField) {
    // Format the display of datepicker
    datePicker.datePickerMode = .time
    // using Great Britain for 24 hour system
    datePicker.locale = Locale(identifier: "en_GB")
    timeTextField.inputView = datePicker
    // Create a toolbar
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    // Add a done button on this toolbar
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(didTouchClosingDoneButton))
    toolbar.setItems([doneButton], animated: true)
    timeTextField.inputAccessoryView = toolbar
  }
  
  func didTouchClosingDoneButton() {
    // Format the date displays on textfield
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short
    // Change 12 hour system to 24 hour system
    let dateAsString = dateFormatter.string(from: datePicker.date)
    dateFormatter.dateFormat = "h:mm a"
    let date = dateFormatter.date(from: dateAsString)
    
    dateFormatter.dateFormat = "HH:mm"
    let date24 = dateFormatter.string(from: date!)
    closingTimeTextField.text = date24
    self.view.endEditing(true)
  }
  
  func tapDistrictLabel(sender:UITapGestureRecognizer) {
    if cityLabel.text! != INVALID_CITY {
      distinguishFunction = FUNCTION_TAP_DISTRICT
      performSegue(withIdentifier: "showLocation", sender: self)
    } else {
      self.alertError(message: "Bạn phải chọn thành phố trước")
    }
  }
  
  func tapCityLabel(sender:UITapGestureRecognizer) {
    distinguishFunction = FUNCTION_TAP_CITY
    performSegue(withIdentifier: "showLocation", sender: self)
  }
  
  func settingRightButtonItem() {
    self.rightButtonItem = UIBarButtonItem.init(
      title: "Sửa",
      style: .done,
      target: self,
      action: #selector(rightButtonAction(sender:))
    )
    self.navigationItem.rightBarButtonItem = rightButtonItem
  }
  
  func rightButtonAction(sender: UIBarButtonItem) {
    if checkNotNil() {
      if isReadyForEdit {
        postKitchenToServer()
      } else {
        self.rightButtonItem.title = "Xong"
        isReadyForEdit = true
        tableView.reloadData()
      }
    } else {
      self.alertError(message: "Yêu cầu nhập tất cả các trường")
    }
  }
  
  func postKitchenToServer() {
    let imageUrl = self.imageUrl
    let address = Address(city: cityLabel.text!, district: districtLabel.text!, address: streetAddressTF.text!, phoneNumber: phoneNumberTF.text!)
    guard let id = kitchen?.id, let openingTime = openingTimeTextField.text,let closingTime = closingTimeTextField.text, let kitchenName = kitchenNameTF.text, let type = typeTF.text, let description = descriptionTextView.text else {
      return
    }
    NetworkingService.sharedInstance.editKitchen(id: id, openingTime: openingTime, closingTime: closingTime, kitchenName: kitchenName, imageUrl: imageUrl, type: type, description: description, address: address) {
      [unowned self] (message,error) in
      if error != nil {
        print(error!)
        self.alertError(message: "Gửi thất bại")
      } else {
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
          // Go to Home Screen
          self.performSegue(withIdentifier: "showHomeScreen", sender: self)
        })
        self.alertWithAction(message: "Thành công", action: ok)
      }
    }
  }
  
  
  func setCurrentDate() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let result = formatter.string(from: date)
    return result
  }
  
  func checkNotNil() -> Bool {
    if  kitchenNameTF.text!.isEmpty || typeTF.text!.isEmpty || streetAddressTF.text!.isEmpty || phoneNumberTF.text!.isEmpty{
      return false
    } else if districtLabel.text! == "Chọn quận" {
      return false
    } else {
      return true
    }
  }
  
  func requestKitchenInfo() {
    NetworkingService.sharedInstance.getKitchenInfo() {
      [unowned self] (kitchen,error) in
      if error != nil {
        print(error!)
      } else {
        self.kitchen = kitchen
      }
    }
  }
  
  func parseKitchenData() {
    descriptionTextView.text = kitchen?.description
    districtLabel.text = kitchen?.address?.district
    cityLabel.text = kitchen?.address?.city
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
  
  // Download image with url
  func downloadImage(imageUrl: String) {
    let url = URL(string: imageUrl)!
    ImageDownloader.default.downloadImage(with: url, options: [], progressBlock: nil) {
      (image, error, url, data) in
      self.kitchenCoverImageView.image = image
    }
  }
  
  // Toggle slide menu
  func didTouchMenuButton(_ sender: Any) {
    sideMenuManager?.toggleSideMenuView()
  }
  
  func createTypePicker(textField: UITextField) {
    let statusPicker = UIPickerView()
    statusPicker.delegate = self
    textField.inputView = statusPicker
  }
  
  // Toolbar for typePicker
  func createToolbar(textField: UITextField) {
    // Create a toolbar
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    // Add a done button on this toolbar
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
    toolbar.setItems([doneButton], animated: true)
    textField.inputAccessoryView = toolbar
  }
  
  // Click done button on toolbar of statusPicker
  func doneClicked() {
    self.dismissKeyboard()
  }
  
}

extension EditKitchenViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return listType.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return listType[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedType = listType[row]
    typeTF.text = selectedType
  }
}

// MARK: Function of UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension EditKitchenViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
  // Show image picker
  func displayImagePicker(sender:UITapGestureRecognizer) {
    let myPickerController = UIImagePickerController()
    myPickerController.delegate = self;
    myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
    self.present(myPickerController, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
  {
    selectedImageUrl = info[UIImagePickerControllerReferenceURL] as! URL
    
    kitchenCoverImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    kitchenCoverImageView.backgroundColor = UIColor.clear
    kitchenCoverImageView.contentMode = UIViewContentMode.scaleAspectFit
    self.dismiss(animated: true, completion: nil)
    
    // upload image and post kitchen in method upload after picking image
    startUploadingImage()
  }
}

// MARK: Generate image and interact with AWS S3
extension EditKitchenViewController {
  func generateImageUrl(fileName: String) -> URL
  {
    let fileURL = URL(fileURLWithPath: NSTemporaryDirectory().appending(fileName))
    let data = UIImageJPEGRepresentation(kitchenCoverImageView.image!, 0.6)
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
  
  func startUploadingImage()
  {
    var localFileName:String?
    
    if let imageToUploadUrl = selectedImageUrl
    {
      let phResult = PHAsset.fetchAssets(withALAssetURLs: [imageToUploadUrl as URL], options: nil)
      // localFileName = phResult.firstObject?.value(forKey: "filename") as! String
      localFileName = PHAssetResource.assetResources(for: phResult.firstObject!).first!.originalFilename
      print("=====\(localFileName!)")
    }
    
    if localFileName == nil
    {
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
    
    // Add kitchenId to remoteName to assure this image is belong to kitchen and this image is unique
    let remoteName = "\(kitchen!.id)" + "-" + localFileName!
    
    let uploadRequest = AWSS3TransferManagerUploadRequest()
    uploadRequest?.body = generateImageUrl(fileName: remoteName) as URL
    uploadRequest?.key = remoteName
    uploadRequest?.bucket = S3BucketName
    uploadRequest?.contentType = "image/jpeg"
    
    let transferManager = AWSS3TransferManager.default()
    
    // Perform file upload
    transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: {  (task:AWSTask<AnyObject>) -> Any? in
      
      DispatchQueue.main.async() {
        self.myActivityIndicator.stopAnimating()
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
          // Saving url of image
          self.imageUrl = "\(s3URL)"
          // Post kitchen
          self.postKitchenToServer()
        }
      }
      else {
        print("Unexpected empty result.")
      }
      return nil
    })
    
  }
}

// MARK: IBAction
extension EditKitchenViewController {
  @IBAction func unwindToEditKitchenController(segue:UIStoryboardSegue) {
    if segue.source is LocationViewController {
      if let senderVC = segue.source as? LocationViewController {
        if distinguishFunction == FUNCTION_TAP_CITY {
          cityLabel.text = senderVC.selectedLocation
          switch senderVC.selectedLocation {
          case "Hà Nội":
            cityIndex = 0
          case "Đà Nẵng":
            cityIndex = 1
          case "TP. HCM":
            cityIndex = 2
          default:
            break
          }
          // Reset district label to avoid unmatch city with district
          districtLabel.text = "Chọn quận"
        } else if distinguishFunction == FUNCTION_TAP_DISTRICT {
          districtLabel.text = senderVC.selectedLocation
        }
      }
    }
  }
  
  @IBAction func didTouchManageMenuButton(_ sender: Any) {
    performSegue(withIdentifier: "showProducts", sender: self)
  }
}

extension EditKitchenViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showLocation" {
      if let destination = segue.destination as? LocationViewController {
        destination.sourceViewController = "EditKitchenViewController"
        if distinguishFunction == FUNCTION_TAP_CITY {
          destination.locations = Helper.cityLocations
        } else if distinguishFunction == FUNCTION_TAP_DISTRICT {
          destination.locations = Helper.districtLocations[cityIndex]
        }
      }
    } else if segue.identifier == "showProducts" {
      if let destination = segue.destination as? ProductsViewController {
        if let products = kitchen?.products {
          destination.products = products
        }
      }
    }
  }
}


