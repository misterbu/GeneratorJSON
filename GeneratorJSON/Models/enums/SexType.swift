//
//  SexType.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import Foundation

enum SexType: Int, CaseIterable {
    case unisex = 0
    case male = 1
    case female = 2
    
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
}
