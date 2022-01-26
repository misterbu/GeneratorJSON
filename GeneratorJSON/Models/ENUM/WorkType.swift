//
//  WorkType.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import Foundation

enum WorkType: Int, CaseIterable, StrChooseble, Property {
    case combine = 0
    case hiit = 1
    case strenght = 2
    case stretching = 3
    
    init(strValue: String){
        switch strValue{
        case "Combine":
            self = .combine
        case "HIIT":
            self = .hiit
        case "Strenght":
            self = .strenght
        case "Streiching":
            self = .stretching
        default:
            self = .hiit
        }
    }
    
    var id: String {"WorkType_\(str)"}
    
    var str: String {
        switch self {
        case .combine:
            return "Combine"
        case .hiit:
            return "HIIT"
        case .strenght:
            return "Strenght"
        case .stretching:
            return "Streiching"
        }
    }
    
    static var allCased: [String] {
        return WorkType.allCases.map({$0.str})
    }
}
