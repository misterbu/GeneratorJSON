//
//  LevelType.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import Foundation

enum LevelType: Int {
    case all = 0
    case beginner = 1
    case intermediate = 2
    case profi = 3
    
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
}
