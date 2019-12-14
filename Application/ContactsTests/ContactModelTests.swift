//
//  ContactModelTests.swift
//  ContactsTests
//
//  Created by Saransh Mittal on 14/12/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import XCTest
@testable import Contacts

class ContactModelTests: XCTestCase {
    
    func getMockContactDataOne() -> Contact {
        let mockContactData = Contact()
        mockContactData.firstName = "Narendra"
        mockContactData.lastName = "Modi"
        mockContactData.phoneNumber = "9999888876"
        mockContactData.email = "test.case@example.com"
        mockContactData.isFavourite = false
        return mockContactData
    }
    
    func getMockContactDataTwo() -> Contact {
        let mockContactData = Contact()
        mockContactData.firstName = "Saransh"
        mockContactData.lastName = "Mittal"
        mockContactData.phoneNumber = "9999888867"
        mockContactData.email = "saransh.mittal@example.com"
        mockContactData.isFavourite = true
        return mockContactData
    }
    
    func testContactModelEquality() {
        XCTAssertTrue(getMockContactDataOne()==getMockContactDataOne())
        XCTAssertFalse(getMockContactDataOne()==getMockContactDataTwo())
    }
    
    func testInvalidContactDetailReturnsInvalidCodes() {
        let mockContact: Contact = getMockContactDataOne()
        XCTAssertEqual(mockContact.checkInvalidTextFields().count, 0)
        mockContact.firstName = ""
        XCTAssertEqual(mockContact.checkInvalidTextFields().count, 1)
        mockContact.lastName = ""
        XCTAssertEqual(mockContact.checkInvalidTextFields().count, 2)
        mockContact.email = "THIS_IS_AN_INVALID_EMAIL"
        XCTAssertEqual(mockContact.checkInvalidTextFields().count, 3)
        mockContact.phoneNumber = "THIS_IS_AN_INVALID_PHONE_NUMBER"
        XCTAssertEqual(mockContact.checkInvalidTextFields().count, 4)
    }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
