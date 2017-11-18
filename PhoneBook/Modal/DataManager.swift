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
        curentChar = "А"
    }

    private(set) var personsOfChar: [Person] = []
    private(set) var charOfAlphabet: [Character] = []
    private(set) var persons: [Character: [Person]] = [:]

    private(set) var curentChar: Character?

    // MAPK: private methods
    private func generatePerson() {
        self.charOfAlphabet = ["А", "Д", "Ж", "Я"]
        let person1 = Person(firstName: "Анна", lastName: "Иванова", pfoneNumber: 12345678)
        let person2 = Person(firstName: "Антон", lastName: "Петров", pfoneNumber: 12345678)
        let person3 = Person(firstName: "Андрей", lastName: "Сетченко", pfoneNumber: 12345678)
        self.persons["А"] = [person1, person2, person3]

        let person4 = Person(firstName: "Диана", lastName: "Васильева", pfoneNumber: 12345678)
        let person5 = Person(firstName: "Дмитрий", lastName: "Вацлав", pfoneNumber: 12345678)
        self.persons["Д"] = [person4, person5]

        let person6 = Person(firstName: "Жанна", lastName: "Умничева", pfoneNumber: 12345678)
        self.persons["Ж"] = [person6]

        let person7 = Person(firstName: "Яна", lastName: "Наченко", pfoneNumber: 12345678)
        let person8 = Person(firstName: "Ярослав", lastName: "Томенко", pfoneNumber: 12345678)
        self.persons["Я"] = [person7, person8]
    }
}
