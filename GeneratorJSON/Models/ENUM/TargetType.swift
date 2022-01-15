//
//  TargetType.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import Foundation

enum TargetType: Int, CaseIterable, StrChooseble {
    case healt = 0
    case loseWeight = 1
    case buildMuscule = 2
    case drying = 3
    
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
    
    init(strValue: String){
        switch strValue {
        case "Healt":
            self = .healt
        case "LoseWeight":
            self = .loseWeight
        case "BuildMuscule":
            self = .buildMuscule
        case  "Drying":
            self = .drying
        default:
            self = .healt
        }
    }
    
    static var allCased: [String]{
        return TargetType.allCases.map({$0.str})
    }
}
