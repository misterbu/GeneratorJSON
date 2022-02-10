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

final class PropertyHelp {
    static func getProperty(from id: String)->Property?{
        guard id != "" else {return nil}
        guard let preffix = id.components(separatedBy: "_").first, preffix != "" else {return nil}
        
        switch preffix {
        case "WorkType":
            return WorkType.allCases.first(where: {$0.id == id})
        case "LevelType":
            return LevelType.allCases.first(where: {$0.id == id})
        case "SexType":
            return SexType.allCases.first(where: {$0.id == id})
        case "TargetType":
            return TargetType.allCases.first(where: {$0.id == id})
        case "EquipmentType":
            return EquipmentType.allCases.first(where: {$0.id == id})
        case "PlaceType":
            return PlaceType.allCases.first(where: {$0.id == id})
        case "MuscleType":
            return MuscleType.allCases.first(where: {$0.id == id})
        default: return nil
        }
    }
}
