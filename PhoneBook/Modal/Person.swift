//
//  Person.swift
//  PhoneBook
//
//  Created by Elena Goroshko on 11/17/17.
//  Copyright © 2017 Elena Goroshko. All rights reserved.
//

import UIKit

struct Person {
    private static var objectCount = 0

    private let id: Int
    private(set) var firstName: String 
    private(set) var lastName: String
    private(set) var pfoneNumber: Int?
    private(set) var pfoto: UIImage?
    private(set) var email: String?

    init(firstName: String, lastName: String) {
        Person.objectCount += 1
        self.id = Person.objectCount
        self.firstName = firstName
        self.lastName = lastName
        debugPrint("New person wifh id = ", id)
    }
    mutating func setFirstName(name: String) {
        self.firstName = name
    }
    mutating func setLastNAme(name: String) {
        self.lastName = name
    }
    mutating func setPfoneNumber(pfoneNumber: Int) {
        self.pfoneNumber = pfoneNumber
    }
    mutating func setPfoto(pfoto: UIImage) {
        self.pfoto = pfoto
    }
    mutating func setEmail(email: String) {
        self.email = email
    }

}
// MARK: extention Equatable
extension Person: Equatable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        debugPrint(lhs.id, " = ", rhs.id)
        return lhs.id == rhs.id
    }

}
