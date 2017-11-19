//
//  ContactOfPersonViewController.swift
//  PhoneBook
//
//  Created by Elena Goroshko on 11/18/17.
//  Copyright © 2017 Elena Goroshko. All rights reserved.
//

import UIKit

class ContactOfPersonViewController: UIViewController {

    var person: Person?

    @IBOutlet private weak var ibLastName: UITextField!
    @IBOutlet private weak var ibFirstName: UITextField!
    @IBOutlet private weak var ibPfone: UITextField!
    @IBOutlet private weak var ibEmail: UITextField!
    @IBOutlet private weak var ibImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if person != nil {
            ibFirstName.text = person?.firstName
            ibLastName.text = person?.lastName
            ibPfone.text = String(person?.pfoneNumber ?? 0)
            ibEmail.text = person?.emai ?? ""
            ibImage.image = person?.pfoto ?? #imageLiteral(resourceName: "user-5")

        }
    }

}
