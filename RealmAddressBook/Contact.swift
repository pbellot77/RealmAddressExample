//
//  Contact.swift
//  RealmAddressBook
//
//  Created by Patrick Bellot on 8/9/17.
//  Copyright © 2017 Polestar Interactive LLC. All rights reserved.
//

import Foundation
import RealmSwift

class Contact: Object {
  dynamic var name = ""
  dynamic var phone = ""
  dynamic var email = ""
  dynamic var imageData: NSData?
}
