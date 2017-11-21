//
//  Notification+Extential.swift
//  PhoneBook
//
//  Created by Elena Goroshko on 11/20/17.
//  Copyright © 2017 Elena Goroshko. All rights reserved.
//

import Foundation
extension Notification.Name {
    static let ContactDeleted = Notification.Name("ContactDeleted")
    static let ContactDetailsChanged = Notification.Name("ContactDetailsChanged")
    static let ContactAdded = Notification.Name("ContactAdded")
}
