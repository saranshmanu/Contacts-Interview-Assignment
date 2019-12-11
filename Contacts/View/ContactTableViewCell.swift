//
//  ContactTableViewCell.swift
//  Contacts
//
//  Created by Saransh Mittal on 11/12/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var favouritesImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    func initData() {
        
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
