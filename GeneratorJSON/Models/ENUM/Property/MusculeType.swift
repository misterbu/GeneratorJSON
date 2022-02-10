//
//  MusculeType.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 24.03.2021.
//

import Foundation

enum MuscleType: Int, CaseIterable, Identifiable, Property {

    case chest = 0
    case shoulders
    case back
    case hands
    case legs
    case abs

    var id: String {"MuscleType_\(str)"}
    
    var str: String {
        switch self {
        case .chest:
            return "Chest"
        case .shoulders:
            return "Shoulders"
        case .back:
            return "Back"
        case .hands:
            return "Hangs"
        case .legs:
            return "Legs"
        case .abs:
            return "ABS"
        }
    }
    
    var type: PropertyType {.muscleType}
    
    static var allCased: [String] {
        return MuscleType.allCases.map({$0.str})
    }
    
    static var typeName: String {"Muscle"}
    static var multiSelect: Bool {true}

    static var allMuscles: [MuscleType] {
        return [.chest,.shoulders,.back,.hands,.legs,.abs]
    }

}
