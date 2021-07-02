//
//  MyExercisesCatalogViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 29.06.2021.
//

import SwiftUI

class AddExerciseCatalogViewModel: ObservableObject {
    var allExercises: [BasicExercise] = []
    
    @Published var exercises: [BasicExercise] = []
    @Published var type: WorkType = .hiit {
        willSet {
            exercises = allExercises.filter({$0.type == newValue})
        }
    }
    
    init() {
        allExercises.append(contentsOf: CoreDataFuncs.shared.getAll(entity: ExerciseEntity.self, model: BasicExercise.self))
        exercises = allExercises.filter({$0.type == type})
    }
    
    func  getExercise(_ basic: BasicExercise, order: Int) -> Exercise? {
        switch basic.type {
        
        case .combine:
            return nil
        case .hiit:
            return IntervalExercise(basic, order: order)
        case .strenght:
            return StrenghtExercise(basic, order: order)
        case .stretching:
            return nil
        }
    }
}
