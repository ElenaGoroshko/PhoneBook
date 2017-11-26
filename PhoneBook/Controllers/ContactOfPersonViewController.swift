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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ibFirstName.delegate = self
        self.ibLastName.delegate = self
        self.ibPfone.delegate = self
        self.ibEmail.delegate = self
        
//        self.imagePicker = UIImagePickerController()
//        self.imagePicker.delegate = self
//        self.imagePicker.sourceType = .photoLibrary
        
        let tapGestureImage = UITapGestureRecognizer(target: self, action: #selector(tapRecognizerViewAndImage(_:)))
        imageView.addGestureRecognizer(tapGestureImage)
        let tapGestureViev = UITapGestureRecognizer(target: self, action: #selector(tapRecognizerViewAndImage(_:)))
        parentView.addGestureRecognizer(tapGestureViev)
        
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
        guard let firstName = ibFirstName.text else { return }
        person?.setFirstName(name: firstName )
        guard let lastName = ibLastName.text else { return }
        person?.setLastNAme(name: lastName )
        let numStr = Int(ibPfone.text ?? "0") ?? 0
        if numStr != 0 {
            person?.setPfoneNumber(pfoneNumber: numStr)
        }
        person?.setEmail(email: ibEmail.text)
        person?.setPfoto(pfoto: ibImage.image) 
    }

    @objc private func tapRecognizerViewAndImage(_ sender: UITapGestureRecognizer) {        
        if sender.view == imageView {
            ibImage.image = nil
        } else {
            hideKeyboard()
        }
    }
}
// MARK: nfbafkjl
/*class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
 
 @IBOutlet weak var imageTake: UIImageView!
 
 var imagePicker: UIImagePickerController!
 override func viewDidLoad() {
 super.viewDidLoad()
 }
 @IBAction func takePhoto(_ sender: UIButton) {
    imagePicker =  UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .camera
    present(imagePicker, animated: true, completion: nil)
 }
 
 //MARK: - Saving Image here
 @IBAction func save(_ sender: AnyObject) {
    UIImageWriteToSavedPhotosAlbum(imageTake.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
 }
 
 //MARK: - Add image to Library
 func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    if let error = error {
    // we got back an error!
        let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    } else {
        let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
 }
 */

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

    }

    @objc private func keyboardWillHide(_ notification: Notification) {
       // hideKeyboard()
    }
}
extension ContactOfPersonViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
