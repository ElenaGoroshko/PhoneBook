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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Контакты"

        tabelView.dataSource = self
        tabelView.delegate = self

        addObservers()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destVC = segue.destination as? ContactOfPersonViewController
            else { fatalError("Error: It isn't detailsOfContact") }

        if segue.identifier == "detailsOfContact" {
            guard let cell = sender as? PersonTableViewCell,
                let indexPath = tabelView.indexPath(for: cell)
            else { return }
            destVC.person = getPerson(indexPath: indexPath)
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

    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector:
            #selector(changeCell(_:)), name: .ContactDetailsChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector:
            #selector(changeCell(_:)), name: .ContactAdded, object: nil)
        NotificationCenter.default.addObserver(self, selector:
            #selector(changeCell(_:)), name: .ContactDeleted, object: nil)
    }

    // MARK: public methods
    @objc func changeCell(_ notification: Notification) {
        tabelView.reloadData()
    }
}
// MARK: extantion for ContactsViewController
extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let char = getCharacterOfAlphabet(section: section)
        let persons = DataManager.instance.contacts(of: char)
     return persons.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell") as? PersonTableViewCell
            else {
                fatalError("Error: Cell does't exist")
        }
        let person = getPerson(indexPath: indexPath)
        cell.update(firstName: person.firstName, lastName: person.lastName)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return DataManager.instance.charOfAlphabet.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(DataManager.instance.charOfAlphabet[section])
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let person = getPerson(indexPath: indexPath)
        DataManager.instance.deletePerson(person)
    }
}
