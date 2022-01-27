//
//  MusculeType.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 24.03.2021.
//

import Foundation

enum MuscleType: Int, CaseIterable, Identifiable, StrChooseble, Property {
    case fullBody = 0
    case upperBody = 1
    case lowBody = 2
    case chest = 10
    case shoulders = 20
    case back = 30
    case hands = 40
    case legs = 50
    case abs = 60
    
    init(strValue: String){
        print("INIT \(strValue)")
        switch strValue {
        case "Full body":
            self = .fullBody
        case "Upper body":
            self = .upperBody
        case "Low body":
            self = .lowBody
        case "Chest":
            self = .chest
        case "Shoulders":
            self = .shoulders
        case "Back":
            self = .back
        case "Hangs":
            self = .hands
        case "Legs":
            self = .legs
        case "ABS":
            self = .abs
        default:
            self = .fullBody
        }
    }
    
    
    var id: String {"MuscleType_\(str)"}
    
    var str: String {
        switch self {
        case .fullBody:
            return "Full body"
        case .upperBody:
            return "Upper body"
        case .lowBody:
            return "Low body"
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
        return [.fullBody, .lowBody , .upperBody, .chest,.shoulders,.back,.hands,.legs,.abs]
    }

}
