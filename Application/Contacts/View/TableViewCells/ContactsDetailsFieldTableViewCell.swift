//
//  ContactsDetailsFieldTableViewCell.swift
//  Contacts
//
//  Created by Saransh Mittal on 12/12/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import UIKit

protocol ContactsDetailsFieldTableViewCellDelegate {
    func updateChangedValue(data: String, type: String)
}

class ContactsDetailsFieldTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var detailTypeLabel: UILabel!
    @IBOutlet weak var detailTextField: UITextField!
    var delegate: ContactsDetailsFieldTableViewCellDelegate?
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let type: String = detailTypeLabel.text!
        let data: String = detailTextField.text!
        delegate?.updateChangedValue(data: data, type: type)
    }
    
    func configure(mode: ContactsDetailsMode, contactField: NSDictionary) {
        detailTextField.text = contactField["data"] as? String
        detailTypeLabel.text = contactField["type"] as? String
        detailTextField.placeholder = contactField["placeholder"] as? String
        if mode == .normal {
            detailTextField.isUserInteractionEnabled = false
            detailTypeLabel.isUserInteractionEnabled = false
        } else {
            detailTextField.isUserInteractionEnabled = true
            detailTypeLabel.isUserInteractionEnabled = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        detailTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
