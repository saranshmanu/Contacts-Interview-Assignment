//
//  ContactsDetailsFieldTableViewCell.swift
//  Contacts
//
//  Created by Saransh Mittal on 12/12/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import UIKit

class ContactsDetailsFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var detailTypeLabel: UILabel!
    @IBOutlet weak var detailTextField: UITextField!
    
    func configure(type: String, data: String, mode: ContactsDetailsMode) {
        detailTextField.text = data
        detailTypeLabel.text = type
        if mode == .viewing {
            detailTextField.isUserInteractionEnabled = false
            detailTypeLabel.isUserInteractionEnabled = false
        } else {
            detailTextField.isUserInteractionEnabled = true
            detailTypeLabel.isUserInteractionEnabled = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
