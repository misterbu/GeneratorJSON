//
//  ExercisesViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import SwiftUI

class ExercisesViewModel: ObservableObject {
    @Published var exercises: [Exercise] = []
    
    init(){
        //check core data
        getAllExerciseCD()
    }
    
    
    func getAllExerciseCD(){
        let inrerval = CoreDataFuncs.shared.getAll(entity: IntervalExerciseEntity.self, model: IntervalExercise.self)
        let strenght = CoreDataFuncs.shared.getAll(entity: StrenghtExerciseEntity.self, model: StenghtExercise.self)
        exercises.append(contentsOf: inrerval)
        exercises.append(contentsOf: strenght)
    }
}

