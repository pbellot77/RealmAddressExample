//
//  ViewController.swift
//  RealmAddressBook
//
//  Created by Patrick Bellot on 8/9/17.
//  Copyright © 2017 Polestar Interactive LLC. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  
  var contactResults: Results<Contact>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let realm = try? Realm()
    contactResults = realm?.objects(Contact.self).sorted(byKeyPath: "name", ascending: false)
    
    testMobilePlatform()
  }
  
  func testMobilePlatform(){
    let serverURL = URL(string: "http://localhost:9080/")
    let usernameCredentials = SyncCredentials.usernamePassword(username: "pat", password: "123abc", register: true)
    
    SyncUser.logIn(with: usernameCredentials, server: serverURL!) { user, error in
      if let user = user {
        print(user)
        
        // Create the configuration
        // Create the configuration
        let syncServerURL = URL(string: "realm://localhost:9080/~/awesomeSauce")!
        let config = Realm.Configuration(syncConfiguration: SyncConfiguration(user: user, realmURL: syncServerURL))
        
        // Open the remote Realm
        let realm = try! Realm(configuration: config)
        // Any changes made to this Realm will be synced across all devices!
        
        let contact = Contact()
        contact.name = "Old Saint Nick"
        contact.phone = "1234567895"
        contact.email = "asdfg@gmail.com"
        
        try? realm.write {
          realm.add(contact)
        }
        
      } else if let error = error {
        print(error)
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let count = contactResults?.count {
      return count
    }
    return 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    let contact = contactResults?[indexPath.row]
    
    cell.textLabel?.text = contact?.name
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let contact = contactResults?[indexPath.row]
    
    performSegue(withIdentifier: "moveToDetail", sender: contact)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let contact = sender as? Contact {
      if let detailVC = segue.destination as? AddContactViewController {
        detailVC.contact = contact
      }
    }
  }


}
