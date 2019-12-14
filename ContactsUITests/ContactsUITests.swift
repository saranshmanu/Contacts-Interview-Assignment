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

    var app: XCUIApplication? = nil
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app?.launch()
    }

    override func tearDown() {
    }
    
    func testChangeContactFavoriteStatus() {
        let name = "Amit Shah"
        let tablesQuery = app?.tables
        tablesQuery?.staticTexts[name].firstMatch.tap()
        let favoritesButton = tablesQuery?.buttons["favourite button"]
        let isSelected = favoritesButton?.isSelected
        favoritesButton?.tap()
        let isFavourite = favoritesButton?.isSelected
        XCTAssertFalse(isSelected == isFavourite)
    }
    
    func testCreateContactInformation() {
        let updatedFirstName = "Amit"
        let updatedLastName = "Shah"
        let fullName = "\(updatedFirstName) \(updatedLastName)"
        XCUIApplication().navigationBars["Contact"].buttons["Add"].tap()
        let contactsContactsdetailsviewNavigationBar = app?.navigationBars["Contacts.ContactsDetailsView"]
        let tablesQuery = app?.tables
        let textField = tablesQuery?.cells.containing(.staticText, identifier:"First Name").children(matching: .textField).element
        textField?.tap()
        textField?.clearText(andReplaceWith: updatedFirstName)
        let textField2 = tablesQuery?.cells.containing(.staticText, identifier:"Last Name").children(matching: .textField).element
        textField2?.tap()
        textField2?.clearText(andReplaceWith: "Shah")
        let textField3 = tablesQuery?.cells.containing(.staticText, identifier:"Email").children(matching: .textField).element
        textField3?.tap()
        textField3?.clearText(andReplaceWith: "amit.shah@gmail.com")
        let textField4 = tablesQuery?.cells.containing(.staticText, identifier:"Phone Number").children(matching: .textField).element
        textField4?.tap()
        textField4?.clearText(andReplaceWith: "9910749550")
        contactsContactsdetailsviewNavigationBar?.buttons["Done"].tap()
        contactsContactsdetailsviewNavigationBar?.buttons["Contact"].tap()
        XCTAssert((tablesQuery?.staticTexts[fullName].exists)!)
    }

    func testEditContactInformation() {
        let updatedFirstName = "Amit"
        let updatedLastName = "Shah"
        let fullName = "\(updatedFirstName) \(updatedLastName)"
        let tablesQuery = app?.tables
        let staticText = tablesQuery?.staticTexts["Amit Shah"].firstMatch
        staticText?.tap()
        let contactsContactsdetailsviewNavigationBar = app?.navigationBars["Contacts.ContactsDetailsView"]
        contactsContactsdetailsviewNavigationBar?.buttons["Edit"].tap()
        let textField = tablesQuery?.cells.containing(.staticText, identifier:"First Name").children(matching: .textField).element
        textField?.tap()
        textField?.clearText(andReplaceWith: updatedFirstName)
        let textField2 = tablesQuery?.cells.containing(.staticText, identifier:"Last Name").children(matching: .textField).element
        textField2?.tap()
        textField2?.clearText(andReplaceWith: "Shah")
        let textField3 = tablesQuery?.cells.containing(.staticText, identifier:"Email").children(matching: .textField).element
        textField3?.tap()
        textField3?.clearText(andReplaceWith: "amit.shah@gmail.com")
        let textField4 = tablesQuery?.cells.containing(.staticText, identifier:"Phone Number").children(matching: .textField).element
        textField4?.tap()
        textField4?.clearText(andReplaceWith: "9910749550")
        contactsContactsdetailsviewNavigationBar?.buttons["Done"].tap()
        contactsContactsdetailsviewNavigationBar?.buttons["Contact"].tap()
        XCTAssert((tablesQuery?.staticTexts[fullName].exists)!)
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
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
