//
//  ContactsListViewController.swift
//  Contacts
//
//  Created by Saransh Mittal on 11/12/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import UIKit

class ContactsListViewController: UIViewController {
    
    @IBAction func addContactsAction(_ sender: Any) {
        self.performSegue(withIdentifier: "AddContactSegue", sender: self)
    }

    @IBOutlet weak var tableView: UITableView!
    var selectedUUID: Int = 0
    var contacts = [Contact]()
    var contactsSectionTitles = [String]()
    var contactsDictionary = [String: [Contact]]()
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
        contactsResultService?.getContactsList(completion: { response in
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
        tableView.refreshControl = refreshControl
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
