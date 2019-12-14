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
    
    enum InvalidTextFieldCode: String {
        case firstNameEmpty = "First name cannot be left blank"
        case lastNameEmpty = "Last name cannot be left blank"
        case firstNameShort = "First name is too short (minimum is 2 characters)"
        case lastNameShort = "Last name is too short (minimum is 2 characters)"
        case emailFormatInvalid = "Invalid email address"
        case phoneNumberFormatInvalid = "Invalid phone number"
    }
    
    @objc dynamic var uuid: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var phoneNumber: String = ""
    @objc dynamic var isFavourite: Bool = false
    @objc dynamic var email: String = ""
    var profileImage: UIImageView?
    
    override class func primaryKey() -> String? {
        return "uuid"
    }
    
    static func ==(first: Contact, second: Contact) -> Bool {
      return (first.uuid == second.uuid)
        && (first.firstName == second.firstName)
        && (first.lastName == second.lastName)
        && (first.email == second.email)
        && (first.phoneNumber == second.phoneNumber)
        && (first.isFavourite == second.isFavourite)
    }
    
    func checkInvalidTextFields() -> [InvalidTextFieldCode] {
        var codes = [InvalidTextFieldCode]()
        (self.firstName.isEmpty) ? codes.append(.firstNameEmpty) : (self.firstName.count) < 2 ? codes.append(.firstNameShort) : ()
        (self.lastName.isEmpty) ? codes.append(.lastNameEmpty) : (self.lastName.count) < 2 ? codes.append(.lastNameShort) : ()
        !(self.email.isEmpty) && !(self.email.isValidEmail) ? codes.append(.emailFormatInvalid) : ()
        !(self.phoneNumber.isEmpty) && !(self.phoneNumber.isValidContact) ? codes.append(.phoneNumberFormatInvalid) : ()
        return codes
    }
}
