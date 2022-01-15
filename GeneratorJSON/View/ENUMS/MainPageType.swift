//
//  MainPageType.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 01.10.2021.
//

import Foundation
import SwiftUI

enum MainPageType {
    case programs
    case workouts
    case exercises
    
    var name: String {
        switch self {
        case .programs:
            return "Programs"
        case .workouts:
            return "Workouts"
        case .exercises:
            return "Exercises"
        }
    }
    
    var image: Image {
        switch self {
        case .programs:
            return Image(systemName: "leaf.fill")
        case .workouts:
            return Image(systemName: "ladybug")
        case .exercises:
            return Image(systemName: "flame.fill")
        }
    }
}
