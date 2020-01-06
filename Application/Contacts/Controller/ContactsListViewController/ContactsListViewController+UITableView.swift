//
//  ContactsListViewController+UITableView.swift
//  Contacts
//
//  Created by Saransh Mittal on 04/01/20.
//  Copyright © 2020 Saransh Mittal. All rights reserved.
//

import UIKit

extension ContactsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contactsSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = contactsSectionTitles[section]
        if let flag = contactsDictionary[key] { return flag.count }
        return 0
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contactsSectionTitles
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contactsSectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.contactList, for: indexPath) as! ContactsTableViewCell
        let contactSection = contactsSectionTitles[indexPath.section]
        let contacts: [Contact] = contactsDictionary[contactSection]!
        tableViewCell.configure(contact: contacts[indexPath.row])
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let contactSection = contactsSectionTitles[indexPath.section]
        let contacts: [Contact] = contactsDictionary[contactSection]!
        selectedUUID = contacts[indexPath.row].uuid
        self.performSegue(withIdentifier: "ContactsDetailsSegue", sender: self)
    }
    
}
