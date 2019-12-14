//
//  NetworkManagerTests.swift
//  NetworkManagerTests
//
//  Created by Saransh Mittal on 11/12/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import XCTest
@testable import Contacts

class NetworkManagerTests: XCTestCase {
    
    var mockUUID: Int? = nil
    var contactsServerAPI: ContactAPINetworkService? = nil
    
    func testRefreshContactListSuccessReturnsContactList() {
        let contactsExpectation = expectation(description: "Get contact list")
        var contactsResponse: [Contact]?
        contactsServerAPI?.refreshContactDetails(completion: { result in
            if let data: [Contact] = result as? [Contact] {
                contactsResponse = data
                contactsExpectation.fulfill()
            }
        })
        waitForExpectations(timeout: 220) { (error) in
            XCTAssertNotNil(contactsResponse)
        }
    }
    
    func testGetContactSuccessReturnsContact() {
        let contactsExpectation = expectation(description: "Get contact detail for UUID")
        var contactsResponse: Contact?
        contactsServerAPI?.getContactDetails(uuid: 13446) { (error, result) in
            if let contact: Contact = result as? Contact {
                contactsResponse = contact
                contactsExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNotNil(contactsResponse)
        }
    }
    
    func getMockContactData() -> Contact {
        let mockContactData = Contact()
        mockContactData.firstName = "Narendra"
        mockContactData.lastName = "Modi"
        mockContactData.phoneNumber = "9999888876"
        mockContactData.email = "test.case@example.com"
        mockContactData.isFavourite = false
        return mockContactData
    }
    
    func getMockContactJSON() -> NSDictionary {
        return [
          "first_name": "Narendra",
          "last_name": "Modi",
          "phone_number": "9999888876",
          "favorite": false,
          "email": "test.case@example.com"
        ]
    }
    
    func testCreateContactDetailsSuccessReturnsCreatedContact() {
        let mockData = getMockContactData()
        let contactsExpectation = expectation(description: "Create new contact")
        var contactsResponse = Contact()
        contactsServerAPI?.createContactDetails(data: mockData) { (response) in
            if let contact: Contact = response as? Contact {
                mockData.uuid = contact.uuid
                self.contactsServerAPI?.getContactDetails(uuid: contact.uuid) { (error, result) in
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
        let mockData = getMockContactData()
        mockData.uuid = mockUUID
        let contactsExpectation = expectation(description: "Update contact information")
        var contactsResponse = Contact()
        contactsServerAPI?.updateContactDetails(with: mockUUID, data: mockData) { (response) in
            if let _: Contact = response as? Contact {
                self.contactsServerAPI?.getContactDetails(uuid: mockUUID) { (error, result) in
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
        let contactsExpectation = expectation(description: "Add contact to favorites")
        var orignalContactsResponse = Contact()
        var updatedContactsResponse = Contact()
        contactsServerAPI?.getContactDetails(uuid: mockUUID) { (error, result) in
            if let data: Contact = result as? Contact {
                orignalContactsResponse = data
                self.contactsServerAPI?.updateContactFavoriteStatus(to: !orignalContactsResponse.isFavourite, uuid: orignalContactsResponse.uuid, completion: { response in
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
    
    func testParseContactJSON() {
        let contactsExpectation = expectation(description: "Parse contact JSON")
        let parsedContact: Contact = (contactsServerAPI?.parseContactJSON(contact: getMockContactJSON()))!
        contactsExpectation.fulfill()
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNotNil(parsedContact)
            XCTAssertTrue(parsedContact==self.getMockContactData())
            XCTAssertFalse(parsedContact==Contact())
        }
    }
    
    func testCreateContactJSON() {
        let contactsExpectation = expectation(description: "Parse contact JSON")
        let contactJSON = contactsServerAPI?.createContactJSON(data: getMockContactData())
        contactsExpectation.fulfill()
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNotNil(contactJSON)
            XCTAssertTrue(self.getMockContactJSON() == contactJSON! as NSDictionary)
        }
    }

    override func setUp() {
        mockUUID = 14438
        contactsServerAPI = ContactAPINetworkService()
    }

    override func tearDown() {
    }

}
