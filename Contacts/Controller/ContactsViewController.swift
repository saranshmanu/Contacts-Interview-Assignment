//
//  ContactsViewController.swift
//  Contacts
//
//  Created by Saransh Mittal on 11/12/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contactCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.contactList, for: indexPath) as! ContactTableViewCell
        return contactCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initTableView()
    }

}

