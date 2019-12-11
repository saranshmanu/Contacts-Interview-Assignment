//
//  ContactsViewController.swift
//  Contacts
//
//  Created by Saransh Mittal on 11/12/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var contacts = [Contact]()
    var contactsDictionary = [String: [Contact]]()
    var contactsSectionTitles = [String]()
    
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
        let contactCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.contactList, for: indexPath) as! ContactTableViewCell
        let flag = contactsSectionTitles[indexPath.section]
        let contacts: [Contact] = contactsDictionary[flag]!
        contactCell.initData(contact: contacts[indexPath.row])
        return contactCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contactsSectionTitles[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contactsSectionTitles
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func addModelData() {
        contacts.append(Contact(uuid: "a2sj471", firstName: "Saransh", lastName: "Mittal", phoneNumber: 9910749550, isFavourite: true, email: "saranshmanu@yahoo.co.in", profileImage: UIImageView.init()))
        contacts.append(Contact(uuid: "a2sj471", firstName: "Arvind", lastName: "Mittal", phoneNumber: 9910749550, isFavourite: true, email: "saranshmanu@yahoo.co.in", profileImage: UIImageView.init()))
        contacts.append(Contact(uuid: "a2sj471", firstName: "Arti", lastName: "Mittal", phoneNumber: 9910749550, isFavourite: true, email: "saranshmanu@yahoo.co.in", profileImage: UIImageView.init()))
        contacts.append(Contact(uuid: "a2sj471", firstName: "Ananya", lastName: "Mittal", phoneNumber: 9910749550, isFavourite: true, email: "saranshmanu@yahoo.co.in", profileImage: UIImageView.init()))
        contacts.append(Contact(uuid: "a2sj471", firstName: "Raghav", lastName: "Gupta", phoneNumber: 9910749550, isFavourite: true, email: "saranshmanu@yahoo.co.in", profileImage: UIImageView.init()))
        contacts.append(Contact(uuid: "a2sj471", firstName: "Saransh", lastName: "Mittal", phoneNumber: 9910749550, isFavourite: true, email: "saranshmanu@yahoo.co.in", profileImage: UIImageView.init()))
        contacts.append(Contact(uuid: "a2sj471", firstName: "Arvind", lastName: "Mittal", phoneNumber: 9910749550, isFavourite: true, email: "saranshmanu@yahoo.co.in", profileImage: UIImageView.init()))
        contacts.append(Contact(uuid: "a2sj471", firstName: "Arti", lastName: "Mittal", phoneNumber: 9910749550, isFavourite: true, email: "saranshmanu@yahoo.co.in", profileImage: UIImageView.init()))
        contacts.append(Contact(uuid: "a2sj471", firstName: "Ananya", lastName: "Mittal", phoneNumber: 9910749550, isFavourite: true, email: "saranshmanu@yahoo.co.in", profileImage: UIImageView.init()))
        contacts.append(Contact(uuid: "a2sj471", firstName: "Raghav", lastName: "Gupta", phoneNumber: 9910749550, isFavourite: true, email: "saranshmanu@yahoo.co.in", profileImage: UIImageView.init()))
        contacts.append(Contact(uuid: "a2sj471", firstName: "Saransh", lastName: "Mittal", phoneNumber: 9910749550, isFavourite: true, email: "saranshmanu@yahoo.co.in", profileImage: UIImageView.init()))
        contacts.append(Contact(uuid: "a2sj471", firstName: "Arvind", lastName: "Mittal", phoneNumber: 9910749550, isFavourite: true, email: "saranshmanu@yahoo.co.in", profileImage: UIImageView.init()))
        contacts.append(Contact(uuid: "a2sj471", firstName: "Arti", lastName: "Mittal", phoneNumber: 9910749550, isFavourite: true, email: "saranshmanu@yahoo.co.in", profileImage: UIImageView.init()))
        contacts.append(Contact(uuid: "a2sj471", firstName: "Ananya", lastName: "Mittal", phoneNumber: 9910749550, isFavourite: true, email: "saranshmanu@yahoo.co.in", profileImage: UIImageView.init()))
        contacts.append(Contact(uuid: "a2sj471", firstName: "Raghav", lastName: "Gupta", phoneNumber: 9910749550, isFavourite: true, email: "saranshmanu@yahoo.co.in", profileImage: UIImageView.init()))
        contacts.append(Contact(uuid: "a2sj471", firstName: "Saransh", lastName: "Mittal", phoneNumber: 9910749550, isFavourite: true, email: "saranshmanu@yahoo.co.in", profileImage: UIImageView.init()))
        contacts.append(Contact(uuid: "a2sj471", firstName: "Arvind", lastName: "Mittal", phoneNumber: 9910749550, isFavourite: true, email: "saranshmanu@yahoo.co.in", profileImage: UIImageView.init()))
        contacts.append(Contact(uuid: "a2sj471", firstName: "Arti", lastName: "Mittal", phoneNumber: 9910749550, isFavourite: true, email: "saranshmanu@yahoo.co.in", profileImage: UIImageView.init()))
        contacts.append(Contact(uuid: "a2sj471", firstName: "Ananya", lastName: "Mittal", phoneNumber: 9910749550, isFavourite: true, email: "saranshmanu@yahoo.co.in", profileImage: UIImageView.init()))
        contacts.append(Contact(uuid: "a2sj471", firstName: "Raghav", lastName: "Gupta", phoneNumber: 9910749550, isFavourite: true, email: "saranshmanu@yahoo.co.in", profileImage: UIImageView.init()))
        contacts.append(Contact(uuid: "a2sj471", firstName: "Sarthak", lastName: "Mittal", phoneNumber: 9910749550, isFavourite: true, email: "saranshmanu@yahoo.co.in", profileImage: UIImageView.init()))
        contacts.append(Contact(uuid: "a2sj471", firstName: "Arvind", lastName: "Mittal", phoneNumber: 9910749550, isFavourite: true, email: "saranshmanu@yahoo.co.in", profileImage: UIImageView.init()))
        contacts.append(Contact(uuid: "a2sj471", firstName: "Arti", lastName: "Mittal", phoneNumber: 9910749550, isFavourite: true, email: "saranshmanu@yahoo.co.in", profileImage: UIImageView.init()))
        contacts.append(Contact(uuid: "a2sj471", firstName: "Ananya", lastName: "Mittal", phoneNumber: 9910749550, isFavourite: true, email: "saranshmanu@yahoo.co.in", profileImage: UIImageView.init()))
        contacts.append(Contact(uuid: "a2sj471", firstName: "Keshav", lastName: "Gupta", phoneNumber: 9910749550, isFavourite: true, email: "saranshmanu@yahoo.co.in", profileImage: UIImageView.init()))
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

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        addModelData()
        createTableSectionIndex()
    }

}

