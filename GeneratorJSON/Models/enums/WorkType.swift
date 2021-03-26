//
//  WorkType.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import Foundation

enum WorkType: Int, CaseIterable {
    case combine = 0
    case hiit = 1
    case strenght = 2
    case stretching = 3
    
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
}
