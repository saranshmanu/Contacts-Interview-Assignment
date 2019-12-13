//
//  ContactAPINetworkService.swift
//  Contacts
//
//  Created by Saransh Mittal on 12/12/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import Foundation
import RealmSwift

protocol ContactNetworkServiceDelegate {
    func refresh(status: Bool)
}

class ContactAPINetworkService {
    
    public var delegate: ContactNetworkServiceDelegate?
    
    enum NetworkStatus: String {
        case starting = "starting"
        case completed = "completed"
    }

    static var contactUpdateBuffer = [Contact]()
    static var refreshStatus: NetworkStatus = .completed {
        didSet {
            if refreshStatus == .completed && !contactUpdateBuffer.isEmpty {
                let updatedContacts = ContactAPINetworkService.contactUpdateBuffer
                for flag in updatedContacts {
                    ContactAPINetworkService().updateContactDetails(with: flag.uuid, data: flag)
                }
            }
        }
    }
    
    // get all contact list from the server
    func refreshContactDetails() {
        ContactAPINetworkService.refreshStatus = .starting
        NetworkManager().request(service: .getContact) { (error, result) in
            if let data: [NSDictionary] = result as? [NSDictionary] {
                // starting the process to get all contact details
                self.parseContactList(result: data) { result in
                    let contactList = result as! [Contact]
                    self.saveData(contactList: contactList)
                    ContactAPINetworkService.refreshStatus = .completed
                    self.delegate?.refresh(status: true)
                }
            } else {
                // failed to update the contact list
                ContactAPINetworkService.refreshStatus = .completed
                self.delegate?.refresh(status: false)
            }
        }
    }
    
    func parseContactList(result: [NSDictionary], completion: @escaping (Any?) -> ()) {
        var contacts = [Contact]()
        var counter = 0
        for contact in result {
            let uuid = contact["id"] as! Int
            getContactDetails(uuid: uuid) { (error, response) in
                if let contact: Contact = response as? Contact {
                    contacts.append(contact)
                    counter = counter + 1
                    if counter == result.count {
                        completion(contacts)
                    }
                }
            }
        }
    }
    
    // get contact information with UUID from the server
    func getContactDetails(uuid: Int, completion: @escaping (Bool, Any?) -> ()) {
        let server = NetworkManager()
        server.uuid = uuid
        server.request(service: .getContactDetails) { (error, result) in
            if let data: NSDictionary = result as? NSDictionary {
                let contact = self.parseContactJSON(contact: data)
                completion(false, contact)
            } else {
                completion(true, nil)
            }
        }
    }
    
    // update the contact favourite statust
    func updateContactFavoriteStatus(to status: Bool, uuid: Int) {
        let realm = try! Realm()
        let query = realm.objects(Contact.self).filter("uuid == \(uuid)").first
        try! realm.write {
            query?.isFavourite = status
            
        }
        let data: Contact = query!
        if ContactAPINetworkService.refreshStatus == .starting {
            ContactAPINetworkService.contactUpdateBuffer.append(data)
        } else {
            let server = NetworkManager()
            server.uuid = uuid
            server.request(service: .putContactDetails, parameters: createContactJSON(data: data)) { (error, result) in
                if error == false {
                    print("Updated the value with uuid: \(data.uuid)")
                } else {
                    print("Error for updating the value with uuid: \(data.uuid)")
                }
            }
        }
    }
    
    // update the new contact information
    func updateContactDetails(with uuid: Int, data: Contact) {
        let realm = try! Realm()
        let query = realm.objects(Contact.self).filter("uuid == \(uuid)").first
        try! realm.write {
            query?.firstName = data.firstName
            query?.lastName = data.lastName
            query?.email = data.email
            query?.phoneNumber = data.phoneNumber
        }
        if ContactAPINetworkService.refreshStatus == .starting {
            ContactAPINetworkService.contactUpdateBuffer.append(data)
        } else {
            let server = NetworkManager()
            server.uuid = data.uuid
            server.request(service: .putContactDetails, parameters: createContactJSON(data: data)) { (error, result) in
                if error == false {
                    print("Updated the value with uuid: \(data.uuid)")
                } else {
                    print("Error for updating the value with uuid: \(data.uuid)")
                }
            }
        }
    }
    
    // create a new contact
    func createContactDetails(data: Contact) {
        NetworkManager().request(service: .postContactDetails, parameters: createContactJSON(data: data)) { (error, result) in
            if error == false {
                if let data: NSDictionary = result as? NSDictionary {
                    let contact = self.parseContactJSON(contact: data)
                    self.saveData(contactList: [contact])
                    print("Created the value with uuid: \(contact.uuid)")
                }
            } else {
                print("Error for creating the value")
            }
        }
    }
    
    func parseContactJSON(contact: NSDictionary) -> Contact {
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
        return flag
    }
    
    private func createContactJSON(data: Contact) -> [String: Any] {
        return [
            "first_name": data.firstName as String,
            "last_name": data.lastName as String,
            "phone_number": data.phoneNumber as String,
            "favorite": data.isFavourite as Bool,
            "email": data.email as String
        ] as [String : Any]
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
    
    func getRealmFileDirectory() {
        let realm = try! Realm()
        let folderPath = realm.configuration.fileURL!.deletingLastPathComponent().path
        print(folderPath)
    }
}
