//
//  ContactsUITests.swift
//  ContactsUITests
//
//  Created by Saransh Mittal on 11/12/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import XCTest
@testable import Contacts

class ContactsUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    override func tearDown() {

    }
    
    func testChangeFavoriteContactStatus() {
        
    }
    
    func testCreateContactInformation() {
        
    }

    func testEditContactInformation() {
        let updatedFirstName = "Amit"
        let updatedLastName = "Shah"
        let fullName = "\(updatedFirstName) \(updatedLastName)"
        let app = XCUIApplication()
        app.launch()
        let tablesQuery = app.tables
        let staticText = tablesQuery.staticTexts["Amit Shah"]
        staticText.tap()
        let contactsContactsdetailsviewNavigationBar = app.navigationBars["Contacts.ContactsDetailsView"]
        contactsContactsdetailsviewNavigationBar.buttons["Edit"].tap()
        let textField = tablesQuery.cells.containing(.staticText, identifier:"First Name").children(matching: .textField).element
        textField.tap()
        textField.clearText(andReplaceWith: updatedFirstName)
        let textField2 = tablesQuery.cells.containing(.staticText, identifier:"Last Name").children(matching: .textField).element
        textField2.tap()
        textField2.clearText(andReplaceWith: "Shah")
        let textField3 = tablesQuery.cells.containing(.staticText, identifier:"Email").children(matching: .textField).element
        textField3.tap()
        textField3.clearText(andReplaceWith: "amit.shah@gmail.com")
        let textField4 = tablesQuery.cells.containing(.staticText, identifier:"Phone Number").children(matching: .textField).element
        textField4.tap()
        textField4.clearText(andReplaceWith: "9910749550")
        contactsContactsdetailsviewNavigationBar.buttons["Done"].tap()
        contactsContactsdetailsviewNavigationBar.buttons["Contact"].tap()
        XCTAssert(tablesQuery.staticTexts[fullName].exists)
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}

extension XCUIElement {
    func clearText(andReplaceWith newText:String? = nil) {
        tap()
        press(forDuration: 1.0)
        var select = XCUIApplication().menuItems["Select All"]
        if !select.exists {
            select = XCUIApplication().menuItems["Select"]
        }
        if select.waitForExistence(timeout: 0.5), select.exists {
            select.tap()
            typeText(String(XCUIKeyboardKey.delete.rawValue))
        } else {
            tap()
        }
        if let newVal = newText {
            typeText(newVal)
        }
    }
}
