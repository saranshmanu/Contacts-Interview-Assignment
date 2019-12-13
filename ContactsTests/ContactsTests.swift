//
//  ContactsTests.swift
//  ContactsTests
//
//  Created by Saransh Mittal on 11/12/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import XCTest
@testable import Contacts
import RealmSwift

class ContactsNetworkManagerTests: XCTestCase {
    
    func testRefreshContactListSuccessReturnsContactList() {
        let server = NetworkManager()
        let contactsServerAPI = ContactAPINetworkService()
        let contactsExpectation = expectation(description: "contacts")
        var contactsResponse: [Contact]?
        
        server.request(service: .getContact) { (error, result) in
            if let data: [NSDictionary] = result as? [NSDictionary] {
                contactsServerAPI.parseContactList(result: data) { result in
                    let contactList = result as! [Contact]
                    contactsResponse = contactList
                    contactsExpectation.fulfill()
                }
            }
        }
        waitForExpectations(timeout: 220) { (error) in
            XCTAssertNotNil(contactsResponse)
        }
    }
    
    func testGetContactSuccessReturnsContact() {
        let contactsServerAPI = ContactAPINetworkService()
        let contactsExpectation = expectation(description: "contactDetails")
        var contactsResponse: Contact?
        contactsServerAPI.getContactDetails(uuid: 13446) { (error, result) in
            if let contact: Contact = result as? Contact {
                contactsResponse = contact
                contactsExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNotNil(contactsResponse)
        }
    }
    
    func getMockData() -> Contact {
        let mockContactData = Contact()
        mockContactData.firstName = "Narendra"
        mockContactData.lastName = "Modi"
        mockContactData.phoneNumber = "9999888876"
        mockContactData.email = "test.case@example.com"
        mockContactData.isFavourite = false
        return mockContactData
    }
    
    func testCreateContactDetailsSuccessReturnsCreatedContact() {
        let mockData = getMockData()
        let contactsServerAPI = ContactAPINetworkService()
        let contactsExpectation = expectation(description: "contactCreation")
        var contactsResponse = Contact()
        contactsServerAPI.createContactDetails(data: mockData) { (response) in
            if let contact: Contact = response as? Contact {
                mockData.uuid = contact.uuid
                contactsServerAPI.getContactDetails(uuid: contact.uuid) { (error, result) in
                    if let data: Contact = result as? Contact {
                        contactsResponse = data
                        contactsExpectation.fulfill()
                    }
                }
            }
        }
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNotNil(contactsResponse)
            XCTAssertTrue(mockData==contactsResponse)
        }
    }
    
    func testUpdateContactDetailsSuccessReturnsUpdatedContact() {
        let mockUUID = 14438
        let mockData = getMockData()
        mockData.uuid = mockUUID
        let contactsServerAPI = ContactAPINetworkService()
        let contactsExpectation = expectation(description: "contactUpdation")
        var contactsResponse = Contact()
        contactsServerAPI.updateContactDetails(with: mockUUID, data: mockData) { (response) in
            if let _: Contact = response as? Contact {
                contactsServerAPI.getContactDetails(uuid: mockUUID) { (error, result) in
                    if let data: Contact = result as? Contact {
                        contactsResponse = data
                        contactsExpectation.fulfill()
                    }
                }
            }
        }
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNotNil(contactsResponse)
            XCTAssertTrue(mockData==contactsResponse)
        }
    }
    
    func testAddToFavoriteContactSuccessReturnsUpdatedContact() {
        let mockUUID = 14438
        let contactsServerAPI = ContactAPINetworkService()
        let contactsExpectation = expectation(description: "contactUpdation")
        var orignalContactsResponse = Contact()
        var updatedContactsResponse = Contact()
        contactsServerAPI.getContactDetails(uuid: mockUUID) { (error, result) in
            if let data: Contact = result as? Contact {
                orignalContactsResponse = data
                contactsServerAPI.updateContactFavoriteStatus(to: !orignalContactsResponse.isFavourite, uuid: orignalContactsResponse.uuid, completion: { response in
                    if let contact: Contact = response as? Contact {
                        updatedContactsResponse = contact
                        contactsExpectation.fulfill()
                    }
                })
            }
        }
        
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNotNil(updatedContactsResponse)
            XCTAssertNotNil(orignalContactsResponse)
            XCTAssertFalse(orignalContactsResponse==updatedContactsResponse)
        }
    }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
