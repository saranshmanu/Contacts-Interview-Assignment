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
    case viewing = "viewing"
    case editing = "editing"
}

class ContactsDetailsViewController: UIViewController {

    @IBOutlet weak var editDetailsButton: UIBarButtonItem!
    @IBAction func editDetailsAction(_ sender: Any) {
        switch mode {
            case .viewing:
                mode = .editing
                editDetailsButton.title = "Done"
            case .editing:
                mode = .viewing
                editDetailsButton.title = "Edit"
        }
        tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .fade)
//        tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .fade)
    }
    @IBOutlet weak var tableView: UITableView!
    var contact: Contact?
    var uuid: Int = 0
    var mode: ContactsDetailsMode = .viewing
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        contact = ContactsResultService().getData(with: uuid)
    }
}

extension ContactsDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
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
            fieldCell.configure(type: "First Name", data: "Saransh", mode: mode)
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
