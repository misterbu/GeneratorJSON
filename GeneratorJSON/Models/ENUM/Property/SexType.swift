//
//  SexType.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import Foundation

enum SexType: Int, CaseIterable, Property {
    case unisex = 0
    case male = 1
    case female = 2
    
    var id: String {"SexType_\(str)"}
    
    var str: String {
        switch self {
        case .unisex:
            return "Not specify"
        case .male:
            return "Male"
        case .female:
            return "Female"
        }
    }
    
    var type: PropertyType {.sexType}
    
    static var typeName: String {"Gender type"}
    static var multiSelect: Bool {false}
    
    static var allCased: [String] {
        SexType.allCases.map({$0.str})
    }
}
