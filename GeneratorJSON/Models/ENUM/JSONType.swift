//
//  JSONType.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 28.01.2022.
//

import Foundation

enum JSONType {
    case program
    case workout
    case exercise
    
    var location: MyLocation {
        switch self {
        case .program:
            return .seriaJSON
        case .workout:
            return .workoutJSON
        case .exercise:
            return .exerciseJSON
        }
    }
    
    var prefix: String {
        switch self {
        case .program:
            return "json_program"
        case .workout:
            return "json_workout"
        case .exercise:
            return "json_exercise"
        }
    }
}


