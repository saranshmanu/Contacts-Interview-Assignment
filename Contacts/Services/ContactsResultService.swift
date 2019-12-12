//
//  ContactsResultService.swift
//  Contacts
//
//  Created by Saransh Mittal on 12/12/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import Foundation
import UIKit

class ContactsResultService {
    func call(completion: @escaping (Bool, Any?) -> ()) {
        var contacts = [Contact]()
        NetworkManager().request(service: .getContact, method: .get, header: [:], parameters: [:]) { (error, result) in
            if let data: [NSDictionary] = result as? [NSDictionary] {
                contacts = self.parseResult(result: data)
                completion(false, contacts)
            } else {
                completion(true, contacts)
            }
        }
    }
    
    func getContactDetails(uuid: Int, completion: @escaping (Bool, Any?) -> ()) {
        let server = NetworkManager()
        server.contactUUID = uuid
        server.request(service: .getContactDetails, method: .get, header: [:], parameters: [:]) { (error, result) in
            if let data: NSDictionary = result as? NSDictionary {
                completion(false, data)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func parseContact(data: NSDictionary, completion: @escaping (Any?) -> ()) {
        let uuid = data["id"] as! Int
        getContactDetails(uuid: uuid) { (error, result) in
            if error == true {
                completion(nil)
            }
            let contact = result as! NSDictionary
            let flag = Contact()
            if let uuid: Int = contact["id"] as? Int {
                flag.uuid = uuid
            }
            if let phoneNumber: String = contact["phone_number"] as? String {
                flag.phoneNumber = phoneNumber
            }
            if let firstName: String = contact["first_name"] as? String {
                flag.firstName = firstName
            }
            if let lastName: String = contact["last_name"] as? String {
                flag.lastName = lastName
            }
            if let isFavourite: Bool = contact["favorite"] as? Bool {
                flag.isFavourite = isFavourite
            }
            if let email: String = contact["email"] as? String {
                flag.email = email
            }
            completion(flag)
        }
    }
    
    func parseResult(result: [NSDictionary]) -> [Contact] {
        var contacts = [Contact]()
        for contact in result {
            self.parseContact(data: contact) { (data) in
                if data != nil {
                    let result = data as! Contact
                    print(result.firstName)
                    contacts.append(result)
                }
            }
        }
        return contacts
    }
}
