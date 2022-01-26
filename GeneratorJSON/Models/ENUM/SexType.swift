//
//  SexType.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import Foundation

enum SexType: Int, CaseIterable, StrChooseble, Property {
    case unisex = 0
    case male = 1
    case female = 2
    
    init(strValue: String) {
        switch strValue{
        case "Unisex":
            self = .unisex
        case "Male":
            self = .male
        case "Female":
            self = .female
        default:
            self = .unisex
        }
    }
    
    var id: String {"SexType_\(str)"}
    
    var str: String {
        switch self {
        case .unisex:
            return "Unisex"
        case .male:
            return "Male"
        case .female:
            return "Female"
        }
    }
    
    static var allCased: [String] {
        SexType.allCases.map({$0.str})
    }
}
