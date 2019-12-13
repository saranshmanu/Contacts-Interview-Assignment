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
        switch mode {
            case .normal:
                    mode = .editing
                    editDetailsButton.title = "Done"
            case .editing:
                if checkFields().isEmpty {
                    updateContactInformation()
                    mode = .normal
                    editDetailsButton.title = "Edit"
                } else {
                    alertForInvalidTextFields()
                    break
                }
            case .adding:
                if checkFields().isEmpty {
                    saveContactInformation()
                    mode = .normal
                    editDetailsButton.isEnabled = false
                } else {
                    alertForInvalidTextFields()
                    break
                }
        }
        tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .fade)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Back", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func alertForInvalidTextFields() {
        let codes = checkFields()
        var message = ""
        for i in 0..<codes.count {
            message += "\(i+1)) \(codes[i].rawValue)\n"
        }
        showAlert(title: "Error", message: message)
    }
    
    enum InvalidTextFieldCode: String {
        case firstNameEmpty = "First name cannot be left blank"
        case lastNameEmpty = "Last name cannot be left blank"
        case firstNameShort = "First name is too short (minimum is 2 characters)"
        case lastNameShort = "Last name is too short (minimum is 2 characters)"
        case emailFormatInvalid = "Invalid email address"
        case phoneNumberFormatInvalid = "Invalid phone number"
    }
    
    func checkFields() -> [InvalidTextFieldCode] {
        var codes = [InvalidTextFieldCode]()
        (newContactInformation?.lastName.isEmpty)! ? codes.append(.firstNameEmpty) : (newContactInformation?.firstName.count)! < 2 ? codes.append(.firstNameShort) : ()
        (newContactInformation?.firstName.isEmpty)! ? codes.append(.lastNameEmpty) : (newContactInformation?.lastName.count)! < 2 ? codes.append(.lastNameShort) : ()
        !(newContactInformation?.email.isEmpty)! && !(newContactInformation?.email.isValidEmail)! ? codes.append(.emailFormatInvalid) : ()
        !(newContactInformation?.phoneNumber.isEmpty)! && !(newContactInformation?.phoneNumber.isValidContact)! ? codes.append(.phoneNumberFormatInvalid) : ()
        return codes
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
                self.view.frame.origin.y -= keyboardSize.height
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
            case .adding   : return 1 + editingFields.count
            default         : return 1 + dataFields.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let headerCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.contactsDetailsHeaderTableViewCellIdentifier, for: indexPath) as! ContactsDetailsHeaderTableViewCell
            headerCell.configure(name: contact!.firstName + " " + contact!.lastName, mode: mode, isFavourite: contact!.isFavourite)
            headerCell.selectionStyle = .none
            headerCell.delegate = self
            return headerCell
        default:
            let fieldCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.contactsDetailsFieldTableViewCellIdentifier, for: indexPath) as! ContactsDetailsFieldTableViewCell
            fieldCell.delegate = self
            var textField = NSDictionary()
            (mode == .normal) ?
                (textField = dataFields[indexPath.row - 1] as NSDictionary) :
                (textField = editingFields[indexPath.row - 1] as NSDictionary)
            fieldCell.configure(type: textField["type"] as! String, data: textField["data"] as! String, mode: mode, placeholder: textField["placeholder"] as! String)
            fieldCell.selectionStyle = .none
            return fieldCell
        }
    }
}

extension ContactsDetailsViewController: ContactsDetailsHeaderTableViewCellDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    func performActivity(activity: Activity) {
        switch activity {
        case .call:
            if (contact?.phoneNumber.isEmpty)! {
                self.showAlert(title: "Alert", message: "No phone number found. Cannot place a call to the number.")
            }
            guard let number = URL(string: "tel://" + contact!.phoneNumber) else { return }
            UIApplication.shared.open(number)
        case .email:
            // checking if we can send the email throught the application
            if (contact?.email.isEmpty)! {
                self.showAlert(title: "Alert", message: "No email address found. Cannot send the message.")
            }
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([contact!.email])
                mail.setMessageBody("Sent from iPhone<BR>\(contact?.firstName ?? "")", isHTML: true)
                present(mail, animated: true)
            } else {
                // cannot send the email
                print("Cannot send email")
            }
        case .message:
            // checking if we can send the message throught the application
            if (contact?.phoneNumber.isEmpty)! {
                self.showAlert(title: "Alert", message: "No phone number found. Cannot send the message.")
            }
            if MFMessageComposeViewController.canSendText() {
                let message = MFMessageComposeViewController()
                message.messageComposeDelegate = self
                message.recipients = ["\(contact?.phoneNumber ?? "")"]
                message.body = ""
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
        default:
            let status: Bool?
            contact!.isFavourite ? (status = false) : (status = true)
            ContactAPINetworkService().addContactFavoriteStatus(to: status!, uuid: contact!.uuid)
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
        ContactAPINetworkService().createContactDetails(data: newContactInformation!)
        contact = newContactInformation!
        initDataFields()
    }
    
    func updateContactInformation() {
        ContactAPINetworkService().updateContactDetails(with: newContactInformation!.uuid, data: newContactInformation!)
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
