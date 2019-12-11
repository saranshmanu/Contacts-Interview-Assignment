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
    var uuid: String
    var firstName: String
    var lastName: String
    var phoneNumber: Int
    var profileImage: UIImageView?
    var isFavourite: Bool = false
    var email: String?
    
    init(uuid: String, firstName: String, lastName: String, phoneNumber: Int, isFavourite: Bool, email: String, profileImage: UIImageView) {
        self.uuid = uuid
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.profileImage = profileImage
        self.isFavourite = isFavourite
        self.email = email
    }
}
