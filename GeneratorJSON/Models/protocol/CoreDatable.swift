//
//  CoreDatable.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import Foundation
import CoreData

protocol CoreDatable {
    var id: String {get}
    init<S: NSManagedObject>(entity: S)
    func setEntity<S: NSManagedObject>(entity: S) -> S
}

