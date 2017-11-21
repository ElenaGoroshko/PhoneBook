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
    @IBOutlet private weak var ibAddOrChangeButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ibFirstName.delegate = self
        self.ibLastName.delegate = self
        self.ibPfone.delegate = self
        self.ibEmail.delegate = self
        
        if person != nil {
            ibAddOrChangeButton.title = "Изменить"
            ibFirstName.text = person?.firstName
            ibLastName.text = person?.lastName
            let num = person?.pfoneNumber ?? 0
            if num != 0 {
                ibPfone.text = String(num)
            } else {
                ibPfone.text = ""
            }
            ibEmail.text = person?.email ?? ""
            ibImage.image = person?.pfoto ?? #imageLiteral(resourceName: "user-5")
        } else {
           ibAddOrChangeButton.title = "Добавить"
            ibImage.image = #imageLiteral(resourceName: "user-5")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addNotification()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func buttonAddOrChangePressed(_ sender: UIBarButtonItem) {
        guard ibFirstName.text != nil, ibLastName.text != nil else { fatalError("Error: No name or lastname")}
        if person != nil {
            setPerson()
            DataManager.instance.changePerson(person: person!)
        } else {
            person = Person(firstName: ibFirstName.text!, lastName: ibFirstName.text!)
            setPerson()
            DataManager.instance.addPerson(person: person!)
        }
         navigationController?.popViewController(animated: true)
    }
    private func setPerson() {
        person?.setFirstName(name: ibFirstName.text!)
        person?.setLastNAme(name: ibLastName.text!)
        let numStr = Int(ibPfone.text ?? "0") ?? 0
        if numStr != 0 {
            person?.setPfoneNumber(pfoneNumber: numStr)
        }
        if ibEmail.text != nil { person?.setEmail(email: ibEmail.text!) }
        if ibImage.image != nil { person?.setPfoto(pfoto: ibImage.image!) }
    }

    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: .UIKeyboardWillHide, object: nil)
    }
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

}
// MARK: extention UITextFieldDelegate
extension ContactOfPersonViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideKeyboard()
    }
}

// MARK: extention notification
extension ContactOfPersonViewController {
    @objc private func keyboardWillShow(_ notification:Notification) {
    }

    @objc private func keyboardWillHide(_ notification:Notification) {
        hideKeyboard()
    }
}
    /*
     @objc private func keyboardWillShow(_ notification: Notification) {
     guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
     return
     }
     lcActionsBottomMargin.constant = keyboardFrame.size.height
     UIView.animate(withDuration: 0.3) {
     self.view.layoutIfNeeded()
     }
     }
     
     @objc private func keyboardWillHide(_ notification: Notification) {
     lcActionsBottomMargin.constant = 0
     UIView.animate(withDuration: 0.3) {
     self.view.layoutIfNeeded()
     }
     }
     @objc private func hideKeyboard() {
     view.endEditing(true)
     }
     }

     // MARK: - UITextFieldDelegate
extension ContactOfPersonViewController: UITextFieldDelegate {
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
     return true
     }

}*/
