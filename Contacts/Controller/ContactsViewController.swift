//
//  ContactsViewController.swift
//  Contacts
//
//  Created by Saransh Mittal on 11/12/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {
    
    @IBAction func addContactsAction(_ sender: Any) {
        self.performSegue(withIdentifier: "AddContactSegue", sender: self)
    }

    @IBOutlet weak var tableView: UITableView!
    var contacts = [Contact]()
    var contactsDictionary = [String: [Contact]]()
    var contactsSectionTitles = [String]()
    var selectedUUID: Int = 0
    var contactsResultService: ContactAPINetworkService?
    var refreshControl: UIRefreshControl!
    
    func refresh(status: Bool) {
        if status == true {
            createTableSectionIndex()
            tableView.reloadData()
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        refreshControl.endRefreshing()
    }
    
    @objc func fetchData() {
        contactsResultService?.refreshContactDetails(completion: { response in
            if let _: [Contact] = response as? [Contact] {
                self.refresh(status: true)
            } else {
                self.refresh(status: false)
            }
        })
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    func createTableSectionIndex() {
        contacts = contactsResultService?.getData() ?? [Contact]()
        contactsDictionary.removeAll()
        contactsSectionTitles.removeAll()
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
    
    override func viewWillAppear(_ animated: Bool) {
        refresh(status: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsResultService = ContactAPINetworkService()
        initTableView()
        refresh(status: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ContactsDetailsSegue") {
                let contactsDetailsViewController = segue.destination as! ContactsDetailsViewController
            contactsDetailsViewController.contact = ContactAPINetworkService().getData(with: selectedUUID)
        } else if(segue.identifier == "AddContactSegue") {
            let contactsDetailsViewController = segue.destination as! ContactsDetailsViewController
            contactsDetailsViewController.contact = Contact()
            contactsDetailsViewController.mode = .adding
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
        tableView.deselectRow(at: indexPath, animated: true)
        let flag = contactsSectionTitles[indexPath.section]
        let contacts: [Contact] = contactsDictionary[flag]!
        selectedUUID = contacts[indexPath.row].uuid
        self.performSegue(withIdentifier: "ContactsDetailsSegue", sender: self)
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contactsSectionTitles
    }
}
