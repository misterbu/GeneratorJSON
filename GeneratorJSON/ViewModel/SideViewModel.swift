//
//  SideViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 11.10.2021.
//

import SwiftUI

class StrenghtSideViewModel: ObservableObject{
    @Published var exercise: StrenghtExercise

    init(exercise: StrenghtExercise){
        self.exercise = exercise
    }
}


class IntervalSideViewModel: ObservableObject{
    @Published var exercise: IntervalExercise

    init(exercise: IntervalExercise){
        self.exercise = exercise
    }
}
