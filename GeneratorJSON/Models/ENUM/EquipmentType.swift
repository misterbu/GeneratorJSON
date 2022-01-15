//
//  EquipmentType.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import Foundation

enum EquipmentType: Int, CaseIterable, StrChooseble {
    case nothing = 0
    case gym = 1
    case dumbbells = 2
    case skippingRope = 3
    case horizontalBar = 4
    
    var str : String {
        switch self {
        case .nothing:
            return "Noring"
        case .gym:
            return "Gym"
        case .dumbbells:
            return "Dumbbells"
        case .skippingRope:
            return "Skipping rope"
        case .horizontalBar:
            return "Horizontal Bar"
        }
    }
    
    init(strValue: String){
        switch strValue {
        case "Noring":
            self = .nothing
        case "Gym":
            self = .gym
        case "Dumbbells":
            self = .dumbbells
        case "Skipping rope":
            self = .skippingRope
        case "Horizontal Bar":
            self = .horizontalBar
        default:
            self = .nothing
        }
    }
    
    static var allCased: [String]{
        return EquipmentType.allCases.map({$0.str})
    }
}
