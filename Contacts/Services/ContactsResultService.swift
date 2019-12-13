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
    
    enum NetworkStatus: String {
        case starting = "starting"
        case completed = "completed"
    }

    static var contactUpdateBuffer = [Contact]()
    public var delegate: ContactsResultServiceDelegate?
    static var refreshStatus: NetworkStatus = .completed {
        didSet {
            if refreshStatus == .completed {
                if !contactUpdateBuffer.isEmpty {
                    let updatedContacts = ContactsResultService.contactUpdateBuffer
                    for flag in updatedContacts {
                        ContactsResultService().updateContactDetails(data: flag)
                    }
                }
            }
        }
    }
    
    
    func getRealmFileDirectory() {
        let realm = try! Realm()
        let folderPath = realm.configuration.fileURL!.deletingLastPathComponent().path
        print(folderPath)
    }
    
    func refreshData() {
        ContactsResultService.refreshStatus = .starting
        NetworkManager().request(service: .getContact) { (error, result) in
            if let data: [NSDictionary] = result as? [NSDictionary] {
                // starting the process to get all contact details
                self.parseContactList(result: data) { result in
                    let contactList = result as! [Contact]
                    self.saveData(contactList: contactList)
                    ContactsResultService.refreshStatus = .completed
                    self.delegate?.refresh()
                }
            } else {
                // failed to update the contact list
                ContactsResultService.refreshStatus = .completed
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
    
    func updateData(with uuid: Int, data: Contact) {
        let realm = try! Realm()
        let query = realm.objects(Contact.self).filter("uuid == \(uuid)").first
        try! realm.write {
            query?.firstName = data.firstName
            query?.lastName = data.lastName
            query?.email = data.email
            query?.phoneNumber = data.phoneNumber
        }
        if ContactsResultService.refreshStatus == .starting {
            ContactsResultService.contactUpdateBuffer.append(data)
        } else {
            updateContactDetails(data: data)
        }
    }
    
    func createContactDetails(data: Contact) {
        let params = [
            "first_name": data.firstName as String,
            "last_name": data.lastName as String,
            "phone_number": data.phoneNumber as String,
            "favorite": data.isFavourite as Bool,
            "email": data.email as String
        ] as [String : Any]
        print(params)
        NetworkManager().request(service: .postContactDetails, parameters: params) { (error, result) in
            print(result as Any)
            if error == false {
                print("Updated the value with uuid: \(data.uuid)")
            } else {
                print("Error for updating the value with uuid: \(data.uuid)")
            }
        }
    }
    
    func updateContactDetails(data: Contact) {
        let server = NetworkManager()
        server.uuid = data.uuid
        let params = [
            "first_name": data.firstName as String,
            "last_name": data.lastName as String,
            "phone_number": data.phoneNumber as String,
            "favorite": data.isFavourite as Bool,
            "email": data.email as String
            ] as [String : Any]
        server.request(service: .putContactDetails, parameters: params) { (error, result) in
            if error == false {
                print("Updated the value with uuid: \(data.uuid)")
            } else {
                print("Error for updating the value with uuid: \(data.uuid)")
            }
        }
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
        let realm = try! Realm()
        try! realm.write {
            for contact in contactList {
                realm.create(Contact.self, value: contact, update: .modified)
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
}
