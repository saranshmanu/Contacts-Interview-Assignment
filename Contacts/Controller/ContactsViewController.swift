//
//  ContactsViewController.swift
//  Contacts
//
//  Created by Saransh Mittal on 11/12/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, ContactsResultServiceDelegate {
    
    func refresh() {
        reloadTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refresh()
    }
    
    var contacts = [Contact]()
    var contactsDictionary = [String: [Contact]]()
    var contactsSectionTitles = [String]()
    var selectedUUID: Int = 0
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func reloadTableView() {
        contacts = (contactsResultService?.getData() ?? nil)!
        createTableSectionIndex()
        tableView.reloadData()
    }
    
    func createTableSectionIndex() {
        for contact in contacts {
            let flag = String(contact.firstName.prefix(1))
            if var carValues = contactsDictionary[flag] {
                carValues.append(contact)
                contactsDictionary[flag] = carValues
            } else {
                contactsDictionary[flag] = [contact]
            }
        }
        contactsSectionTitles = [String](contactsDictionary.keys)
        contactsSectionTitles = contactsSectionTitles.sorted(by: { $0 < $1 })
    }
    
    func initContactsResultService() {
        contactsResultService = ContactsResultService()
        contactsResultService?.delegate = self
    }

    var contactsResultService: ContactsResultService?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initContactsResultService()
        initTableView()
        reloadTableView()
//        contactsResultService?.refreshData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ContactsDetailsSegue") {
                let contactsDetailsViewController = segue.destination as! ContactsDetailsViewController
            contactsDetailsViewController.uuid = selectedUUID
        }
    }
}

extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = contactsSectionTitles[section]
        if let flag = contactsDictionary[key] {
            return flag.count
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contactsSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contactCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.contactList, for: indexPath) as! ContactsTableViewCell
        let flag = contactsSectionTitles[indexPath.section]
        let contacts: [Contact] = contactsDictionary[flag]!
        contactCell.configure(contact: contacts[indexPath.row])
        return contactCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contactsSectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let flag = contactsSectionTitles[indexPath.section]
        let contacts: [Contact] = contactsDictionary[flag]!
        selectedUUID = contacts[indexPath.row].uuid
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "ContactsDetailsSegue", sender: self)
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contactsSectionTitles
    }
}
