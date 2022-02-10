//
//  LevelType.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import Foundation

enum LevelType: Int, CaseIterable, Property {
    case all = 0
    case beginner = 1
    case intermediate = 2
    case profi = 3
    
//    init(strValue:String){
//        switch strValue {
//        case "all levels":
//            self = .all
//        case "beginner":
//            self = .beginner
//        case "intermediate":
//            self = .intermediate
//        case "profi":
//            self = .profi
//        default:
//            self = .all
//        }
//    }
    
    var id: String {"LevelType_\(str)"}
    
    var str: String {
        switch self {
        case .all:
            return "all levels"
        case .beginner:
            return "beginner"
        case .intermediate:
            return "intermediate"
        case .profi:
            return "profi"
        }
    }
    
    var type: PropertyType {.levelsType}
    
    static var typeName: String {"Level"}
    static var multiSelect: Bool {false}
    
    static var allCased: [String] {
        LevelType.allCases.map({$0.str})
    }
    
    
}
