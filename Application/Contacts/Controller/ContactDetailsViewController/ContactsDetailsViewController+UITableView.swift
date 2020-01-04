//
//  ContactsDetailsViewControllerExtension.swift
//  Contacts
//
//  Created by Saransh Mittal on 04/01/20.
//  Copyright © 2020 Saransh Mittal. All rights reserved.
//

import UIKit

extension ContactsDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func configureContactsHeaderCell(indexPath: IndexPath) -> ContactsDetailsHeaderTableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.contactsDetailsHeaderTableViewCellIdentifier, for: indexPath) as! ContactsDetailsHeaderTableViewCell
        tableViewCell.configure(contact: contact!, mode: mode)
        tableViewCell.delegate = self
        return tableViewCell
    }
    
    func configureContactFieldBodyCell(indexPath: IndexPath) -> ContactsDetailsFieldTableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.contactsDetailsFieldTableViewCellIdentifier, for: indexPath) as! ContactsDetailsFieldTableViewCell
        var contactField = NSDictionary()
        (mode == .normal) ?
            (contactField = dataFields[indexPath.row - 1] as NSDictionary) :
            (contactField = editingFields[indexPath.row - 1] as NSDictionary)
        tableViewCell.configure(mode: mode, contactField: contactField)
        tableViewCell.delegate = self
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch mode {
            case .editing   : return 1 + editingFields.count
            case .adding    : return 1 + editingFields.count
            default         : return 1 + dataFields.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: return configureContactsHeaderCell(indexPath: indexPath)
        default: return configureContactFieldBodyCell(indexPath: indexPath)
        }
    }
}
