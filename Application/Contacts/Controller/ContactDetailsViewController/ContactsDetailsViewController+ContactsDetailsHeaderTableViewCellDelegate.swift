//
//  ContactsDetailsViewController+ContactActions.swift
//  Contacts
//
//  Created by Saransh Mittal on 04/01/20.
//  Copyright © 2020 Saransh Mittal. All rights reserved.
//

import UIKit
import MessageUI

extension ContactsDetailsViewController: ContactsDetailsHeaderTableViewCellDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    func performCall(contact: Contact) {
        if (contact.phoneNumber.isEmpty) {
            self.showAlert(title: "Alert", message: "No phone number found. Cannot place a call to the number.")
            return
        }
        guard let number = URL(string: "tel://" + contact.phoneNumber) else { return }
        UIApplication.shared.open(number)
    }
    func performEmail(contact: Contact) {
        if (contact.email.isEmpty) {
            self.showAlert(title: "Alert", message: "No email address found. Cannot send the message.")
            return
        }
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([contact.email])
            mail.setMessageBody("Sent from iPhone<BR>\(contact.firstName)", isHTML: true)
            present(mail, animated: true)
        }
    }
    func performMessage(contact: Contact) {
        if (contact.phoneNumber.isEmpty) {
            self.showAlert(title: "Alert", message: "No message address found. Cannot send the message.")
            return
        }
        if MFMessageComposeViewController.canSendText() {
            let message = MFMessageComposeViewController()
            message.messageComposeDelegate = self
            message.recipients = ["\(contact.phoneNumber)"]
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
