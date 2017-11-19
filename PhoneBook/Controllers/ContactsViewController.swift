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
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destVC = segue.destination as? ContactOfPersonViewController,
                segue.identifier == "detailsOfContact"
            else {
                fatalError("Error: It isn't detailsOfContact")
            }
        guard let cell = sender as? PersonTableViewCell,
            let indexPath = tabelView.indexPath(for: cell)
        else { return }
        destVC.person = getPerson(indexPath: indexPath)
    }
    // MARK: privat methods
    private func getPerson(indexPath: IndexPath) -> Person {
        let char = getCharacterOfAlphabet(section: indexPath.section)
        let persons = DataManager.instance.persons[char]
        guard let person = persons?[indexPath.row] else {
            fatalError("Error: Person does't exist")
        }
        return person
    }
    private func getCharacterOfAlphabet(section: Int) -> Character {
        let char = DataManager.instance.charOfAlphabet[section]
        return char
    }

}
// MARK: extantion for ContactsViewController
extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let char = getCharacterOfAlphabet(section: section)
        let persons = DataManager.instance.persons[char] ?? []
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

}
