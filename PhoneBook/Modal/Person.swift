//
//  Person.swift
//  PhoneBook
//
//  Created by Elena Goroshko on 11/17/17.
//  Copyright © 2017 Elena Goroshko. All rights reserved.
//

import UIKit

struct Person {
    private(set) var firstName: String
    private(set) var lastName: String
    private(set) var pfoneNumber: Int
    private(set) var pfoto: UIImage?
    private(set) var emai: String?
    

    init(firstName: String, lastName: String, pfoneNumber: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.pfoneNumber = pfoneNumber
    }
    private mutating func setFirstName(name: String){
        self.firstName = name
    }
    private mutating func setLastNAme(name: String){
        self.lastName = name
    }
    private mutating func setPfoneNumber(pfoneNumber: Int){
        self.pfoneNumber = pfoneNumber
    }
    private mutating func setPfoto(pfoto:UIImage){
        self.pfoto = pfoto
    }
    private mutating func setEmail(emai: String){
        self.emai = emai
    }
        
}
