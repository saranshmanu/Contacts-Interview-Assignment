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
}

class ContactsDetailsViewController: UIViewController {

    @IBOutlet weak var editDetailsButton: UIBarButtonItem!
    @IBAction func editDetailsAction(_ sender: Any) {
        switch mode {
            case .normal:
                mode = .editing
                editDetailsButton.title = "Done"
            case .editing:
                saveInformation()
                mode = .normal
                editDetailsButton.title = "Edit"
        }
        tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .fade)
    }
    
    func initDataFields() {
        dataFields.removeAll()
        if contact?.firstName != "" {
            dataFields.append([
                "type": "First Name",
                "data": contact?.firstName as Any
            ])
        }
        if contact?.lastName != "" {
            dataFields.append([
                "type": "Last Name",
                "data": contact?.lastName as Any
            ])
        }
        if contact?.email != "" {
            dataFields.append([
                "type": "Email",
                "data": contact?.email as Any
            ])
        }
        if contact?.phoneNumber != "" {
            dataFields.append([
                "type": "Phone Number",
                "data": contact?.phoneNumber as Any
            ])
        }
        editingFields = [
            [
                "type": "First Name",
                "data": contact?.firstName as Any
            ],[
                "type": "Last Name",
                "data": contact?.lastName as Any
            ],[
                "type": "Email",
                "data": contact?.email as Any
            ],[
                "type": "Phone Number",
                "data": contact?.phoneNumber as Any
            ]
        ]
        print(dataFields)
    }
    
    @IBOutlet weak var tableView: UITableView!
    var newContactInformation: Contact?
    var contact: Contact?
    var uuid: Int = 0
    var mode: ContactsDetailsMode = .normal
    var editingFields = [NSDictionary]()
    var dataFields = [NSDictionary]()
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contact = ContactsResultService().getData(with: uuid)
        newContactInformation = Contact()
        newContactInformation?.uuid = contact!.uuid
        newContactInformation?.firstName = contact!.firstName
        newContactInformation?.lastName = contact!.lastName
        newContactInformation?.email = contact!.email
        newContactInformation?.phoneNumber = contact!.phoneNumber
        initTableView()
        initDataFields()
    }
}

extension ContactsDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch mode {
        case .editing   : return 1 + editingFields.count
        default         : return 1 + dataFields.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let headerCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.contactsDetailsHeaderTableViewCellIdentifier, for: indexPath) as! ContactsDetailsHeaderTableViewCell
            headerCell.configure(name: contact!.firstName + " " + contact!.lastName, mode: mode)
            headerCell.selectionStyle = .none
            headerCell.delegate = self
            return headerCell
        default:
            let fieldCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.contactsDetailsFieldTableViewCellIdentifier, for: indexPath) as! ContactsDetailsFieldTableViewCell
            fieldCell.delegate = self
            switch mode {
            case .editing:
                let field = editingFields[indexPath.row - 1] as NSDictionary
                fieldCell.configure(type: field["type"] as! String, data: field["data"] as! String, mode: mode)
            default:
                let field = dataFields[indexPath.row - 1] as NSDictionary
                fieldCell.configure(type: field["type"] as! String, data: field["data"] as! String, mode: mode)
            }
            fieldCell.selectionStyle = .none
            return fieldCell
        }
    }
}

extension ContactsDetailsViewController: ContactsDetailsHeaderTableViewCellDelegate {
    func performActivity(activity: Activity) {
        switch activity {
        case .call:
            guard let number = URL(string: "tel://" + contact!.phoneNumber) else { return }
            UIApplication.shared.open(number)
        case .email:
            // checking if we can send the email throught the application
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
                mail.setToRecipients([contact!.email])
                mail.setMessageBody("Sent from iPhone<BR>\(contact?.firstName ?? "")", isHTML: true)
                present(mail, animated: true)
            } else {
                // cannot send the email
                print("Cannot send email")
            }
        case .message:
            // checking if we can send the message throught the application
            if MFMessageComposeViewController.canSendText() {
                let message = MFMessageComposeViewController()
                message.body = ""
                message.recipients = ["\(contact?.phoneNumber ?? "")"]
                message.messageComposeDelegate = self as? MFMessageComposeViewControllerDelegate
                self.present(message, animated: true, completion: nil)
            }
            else{
                // cannot send the message
                print("Cannot send message")
            }
        case .refresh:
            UIView.animate(withDuration: 1) {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        default: break
            // add to favourites
        }
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        controller.dismiss(animated: true)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension ContactsDetailsViewController: ContactsDetailsFieldTableViewCellDelegate {
    
    func saveInformation() {
        ContactsResultService().updateData(with: newContactInformation!.uuid, data: newContactInformation!)
        contact = ContactsResultService().getData(with: uuid)
        initDataFields()
    }
    
    func updateChangedValue(data: String, type: String) {
        print("Updated new value")
        switch type {
            case "First Name": newContactInformation?.firstName = data
            case "Last Name": newContactInformation?.lastName = data
            case "Email": newContactInformation?.email = data
            case "Phone Number": newContactInformation?.phoneNumber = data
            default: break
        }
    }
}
