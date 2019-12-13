//
//  ContactsDetailsHeaderTableViewCell.swift
//  Contacts
//
//  Created by Saransh Mittal on 12/12/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import UIKit

enum Activity: String {
    case call = "call"
    case email = "email"
    case message = "message"
    case favourite = "favourite"
    case refresh = "refresh"
}

protocol ContactsDetailsHeaderTableViewCellDelegate {
    func performActivity(activity: Activity)
}

class ContactsDetailsHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var moreContactInformationHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var moreContactInformationView: UIStackView!
    @IBOutlet weak var profileUserNameLabel: UILabel!
    @IBOutlet weak var profileImageBackgroundView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    var delegate: ContactsDetailsHeaderTableViewCellDelegate?
    
    @IBAction func favourite(_ sender: Any) {
        delegate?.performActivity(activity: .favourite)
    }
    @IBAction func email(_ sender: Any) {
        delegate?.performActivity(activity: .email)
    }
    @IBAction func call(_ sender: Any) {
        delegate?.performActivity(activity: .call)
    }
    @IBAction func message(_ sender: Any) {
        delegate?.performActivity(activity: .message)
    }
    
    func configure(name: String, mode: ContactsDetailsMode) {
        profileUserNameLabel.text = name
        switch mode {
        case .normal:
            moreContactInformationView.isHidden = false
            moreContactInformationHeightConstraint.constant = 69
        case .editing:
            moreContactInformationView.isHidden = true
            moreContactInformationHeightConstraint.constant = 0
        }
        delegate?.performActivity(activity: .refresh)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageBackgroundView.layer.cornerRadius = profileImageBackgroundView.frame.size.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
