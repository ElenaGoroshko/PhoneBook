//
//  PersonTableViewCell.swift
//  PhoneBook
//
//  Created by Elena Goroshko on 11/17/17.
//  Copyright © 2017 Elena Goroshko. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

    @IBOutlet private weak var firstName: UILabel!
    @IBOutlet private weak var lastName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: private methods

     func update(firstName: String, lastName: String) {
        self.firstName.text = firstName
        self.lastName.text = lastName
    }

}
