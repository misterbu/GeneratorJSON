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
            return "ProgramJSON"
        case .workout:
            return "WorkoutJSON"
        case .exercise:
            return "ExerciseJSON"
        }
    }
}


