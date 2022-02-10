//
//  EquipmentType.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import Foundation

enum EquipmentType: Int, CaseIterable, Property {
    case gym = 0
    case dumbbells
    case skippingRope
    case horizontalBar
    
    var id: String {"EquipmentType_\(str)"}
    
    var str : String {
        switch self {
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
    
    var type: PropertyType {.equipmentType}
    
    static var typeName: String {"Equipnent"}
    static var multiSelect: Bool {true}
    
    static var allCased: [String]{
        return EquipmentType.allCases.map({$0.str})
    }
}
