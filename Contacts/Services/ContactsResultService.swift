//
//  ContactsResultService.swift
//  Contacts
//
//  Created by Saransh Mittal on 12/12/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

protocol ContactsResultServiceDelegate {
    func refresh()
}

class ContactsResultService {
    
    public var delegate: ContactsResultServiceDelegate?
    
    func updateData() {
        NetworkManager().request(service: .getContact) { (error, result) in
            if let data: [NSDictionary] = result as? [NSDictionary] {
                // starting the process to get all contact details
                self.parseContactList(result: data) { result in
                    let contactList = result as! [Contact]
                    self.saveData(contactList: contactList)
                    self.delegate?.refresh()
                }
            } else {
                // failed to update the contact list
            }
        }
    }
    
    func postData() {
        NetworkManager().request(service: .getContactDetails, parameters: [:]) { (error, result) in
        }
    }
    
    func getRealmFileDirectory() {
        // Get the Realm file's parent directory
        let realm = try! Realm()
        let folderPath = realm.configuration.fileURL!.deletingLastPathComponent().path
        print(folderPath)
    }
    
    func getData() -> [Contact] {
        let realm = try! Realm()
        let query = realm.objects(Contact.self)
        var contacts = [Contact]()
        for contact in query {
            contacts.append(contact)
        }
        return contacts
    }
    
    func getData(with uuid: Int) -> Contact {
        let realm = try! Realm()
        let query = realm.objects(Contact.self).filter("uuid == \(uuid)").first!
        return query
    }
    
    func saveData(contactList: [Contact]) {
        // using realm to update the database
        let realm = try! Realm()
        try! realm.write {
            for contact in contactList {
                realm.add(contact)
            }
        }
    }
    
    func parseContactList(result: [NSDictionary], completion: @escaping (Any?) -> ()) {
        var contacts = [Contact]()
        let contactListCount = result.count
        var counter = 0
        for contact in result {
            self.parseContact(data: contact) { (data) in
                if data != nil {
                    let result = data as! Contact
                    contacts.append(result)
                }
                counter = counter + 1
                if counter == contactListCount {
                    completion(contacts)
                }
            }
        }
    }
    
    func parseContact(data: NSDictionary, completion: @escaping (Any?) -> ()) {
        let uuid = data["id"] as! Int
        getContactDetails(uuid: uuid) { (error, result) in
            if let contact: NSDictionary = result as? NSDictionary {
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
            } else {
                completion(nil)
            }
        }
    }
    
    func getContactDetails(uuid: Int, completion: @escaping (Bool, Any?) -> ()) {
        let server = NetworkManager()
        server.uuid = uuid
        server.request(service: .getContactDetails) { (error, result) in
            if let data: NSDictionary = result as? NSDictionary {
                completion(false, data)
            } else {
                completion(true, nil)
            }
        }
    }
}
