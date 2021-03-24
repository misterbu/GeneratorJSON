//
//  ExerciseViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 24.03.2021.
//

import SwiftUI


class ExerciseViewModel: ObservableObject {
    @Published var exercise: Exercise
    
    init(_ exersice: Exercise) {
        self.exercise = exersice
    }
}
