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
    
    func initDataFields() {
        dataFields.removeAll()
        if contact?.firstName != "" {
            dataFields.append([
                "type": "First Name",
                "data": contact?.firstName as Any,
                "placeholder": "Raghav"
            ])
        }
        if contact?.lastName != "" {
            dataFields.append([
                "type": "Last Name",
                "data": contact?.lastName as Any,
                "placeholder": "Gupta"
            ])
        }
        if contact?.email != "" {
            dataFields.append([
                "type": "Email",
                "data": contact?.email as Any,
                "placeholder": "raghav.gupta@gmail.com"
            ])
        }
        if contact?.phoneNumber != "" {
            dataFields.append([
                "type": "Phone Number",
                "data": contact?.phoneNumber as Any,
                "placeholder": "99998888XX"
            ])
        }
        editingFields = [
            [
                "type": "First Name",
                "data": contact?.firstName as Any,
                "placeholder": "Raghav"
            ],[
                "type": "Last Name",
                "data": contact?.lastName as Any,
                "placeholder": "Gupta"
            ],[
                "type": "Email",
                "data": contact?.email as Any,
                "placeholder": "raghav.gupta@gmail.com"
            ],[
                "type": "Phone Number",
                "data": contact?.phoneNumber as Any,
                "placeholder": "99998888XX"
            ]
        ]
    }
    
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Back", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func alertForInvalidTextFields() {
        let codes: [Contact.InvalidTextFieldCode] = newContactInformation!.checkInvalidTextFields()
        var message = ""
        for i in 0..<codes.count {
            message += "\(i+1)) \(codes[i].rawValue)\n"
        }
        showAlert(title: "Error", message: message)
    }
    
    @IBOutlet weak var tableView: UITableView!
    var newContactInformation: Contact?
    var contact: Contact?
    var mode: ContactsDetailsMode = .normal
    var editingFields = [NSDictionary]()
    var dataFields = [NSDictionary]()
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (keyboardSize.height - 50)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(ContactsDetailsViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ContactsDetailsViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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

extension ContactsDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch mode {
            case .editing   : return 1 + editingFields.count
            case .adding    : return 1 + editingFields.count
            default         : return 1 + dataFields.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let headerCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.contactsDetailsHeaderTableViewCellIdentifier, for: indexPath) as! ContactsDetailsHeaderTableViewCell
            headerCell.configure(
                name: (contact!.firstName + " " + contact!.lastName),
                isFavourite: contact!.isFavourite,
                mode: mode
            )
            headerCell.selectionStyle = .none
            headerCell.delegate = self
            return headerCell
        default:
            let fieldCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.contactsDetailsFieldTableViewCellIdentifier, for: indexPath) as! ContactsDetailsFieldTableViewCell
            var textField = NSDictionary()
            (mode == .normal) ?
                (textField = dataFields[indexPath.row - 1] as NSDictionary) :
                (textField = editingFields[indexPath.row - 1] as NSDictionary)
            fieldCell.configure(
                type: textField["type"] as! String,
                data: textField["data"] as! String, mode: mode,
                placeholder: textField["placeholder"] as! String
            )
            fieldCell.selectionStyle = .none
            fieldCell.delegate = self
            return fieldCell
        }
    }
}

extension ContactsDetailsViewController: ContactsDetailsHeaderTableViewCellDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    func performCall(contact: Contact) {
        if (contact.phoneNumber.isEmpty) {
            self.showAlert(title: "Alert", message: "No phone number found. Cannot place a call to the number.")
        }
        guard let number = URL(string: "tel://" + contact.phoneNumber) else { return }
        UIApplication.shared.open(number)
    }
    func performMessage(contact: Contact) {
        if (contact.email.isEmpty) {
            self.showAlert(title: "Alert", message: "No email address found. Cannot send the message.")
        }
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([contact.email])
            mail.setMessageBody("Sent from iPhone<BR>\(contact.firstName)", isHTML: true)
            present(mail, animated: true)
        }
    }
    func performEmail(contact: Contact) {
        if (contact.phoneNumber.isEmpty) {
            self.showAlert(title: "Alert", message: "No phone number found. Cannot send the message.")
        }
        if MFMessageComposeViewController.canSendText() {
            let message = MFMessageComposeViewController()
            message.messageComposeDelegate = self
            message.recipients = ["\(contact.phoneNumber)"]
            message.body = ""
            self.present(message, animated: true, completion: nil)
        }
    }
    func performActivity(activity: Activity) {
        switch activity {
        case .call: performCall(contact: contact!)
        case .email: performEmail(contact: contact!)
        case .message: performMessage(contact: contact!)
        case .refresh:
            UIView.animate(withDuration: 1) {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        default:
            let status: Bool?
            contact!.isFavourite ? (status = false) : (status = true)
            ContactAPINetworkService().updateContactFavoriteStatus(to: status!, uuid: contact!.uuid, completion: {_ in })
            contact = ContactAPINetworkService().getData(with: contact!.uuid)
        }
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

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
