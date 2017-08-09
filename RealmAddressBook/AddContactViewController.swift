//
//  AddContactViewController.swift
//  RealmAddressBook
//
//  Created by Patrick Bellot on 8/9/17.
//  Copyright © 2017 Polestar Interactive LLC. All rights reserved.
//

import UIKit
import RealmSwift

class AddContactViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var phoneTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var imageView: UIImageView!
  
  var imageController = UIImagePickerController()
  var contact: Contact?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let passedContact = contact {
      nameTextField.text = passedContact.name
      phoneTextField.text = passedContact.phone
      emailTextField.text = passedContact.email
      
      if let imageData = passedContact.imageData as Data? {
        let image = UIImage(data: imageData)
        imageView.image = image
      }
    }
  }
  
  
  @IBAction func saveTapped(_ sender: Any) {
    
    if let name = nameTextField.text {
      if let email = emailTextField.text {
        if let phone = phoneTextField.text {
          if let image = imageView.image {
            
            if let passedContact = contact {
              let realm = try? Realm()
              try? realm?.write {
                passedContact.name = name
                passedContact.email = email
                passedContact.phone = phone
                
                if let imageData = UIImageJPEGRepresentation(image, 1.0) as NSData?{
                  passedContact.imageData = imageData
                }
              }
            } else {
              let newContact = Contact()
              newContact.name = name
              newContact.phone = phone
              newContact.email = email
              
              if let imageData = UIImageJPEGRepresentation(image, 1.0) as NSData?{
                newContact.imageData = imageData
                
                let realm = try? Realm()
                try? realm?.write {
                  realm?.add(newContact)
                }
              }
            }
            navigationController?.popViewController(animated: true)
          }
        }
      }
    }
  }
  
  @IBAction func addImageTapped(_ sender: Any) {
    imageController.sourceType = .photoLibrary
    imageController.delegate = self
    present(imageController, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      imageView.image = selectedImage
    }
    
    picker.dismiss(animated: true, completion: nil)
  }
  
  
}
