//
//  WorkType.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import Foundation

enum WorkType: Int, CaseIterable, Property {
    case hiit = 0
    case strenght = 1

    var id: String {"WorkType_\(str)"}
    
    var str: String {
        switch self {
        case .hiit:
            return "HIIT"
        case .strenght:
            return "Strenght"
        }
    }
    
    var type: PropertyType {.exerciseType}
    
    static var typeName: String {"Type"}
    static var multiSelect: Bool {false}
    
    static var allCased: [String] {
        return WorkType.allCases.map({$0.str})
    }
}
