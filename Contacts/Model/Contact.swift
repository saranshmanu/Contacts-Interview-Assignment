//
//  Contact.swift
//  Contacts
//
//  Created by Saransh Mittal on 11/12/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import Foundation
import UIKit

class Contact {
    var uuid: Int
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var profileImage: UIImageView?
    var isFavourite: Bool = false
    var email: String
    
    init(uuid: Int? = nil, firstName: String? = nil, lastName: String? = nil, phoneNumber: String? = nil, isFavourite: Bool? = nil, email: String? = nil, profileImage: UIImageView? = nil) {
        self.uuid = uuid ?? 0
        self.firstName = firstName ?? "First Name"
        self.lastName = lastName ?? "Last Name"
        self.phoneNumber = phoneNumber ?? "XXXXXXXXXX"
        self.profileImage = profileImage
        self.isFavourite = isFavourite ?? false
        self.email = email ?? "xxxx@xxxxx.com"
    }
}
