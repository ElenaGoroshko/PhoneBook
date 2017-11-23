//
//  DataManager.swift
//  PhoneBook
//
//  Created by Elena Goroshko on 11/17/17.
//  Copyright © 2017 Elena Goroshko. All rights reserved.
//

import UIKit

final class DataManager {
    static let instance = DataManager()
    private init() {
        generatePerson()
    }

    private(set) var charOfAlphabet: [Character] = []
    private var persons: [Character: [Person]] = [:]

    // MAPK: private methods
    private func generatePerson() {
        self.charOfAlphabet = ["А", "Д", "Ж", "Я"]
        let person1 = Person(firstName: "Анна", lastName: "Иванова")
        let person2 = Person(firstName: "Антон", lastName: "Петров")
        let person3 = Person(firstName: "Андрей", lastName: "Сетченко")
        self.persons["А"] = [person1, person2, person3]

        let person4 = Person(firstName: "Диана", lastName: "Васильева")
        let person5 = Person(firstName: "Дмитрий", lastName: "Вацлав")
        self.persons["Д"] = [person4, person5]

        let person6 = Person(firstName: "Жанна", lastName: "Умничева")
        self.persons["Ж"] = [person6]

        let person7 = Person(firstName: "Яна", lastName: "Наченко")
        let person8 = Person(firstName: "Ярослав", lastName: "Томенко")
        self.persons["Я"] = [person7, person8]
    }

    private func findCharElseAddIt(_ char: Character) -> Bool {
        // return true when char found
        var index = -1
        for (i, ch) in charOfAlphabet.enumerated() {
            if ch == char {
                return true
            } else {
                if ch < char { index = i }
            }
        }
        charOfAlphabet.insert(char, at: index + 1)
        return false
    }

    // MARK: publik methods
    func contacts(of character: Character) -> [Person] {
        return persons[character] ?? []
    }

    func findPerson(_ person: Person) -> (Character?, Int?) { //return char and index if person.id exist
        for ch in charOfAlphabet {
            guard let persons = self.persons[ch] else { return(nil, nil)}
            for (i, p) in persons.enumerated() where p == person {
                return (ch, i)
            }
        }
      return(nil, nil)
    }

    func findPersonInSection(_ person: Person, in persons: [Person]) -> Int? {
        for (i, p) in persons.enumerated() where p == person {
                return i
        }
        return nil
    }

    func changePerson(_ person: Person) {

        var charOptional: Character?
        var indexOptional: Int?
        (charOptional, indexOptional) = findPerson(person)
        let char = person.firstName[person.firstName.startIndex]
        guard let index = indexOptional else {fatalError("Error: The person isn't contained in a DataManager")}

        if char == charOptional { //the person is contained in a self.persons[char]
            guard var persons = self.persons[char] else {fatalError("Error: The person isn't contained in a DataManager")}
            persons[index].setFirstName(name: person.firstName)
            persons[index].setLastNAme(name: person.lastName)
            if person.pfoneNumber != nil { persons[index].setPfoneNumber(pfoneNumber: person.pfoneNumber!) }
            if person.email != nil { persons[index].setEmail(email: person.email!) }
            if person.pfoto != nil { persons[index].setPfoto(pfoto: person.pfoto!) }
            self.persons[char] = persons
            NotificationCenter.default.post(name: .ContactDetailsChanged, object: nil)

        } else {  //the person is contained in a self.persons[charOptional]

            deletePerson(person)
            addPerson(person)
        }
        debugPrint(index)
    }

    func addPerson(_ person: Person) {
        let char = person.firstName[person.firstName.startIndex]

        if findCharElseAddIt(char) { //charOfAlphabet has this char
            var personsOfChar = self.contacts(of: char)
            personsOfChar.append(person)
            personsOfChar.sort(by: { $0.firstName < $1.firstName })
            self.persons[char] = personsOfChar
        } else { //charOfAlphabet hasn't this char
            self.persons[char] = [person]
        }
        NotificationCenter.default.post(name: .ContactAdded, object: nil)
    }

    func deleteSection(_ char: Character) {
        for (i, ch) in self.charOfAlphabet.enumerated() where ch == char {
           self.charOfAlphabet.remove(at: i)
        }
    }

    func deletePerson(_ person: Person) {
        let (ch, i) = findPerson(person)
        guard let char = ch else {fatalError("Error: The person isn't contained in a DataManager")}
        guard let index = i else {fatalError("Error: The person isn't contained in a DataManager")}
        var persons = self.contacts(of: char)
        persons.remove(at: index)
        self.persons[char] = persons
        if persons.isEmpty { deleteSection(char) }
        NotificationCenter.default.post(name: .ContactDeleted, object: nil)
    }
    
}
