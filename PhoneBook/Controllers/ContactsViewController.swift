//
//  ContactsViewController.swift
//  PhoneBook
//
//  Created by Elena Goroshko on 11/17/17.
//  Copyright © 2017 Elena Goroshko. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {

    @IBOutlet private weak var tabelView: UITableView!
    @IBOutlet private weak var ibSearchBar: UISearchBar!

    private var filteredContacts: [Person] = []
    private var isSerchActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Контакты"
        ibSearchBar.delegate = self

        tabelView.dataSource = self
        tabelView.delegate = self
        addObserversContacts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserversKeyboard()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserversKeyboard()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destVC = segue.destination as? ContactOfPersonViewController else {
            debugPrint("Error: It isn't detailsOfContact")
            return
        }

        if segue.identifier == "detailsOfContact" {
            guard let cell = sender as? PersonTableViewCell,
                let indexPath = tabelView.indexPath(for: cell)
                else { return }
            destVC.person = isSerchActive ? filteredContacts[indexPath.row] : getPerson(indexPath: indexPath)
        }
    }

    // MARK: privat methods
    private func getPerson(indexPath: IndexPath) -> Person {
        let char = getCharacterOfAlphabet(section: indexPath.section)
        let persons = DataManager.instance.contacts(of: char)
        return persons[indexPath.row]
    }
    private func getCharacterOfAlphabet(section: Int) -> Character {
        let char = DataManager.instance.charOfAlphabet[section]
        return char
    }

    private func filterContent(byName name: String) {
        isSerchActive = !name.isEmpty
        filteredContacts = DataManager.instance.serchPerson(byName: name)
        debugPrint(isSerchActive)
        tabelView.reloadData()
    }
   
}
// MARK: UITableViewDelegate, UITableViewDataSource
extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSerchActive {
            return filteredContacts.count
        } else {
            let char = getCharacterOfAlphabet(section: section)
            let persons = DataManager.instance.contacts(of: char)
            return persons.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell") as? PersonTableViewCell
            else { fatalError("Error: Cell does't exist") }
        let person = isSerchActive ? filteredContacts[indexPath.row] : getPerson(indexPath: indexPath)
        cell.update(firstName: person.firstName, lastName: person.lastName)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return isSerchActive ? 1 : DataManager.instance.charOfAlphabet.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isSerchActive ? "Resul of serch" : String(DataManager.instance.charOfAlphabet[section])
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { fatalError("Error: Delete don't work")  }
        let person = getPerson(indexPath: indexPath)
        DataManager.instance.deletePerson(person)
    }

}
// MARK: UISearchBarDelegate
extension ContactsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContent(byName: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboard()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        hideKeyboard()
    }
}
// MARK: extention notifications
extension ContactsViewController {
    
    private func addObserversContacts() {
        NotificationCenter.default.addObserver(self, selector:
            #selector(changeCell(_:)), name: .ContactDetailsChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector:
            #selector(changeCell(_:)), name: .ContactAdded, object: nil)
        NotificationCenter.default.addObserver(self, selector:
            #selector(changeCell(_:)), name: .ContactDeleted, object: nil)
    }
    
    private func  addObserversKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: .UIKeyboardWillHide, object: nil)
    }
    private func  removeObserversKeyboard() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    @objc private func keyboardWillShow(_ notification: Notification) {
        
    }
    @objc private func keyboardWillHide(_ notification: Notification) {
        hideKeyboard()
    }
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    @objc func changeCell(_ notification: Notification) {
        if isSerchActive {
            guard let searchText = self.ibSearchBar.text
                else {
                    tabelView.reloadData()
                    return
            }
            filterContent(byName: searchText)
        }
        tabelView.reloadData()
    }
}
