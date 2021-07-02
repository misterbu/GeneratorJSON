//
//  CircleType.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 25.06.2021.
//

import Foundation

enum CircleType: Int, CaseIterable {
    case warmUp = 0
    case main = 1
    case coolDown = 2
    
    var str: String {
        switch self {
        case .warmUp:
            return "Warm Up"
        case .main:
            return "Main"
        case .coolDown:
            return "Cool Down"
        }
    }
}
