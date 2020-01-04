//
//  ContactsDetailsViewController.swift
//  Contacts
//
//  Created by Saransh Mittal on 12/12/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import UIKit
import MessageUI

enum ContactsDetailsMode: String {
    case normal = "normal"
    case editing = "editing"
    case adding = "adding"
}

class ContactsDetailsViewController: UIViewController {

    @IBOutlet weak var editDetailsButton: UIBarButtonItem!
    @IBAction func editDetailsAction(_ sender: Any) {
        if mode == .normal {
            editDetailsButton.title = "Done"
            mode = .editing
            tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .fade)
        } else if mode == .editing && newContactInformation!.checkInvalidTextFields().isEmpty {
            editDetailsButton.title = "Edit"
            updateContactInformation()
            mode = .normal
            tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .fade)
        } else if mode == .adding && newContactInformation!.checkInvalidTextFields().isEmpty {
            editDetailsButton.isEnabled = false
            saveContactInformation()
            mode = .normal
            tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .fade)
        } else {
            alertForInvalidTextFields()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    var newContactInformation: Contact?
    var contact: Contact?
    var mode: ContactsDetailsMode = .normal
    var editingFields = [NSDictionary]()
    var dataFields = [NSDictionary]()
    
    func alertForInvalidTextFields() {
        let codes: [Contact.InvalidTextFieldCode] = newContactInformation!.checkInvalidTextFields()
        var message = ""
        for i in 0..<codes.count {
            message += "\(i+1)) \(codes[i].rawValue)\n"
        }
        self.showAlert(title: "Error", message: message)
    }
    
    func getContactFields(contact: Contact) -> [NSDictionary] {
        return [
            [
                "type": "First Name",
                "data": contact.firstName as Any,
                "placeholder": "Raghav"
            ],[
                "type": "Last Name",
                "data": contact.lastName as Any,
                "placeholder": "Gupta"
            ],[
                "type": "Email",
                "data": contact.email as Any,
                "placeholder": "raghav.gupta@gmail.com"
            ],[
                "type": "Phone Number",
                "data": contact.phoneNumber as Any,
                "placeholder": "99998888XX"
            ]
        ]
    }
    
    func initDataFields() {
        let contactFields = getContactFields(contact: contact!) as [NSDictionary]
        dataFields.removeAll()
        if (contact?.firstName != "") {
            dataFields.append(contactFields[0])
        }
        if contact?.lastName != "" {
            dataFields.append(contactFields[1])
        }
        if contact?.email != "" {
            dataFields.append(contactFields[2])
        }
        if contact?.phoneNumber != "" {
            dataFields.append(contactFields[3])
        }
        editingFields = contactFields
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        newContactInformation = Contact()
        newContactInformation?.uuid = contact!.uuid
        newContactInformation?.firstName = contact!.firstName
        newContactInformation?.lastName = contact!.lastName
        newContactInformation?.email = contact!.email
        newContactInformation?.phoneNumber = contact!.phoneNumber
        initTableView()
        initDataFields()
        if mode == .adding {
            editDetailsButton.title = "Done"
        }
    }
}
