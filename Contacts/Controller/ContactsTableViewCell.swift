//
//  ContactsTableViewCell.swift
//  Contacts
//
//  Created by Saransh Mittal on 11/12/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    @IBOutlet weak var favouritesImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    func configure(contact: Contact) {
        profileNameLabel.text = contact.firstName + " " + contact.lastName
//        profileImageView.image = contact.profileImage?.image
        favouritesImageView.isHidden = !contact.isFavourite
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
