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
    var imageHeight: CGFloat = 0
    var stackViewHeight: CGFloat = 0
    var stackViewToImage: CGFloat = 0

    @IBOutlet private weak var ibLastName: UITextField!
    @IBOutlet private weak var ibFirstName: UITextField!
    @IBOutlet private weak var ibPfone: UITextField!
    @IBOutlet private weak var ibEmail: UITextField!
    @IBOutlet private weak var ibImage: UIImageView!
    @IBOutlet private weak var ibAddOrChangeButton: UIBarButtonItem!
    @IBOutlet private weak var imageView: UIView!

    @IBOutlet private weak var lcStackViewMargin: NSLayoutConstraint!
    @IBOutlet private weak var lcImageHeight: NSLayoutConstraint!
    @IBOutlet private weak var lcStackViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var lcImageTop: NSLayoutConstraint!
    @IBOutlet private weak var lcStackViewToImage: NSLayoutConstraint!

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
        self.view.addGestureRecognizer(tapGestureViev)

        ibImage.layer.cornerRadius = ibImage.frame.size.height / 2
        ibImage.contentMode = .scaleAspectFill
        ibImage.layer.masksToBounds = true
        
        imageHeight = lcImageHeight.constant
        stackViewHeight = lcStackViewHeight.constant
        stackViewToImage = lcStackViewHeight.constant
        
        reloadConstraints(top: 10, margin: 10)

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
        guard let firstName = ibFirstName.text, firstName.count > 1,
            let lastName = ibLastName.text, lastName.count > 1
            else {
                showAlert(message: "Имя и фамилия должны содержать больше 1 символа" )
                return
        }
        if person != nil {
            validatePerson()
            DataManager.instance.changePerson(person!)
        } else {
            person = Person(firstName: firstName, lastName: lastName)
            validatePerson()
            DataManager.instance.addPerson(person!)
        }
         navigationController?.popViewController(animated: true)
    }

    private func validatePerson() {
        guard let firstName: String = ibFirstName.text, firstName.count > 1 else {
            showAlert(message: "Имя должно содержать больше 1 символа" )
            return
        }
        person?.setFirstName(name: firstName )
        guard let lastName = ibLastName.text, lastName.count > 1 else {
            showAlert(message: "Фамилия должнa содержать больше 1 символа" )
            return
        }
        person?.setLastNAme(name: lastName )
        
        if ibPfone.text?.isEmpty == false {
            let numStr = Int(ibPfone.text ?? "0") ?? 0
            if numStr == 0 {
                showAlert(message: "Некорректный номер телефона")
                return
            } else {
                person?.setPfoneNumber(pfoneNumber: numStr)
            }
        } else {
            person?.setPfoneNumber(pfoneNumber: nil)
        }
        if ibEmail.text?.isEmpty == false {
            if ibEmail.text?.index(of: "@") == nil {
                showAlert(message: "Некорректный eMail")
                return
            } else {
                person?.setEmail(email: ibEmail.text)
            }
        } else {
            person?.setEmail(email: nil)
        }
        if ibImage.image != #imageLiteral(resourceName: "user-5") {
            person?.setPfoto(pfoto: ibImage.image)
        } else {
           person?.setPfoto(pfoto: nil)
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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

            let cancelAction = UIAlertAction(title: "Отменить", style: .destructive, handler: { _ in })

            alertVC.addAction(galleryAction)
            alertVC.addAction(cameraAction)
            alertVC.addAction(cancelAction)

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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    }
    @objc private func hideKeyboard() {
        view.endEditing(true)
        reloadConstraints(top: 10, margin: 10)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        reloadConstraints(top: 10, margin: keyboardFrame.size.height)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        hideKeyboard()
    }
    
    private func reloadConstraints(top: CGFloat, margin: CGFloat) {
        let heightArea = self.view.frame.size.height - top - margin
        
        if heightArea > (imageHeight + stackViewHeight + stackViewToImage + 20) {
            imageView.isHidden = false
            lcImageHeight.constant = imageHeight
            lcStackViewHeight.constant = stackViewHeight
            
            lcStackViewToImage.constant = (heightArea - lcImageHeight.constant - lcStackViewHeight.constant - lcStackViewToImage.constant) / 5
            lcImageTop.constant = (heightArea - lcImageHeight.constant - lcStackViewHeight.constant - lcStackViewToImage.constant) / 2
            lcStackViewMargin.constant = lcImageTop.constant
        } else {
            if heightArea > (stackViewHeight + 10 ) {

                imageView.isHidden = false
                if imageHeight > (heightArea - stackViewHeight - 10) {
                    lcImageHeight.constant = (heightArea - stackViewHeight - 10)
                } else {
                    lcImageHeight.constant = imageHeight
                }
                lcStackViewHeight.constant = stackViewHeight
                
                lcStackViewToImage.constant = 10
                lcImageTop.constant = top + ((heightArea - imageHeight - lcStackViewToImage.constant - lcStackViewHeight.constant) / 2)
                lcStackViewMargin.constant = margin + lcImageTop.constant
                //margin
            } else {
                lcImageHeight.constant = 0
                imageView.isHidden = true
                lcStackViewHeight.constant = stackViewHeight
                lcStackViewToImage.constant = 10
                lcImageTop.constant = (heightArea - stackViewHeight - top - margin - 10) / 2
                lcStackViewMargin.constant = margin

            }
        }
        debugPrint("-------------------------")
        debugPrint("top=\(top), margin=\(margin), arHeight=\(heightArea), imHeight=\(lcImageHeight.constant), stackToIm=\(lcStackViewToImage.constant), stHeight=\(lcStackViewHeight.constant), top=\(lcImageTop.constant), margin =\(lcStackViewMargin.constant)")
        debugPrint("-------------------------")
    }
}
extension ContactOfPersonViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func addPfotoFromGallery() {
        self.imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    private func addPfotoFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {//isCameraDeviceAvailable
            self.imagePicker.sourceType = .camera
            present(self.imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Камера не работает", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }

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
