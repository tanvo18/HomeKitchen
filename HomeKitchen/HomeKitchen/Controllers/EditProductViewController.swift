//
//  EditProductViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/11/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit
import AWSCore
import AWSS3
import Photos
import Kingfisher

class EditProductViewController: UIViewController {
  // MARK: IBOutlet
  @IBOutlet weak var foodImageView: UIImageView!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var priceTextField: UITextField!
  @IBOutlet weak var typeTextField: UITextField!
  @IBOutlet weak var statusTextField: UITextField!
  
  var listStatus: [String] = ["Ẩn","Hiển thị"]
  var selectedStatus: String = ""
  var selectedImageUrl: URL!
  var myActivityIndicator: UIActivityIndicatorView!
  // Param for post to server
  var imageUrl: String = ""
  var product: Product!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Set default image for imageview
    foodImageView.image = UIImage(named: "photoalbum")
    // Tapping kitchenCoverImageView
    let tapImage = UITapGestureRecognizer(target: self, action: #selector(displayImagePicker))
    foodImageView.isUserInteractionEnabled = true
    foodImageView.addGestureRecognizer(tapImage)
    // Tab outside to close keyboard
    let tapOutside: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
    view.addGestureRecognizer(tapOutside)
    // Status picker
    createStatusPicker()
    createToolbarForStatusPicker()
    // Right item button
    settingRightButtonItem()
    // Setup indicator
    setUpActivityIndicator()
    // Set default value for statusTextField
    statusTextField.text = "public"
    // Init information when start viewcontroller
    parseProductInformation()
    // Set number pad for price textfield
    priceTextField.keyboardType = .numberPad
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

// MARK: Picker Delegate and Datasource
extension EditProductViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return listStatus.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return listStatus[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedStatus = listStatus[row]
    statusTextField.text = selectedStatus
  }
}

// MARK: Function
extension EditProductViewController {
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
  
  // Give product information for textfield and imageview
  func parseProductInformation() {
    nameTextField.text = product.name
    priceTextField.text = "\(product.price)"
    typeTextField.text = product.type
    
    // Change status to Vietnamese
    if product.status == "private" {
      statusTextField.text = "Ẩn"
    } else if product.status == "public" {
      statusTextField.text = "Hiển thị"
    }
    
    downloadProductImage(imageUrl: product.imageUrl)
    // Set default for imageURL in case customer only change information, not change image
    self.imageUrl = product.imageUrl
  }
  
  // MARK: download image with url
  func downloadProductImage(imageUrl: String) {
    let url = URL(string: imageUrl)!
    ImageDownloader.default.downloadImage(with: url, options: [], progressBlock: nil) {
      (image, error, url, data) in
      self.foodImageView.image = image
    }
  }
  
  func createStatusPicker() {
    let statusPicker = UIPickerView()
    statusPicker.delegate = self
    statusTextField.inputView = statusPicker
  }
  
  // Toolbar for statusPicker
  func createToolbarForStatusPicker() {
    // Create a toolbar
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    // Add a done button on this toolbar
    let doneButton = UIBarButtonItem(title: "Xong", style: .done, target: nil, action: #selector(doneClicked))
    toolbar.setItems([doneButton], animated: true)
    statusTextField.inputAccessoryView = toolbar
  }
  
  // Click done button on toolbar of statusPicker
  func doneClicked() {
    self.dismissKeyboard()
  }
  
  func settingRightButtonItem() {
    let rightButtonItem = UIBarButtonItem.init(
      title: "Sửa",
      style: .done,
      target: self,
      action: #selector(rightButtonAction(sender:))
    )
    self.navigationItem.rightBarButtonItem = rightButtonItem
  }
  
  func rightButtonAction(sender: UIBarButtonItem) {
    if checkNotNil() {
      postProductToServer()
    } else {
      self.alertError(message: "Yêu cầu nhập tất cả các trường")
    }
  }
  
  func postProductToServer() {
    myActivityIndicator.startAnimating()
    guard let productName = nameTextField.text, let productPrice = priceTextField.text, let type = typeTextField.text, var status = statusTextField.text else {
      return
    }
    
    // Change status from Vietnamese to English
    if status == "Ẩn" {
      status = "private"
    } else if status == "Hiển thị" {
      status = "public"
    }
    
    let productId = self.product.id
    NetworkingService.sharedInstance.editProduct(id: productId, productName: productName, productPrice: productPrice, type: type, imageUrl: self.imageUrl, status: status) {
      [unowned self] (message,error) in
      if error != nil {
        print(error!)
        self.alertError(message: "Gửi thất bại")
        self.myActivityIndicator.stopAnimating()
      } else {
        self.myActivityIndicator.stopAnimating()
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
          self.performSegue(withIdentifier: "unwindToEditKitchenController", sender: self)
        })
        self.alertWithAction(message: "Thành công", action: ok)
      }
    }
  }
  
  func checkNotNil() -> Bool {
    if  nameTextField.text!.isEmpty || priceTextField.text!.isEmpty || typeTextField.text!.isEmpty || statusTextField.text!.isEmpty{
      return false
    } else {
      return true
    }
  }
}

// MARK: Function of UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension EditProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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
    
    foodImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    foodImageView.backgroundColor = UIColor.clear
    foodImageView.contentMode = UIViewContentMode.scaleAspectFit
    self.dismiss(animated: true, completion: nil)
    
    // upload image and post product to server on upload image function
    startUploadingImage()
  }
  
}

// MARK: Generate image and interact with AWS S3
extension EditProductViewController {
  func generateImageUrl(fileName: String) -> URL
  {
    let fileURL = URL(fileURLWithPath: NSTemporaryDirectory().appending(fileName))
    let data = UIImageJPEGRepresentation(foodImageView.image!, 0.6)
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
    
    // Follow product id to update this image
    let remoteName = "\(product.id)" + "-" + localFileName!
//    let remoteName = localFileName!"
    
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
          // Post product
          self.postProductToServer()
        }
      }
      else {
        print("Unexpected empty result.")
      }
      return nil
    })
    
  }
}

