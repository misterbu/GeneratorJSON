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
    var type: PropertyType {get}
    static var typeName: String {get}
    static var allCases: [Self] {get}
    static var multiSelect: Bool {get}
}


protocol HasProperties {
    var properties: [Property] {get set}
}




enum PropertyType {
    case exerciseType
    case levelsType
    case sexType
    case targetType
    case placeType
    case equipmentType
    case muscleType
}
