//
//  Property.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 26.01.2022.
//

import Foundation

protocol Property {
    var id: String {get}
    var str: String {get}
}


protocol HasProperties {
    var properties: [Property] {get set}
}
