//
//  ExercisePropertyView ode.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 30.06.2021.
//

import SwiftUI

class IntervalExercisePropertyViewModel: ObservableObject {
    @Published var exercise: IntervalExercise
    
    init(exercise: IntervalExercise){
        self.exercise = exercise
    }
    
}


class StrenghtExercisePropertyViewModel: ObservableObject {
    @Published var exercise: StrenghtExercise
    @Published var sets: [StrenghtExercisePropertySetViewModel] = []
    
    init(exercise: StrenghtExercise){
        self.exercise = exercise
        self.sets = exercise.sets.map({StrenghtExercisePropertySetViewModel($0)})
    }
    
    func getExercise() -> Exercise {
        exercise.sets = sets.map({$0.set})
        exercise.sets.sort(by: {$0.order < $1.order})
        return exercise
    }
    
    func addSet(){
        sets.append(StrenghtExercisePropertySetViewModel(ExerciseSet(order: sets.count)))
    }
}


class StrenghtExercisePropertySetViewModel: ObservableObject {
    @Published var set: ExerciseSet
    
    init(_ set : ExerciseSet) {
        self.set = set
    }
}
