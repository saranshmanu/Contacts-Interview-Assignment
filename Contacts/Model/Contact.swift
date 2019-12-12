//
//  Contact.swift
//  Contacts
//
//  Created by Saransh Mittal on 11/12/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Contact: Object {
    @objc dynamic var uuid: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var phoneNumber: String = ""
    @objc dynamic var isFavourite: Bool = false
    @objc dynamic var email: String = ""
    var profileImage: UIImageView?
}
