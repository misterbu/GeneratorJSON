//
//  EquipmentType.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import Foundation

enum EquipmentType: Int, CaseIterable {
    case noting = 0
    case gym = 1
    case outdoor = 2
    
    var str : String {
        switch self {
        case .noting:
            return "Noring"
        case .gym:
            return "Gym"
        case .outdoor:
            return "Outdoor"
        }
    }
    
    init(strValue: String){
        switch strValue {
        case "Noring":
            self = .noting
        case "Gym":
            self = .gym
        case "Outdoor":
            self = .outdoor
        default:
            self = .noting
        }
    }
}
