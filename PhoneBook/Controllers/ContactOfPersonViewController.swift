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
    var imagePicker: UIImagePickerController!

    @IBOutlet private weak var ibLastName: UITextField!
    @IBOutlet private weak var ibFirstName: UITextField!
    @IBOutlet private weak var ibPfone: UITextField!
    @IBOutlet private weak var ibEmail: UITextField!
    @IBOutlet private weak var ibImage: UIImageView!
    @IBOutlet private weak var ibAddOrChangeButton: UIBarButtonItem!
    @IBOutlet private var parentView: UIView!
    @IBOutlet private weak var imageView: UIView!

    @IBOutlet private weak var lcImageTop: NSLayoutConstraint!
    @IBOutlet private weak var lcStackViewToImage: NSLayoutConstraint!
    @IBOutlet private weak var lcImageHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var lcStackViewHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var lcStackViewMargin: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPfoto()
        self.ibFirstName.delegate = self
        self.ibLastName.delegate = self
        self.ibPfone.delegate = self
        self.ibEmail.delegate = self

        let tapGestureImage = UITapGestureRecognizer(target: self, action: #selector(tapRecognizerViewAndImage(_:)))
        imageView.addGestureRecognizer(tapGestureImage)
        let tapGestureViev = UITapGestureRecognizer(target: self, action: #selector(tapRecognizerViewAndImage(_:)))
        parentView.addGestureRecognizer(tapGestureViev)

        ibImage.layer.cornerRadius = ibImage.frame.size.height / 2
        ibImage.contentMode = .scaleAspectFill
        ibImage.layer.masksToBounds = true
        reloadConstraints(top: 60, margin: 60)

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
        addNotificationKeyboard()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func buttonAddOrChangePressed(_ sender: UIBarButtonItem) {
        guard let firstname = ibFirstName.text,
                let lastname = ibLastName.text else { fatalError("Error: No name or lastname")}
        if person != nil {
            setPerson()
            DataManager.instance.changePerson(person!)
        } else {
            person = Person(firstName: firstname, lastName: lastname)
            setPerson()
            DataManager.instance.addPerson(person!)
        }
         navigationController?.popViewController(animated: true)
    }
    private func setPerson() {
        guard let firstName: String = ibFirstName.text, firstName.count > 1 else {
            let alert = UIAlertController(title: "Ошибка", message: "Имя должно содержать больше 1 символа", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        person?.setFirstName(name: firstName )
        guard let lastName = ibLastName.text, lastName.count > 1 else {
            let alert = UIAlertController(title: "Ошибка", message: "Фамилия должнa содержать больше 1 символа", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        person?.setLastNAme(name: lastName )
        
        if ibPfone.text?.isEmpty == false {
            let numStr = Int(ibPfone.text ?? "0") ?? 0
            if numStr == 0 {
                let alert = UIAlertController(title: "Ошибка", message: "Некорректный номер телефона", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                return
            } else {
                person?.setPfoneNumber(pfoneNumber: numStr)
            }
        }
        if ibEmail.text?.isEmpty == false,
            ibEmail.text?.index(of: "@") == nil {
            let alert = UIAlertController(title: "Ошибка", message: "Некорректный eMail", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        } else {
            person?.setEmail(email: ibEmail.text)
        }
        person?.setPfoto(pfoto: ibImage.image) 
    }

    @objc private func tapRecognizerViewAndImage(_ sender: UITapGestureRecognizer) {        
        if sender.view == imageView {
            let alertVC = UIAlertController(title: "Добавить фото", message: "Добавить фото из галереи или камеры?", preferredStyle: .actionSheet)
            let galleryAction = UIAlertAction(title: "Галерея", style: .default, handler: { [weak self] _ in
                self?.addPfotoFromGallery()
            })
            
            let cameraAction = UIAlertAction(title: "Камера", style: .default, handler: { [weak self] _ in
                self?.addPfotoFromCamera()
            })
            
            alertVC.addAction(galleryAction)
            alertVC.addAction(cameraAction)
            self.present(alertVC, animated: true, completion: nil)
            
        } else {
            hideKeyboard()
        }
    }
}

// MARK: extention UITextFieldDelegate
extension ContactOfPersonViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
}

// MARK: extention notification
extension ContactOfPersonViewController {

    private func addNotificationKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: .UIKeyboardWillHide, object: nil)
    }
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }        
       // lcStackViewMargin.constant = keyboardFrame.size.height + 10
        reloadConstraints(top: 40, margin: keyboardFrame.size.height)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
       // hideKeyboard()
    }
    private func reloadConstraints(top: CGFloat, margin: CGFloat) {
        lcStackViewMargin.constant = margin
        let heightArea = self.view.frame.size.height - top - margin
        if heightArea > (lcImageHeight.constant + lcStackViewHeight.constant + 10) {
            lcImageTop.constant = (heightArea - lcImageHeight.constant - lcStackViewHeight.constant) / 2
            lcStackViewToImage.constant = lcImageTop.constant
        } else {
            if heightArea > (lcStackViewHeight.constant + 10 ) {
                lcImageTop.constant = 5
                lcStackViewToImage.constant = 5
                lcImageHeight.constant = (heightArea - lcImageTop.constant - lcStackViewHeight.constant - lcStackViewToImage.constant)
            } else {
                lcImageTop.constant = 5
                lcStackViewToImage.constant = 5
                lcStackViewHeight.constant = heightArea - 10
            }
        }
    }
}
extension ContactOfPersonViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func addPfotoFromGallery() {
        self.imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    private func addPfotoFromCamera() {
        self.imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func initPfoto() {
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String: Any]) {
        if let im = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ibImage.image = im
        } else {
            debugPrint("Error: Additing pfoto don't work")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

}
