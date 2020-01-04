//
//  ContactsDetailsViewController+Delegate.swift
//  Contacts
//
//  Created by Saransh Mittal on 04/01/20.
//  Copyright © 2020 Saransh Mittal. All rights reserved.
//

import Foundation


extension ContactsDetailsViewController: ContactsDetailsFieldTableViewCellDelegate {
    func saveContactInformation() {
        ContactAPINetworkService().createContactDetails(data: newContactInformation!, completion: { (response) in })
        self.contact = newContactInformation!
        initDataFields()
    }
    func updateContactInformation() {
        ContactAPINetworkService().updateContactDetails(with: newContactInformation!.uuid, data: newContactInformation!, completion: { (response) in })
        contact = ContactAPINetworkService().getData(with: contact!.uuid)
        initDataFields()
    }
    func updateChangedValue(data: String, type: String) {
        switch type {
            case "First Name": newContactInformation?.firstName = data
            case "Last Name": newContactInformation?.lastName = data
            case "Email": newContactInformation?.email = data
            case "Phone Number": newContactInformation?.phoneNumber = data
            default: break
        }
    }
}
