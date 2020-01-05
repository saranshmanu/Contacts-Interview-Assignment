//
//  ContactAPINetworkService.swift
//  Contacts
//
//  Created by Saransh Mittal on 12/12/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import Foundation
import RealmSwift

protocol ContactAPINetworkServiceProtocol {
    func refreshContactList()
}

class ContactAPINetworkService {
    
    var delegate: ContactAPINetworkServiceProtocol?
    
    private func parseContactsList(result: [NSDictionary], completion: @escaping (Any?) -> ()) {
        var contacts = [Contact]()
        var counter = 0
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "ALAMOFIRE_REQUEST")
        for contact in result {
            dispatchQueue.async {
                let uuid = contact["id"] as! Int
                dispatchGroup.enter()
                self.getContactDetails(uuid: uuid) { (response) in
                    if let contact: Contact = response as? Contact {
                        DispatchQueue.main.async {
                            self.saveData(contactList: [contact])
                            self.delegate?.refreshContactList()
                        }
                        contacts.append(contact)
                    }
                    counter = counter + 1
                    dispatchGroup.leave()
                    if counter == result.count {
                        completion(contacts)
                    }
                }
                dispatchGroup.wait(timeout: .distantFuture)
            }
        }
    }
    // get all contact list from the server
    func getContactsList(completion: @escaping (Any?) -> ()) {
        NetworkManager().request(service: .getContactList) { (error, result) in
            if let data: [NSDictionary] = result as? [NSDictionary] {
                self.parseContactsList(result: data) { result in
                    let contactList = result as! [Contact]
                    self.saveData(contactList: contactList)
                    completion(contactList)
                }
            } else {
                completion(nil)
            }
        }
    }
    // get contact information with UUID from the server
    func getContactDetails(uuid: Int, completion: @escaping (Any?) -> ()) {
        let server = NetworkManager()
        server.uuid = uuid
        server.request(service: .getContactDetails) { (error, result) in
            if let data: NSDictionary = result as? NSDictionary {
                let contact = self.parseContactJSON(contact: data)
                completion(contact)
            } else {
                print("Saransh")
                completion(nil)
            }
        }
    }
    // update the contact favourite statust
    func updateContactFavoriteStatus(to status: Bool, uuid: Int, completion: @escaping (Any?) -> ()) {
        let realm = try! Realm()
        let query = realm.objects(Contact.self).filter("uuid == \(uuid)").first
        try! realm.write {
            query?.isFavourite = status
        }
        if query == nil { completion(nil) }
        let data = query!
        self.updateContact(data: data) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    // update the new contact information
    func updateContactDetails(data: Contact, completion: @escaping (Any?) -> ()) {
        let realm = try! Realm()
        let query = realm.objects(Contact.self).filter("uuid == \(data.uuid)").first
        try! realm.write {
            query?.firstName = data.firstName
            query?.lastName = data.lastName
            query?.email = data.email
            query?.phoneNumber = data.phoneNumber
        }
        if query == nil { completion(nil) }
        self.updateContact(data: data) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    func updateContact(data: Contact, completion: @escaping (Any?) -> ()) {
        let server = NetworkManager()
        server.uuid = data.uuid
        server.request(service: .putContactDetails, parameters: createContactJSON(data: data)) { (error, result) in
            if error == false {
                if let contact: NSDictionary = result as? NSDictionary {
                    let response = self.parseContactJSON(contact: contact)
                    completion(response)
                }
            } else {
                completion(nil)
            }
        }
    }
    // create a new contact
    func createContactDetails(data: Contact, completion: @escaping (Any?) -> ()) {
        NetworkManager().request(service: .postContactDetails, parameters: createContactJSON(data: data)) { (error, result) in
            if error == false {
                if let data: NSDictionary = result as? NSDictionary {
                    let contact = self.parseContactJSON(contact: data)
                    self.saveData(contactList: [contact])
                    self.delegate?.refreshContactList()
                    completion(contact)
                }
            } else {
                completion(nil)
            }
        }
    }
    func parseContactJSON(contact: NSDictionary) -> Contact {
        let flag = Contact()
        if let uuid: Int            = contact["id"] as? Int { flag.uuid = uuid }
        if let phoneNumber: String  = contact["phone_number"] as? String { flag.phoneNumber = phoneNumber }
        if let firstName: String    = contact["first_name"] as? String { flag.firstName = firstName }
        if let lastName: String     = contact["last_name"] as? String { flag.lastName = lastName }
        if let isFavourite: Bool    = contact["favorite"] as? Bool { flag.isFavourite = isFavourite }
        if let email: String        = contact["email"] as? String { flag.email = email }
        return flag
    }
    func createContactJSON(data: Contact) -> [String: Any] {
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
