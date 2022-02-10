//
//  TargetType.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import Foundation

enum TargetType: Int, CaseIterable, Property {
    case healt = 0
    case loseWeight = 1
    case buildMuscule = 2
    case drying = 3

    var id: String {"TargetType_\(str)"}
    
    var str: String {
        switch self {
        case .healt:
            return "Healt"
        case .loseWeight:
            return "LoseWeight"
        case .buildMuscule:
            return "BuildMuscule"
        case .drying:
            return "Drying"
        }
    }
    
    var type: PropertyType {.targetType}
    
    static var typeName: String {"Target"}
    static var multiSelect: Bool {true}
     
    static var allCased: [String]{
        return TargetType.allCases.map({$0.str})
    }
}
