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
    
    func testRefreshDataSuccessReturnsContactList() {
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
    
    func testCreateContactDetailsSuccessReturnsContact() {
//        let mockContactDetails =
    }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
