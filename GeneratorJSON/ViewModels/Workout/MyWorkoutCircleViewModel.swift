//
//  MyWorkoutCircleViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 28.06.2021.
//

import SwiftUI
import Combine

class MyWorkoutCircleViewModel: ObservableObject {
    @Published var circle: WorkoutCircle
    
    @Published var showCatalog: Bool = false
   
    @Published var circleWorkType: WorkType?
    
    
    init(circle: WorkoutCircle){
        self.circle = circle
       
    }
    
    // MARK: - PUBLIC FUNCS
    func addExercise(_ exercise: BasicExercise){
        //Определяем тип цикла по первому упржанению
        if circleWorkType == nil {
            circleWorkType = exercise.type
        }
        
        
        if let circleWorkType = circleWorkType,
           exercise.type == circleWorkType {
            if circleWorkType == .hiit {
                circle.exercises.append(IntervalExercise(exercise, order: circle.exercises.count))
            } else if circleWorkType == .strenght {
                circle.exercises.append(StrenghtExercise(exercise, order: circle.exercises.count))
            }
        }
    }
    
    func deleteExercise(_ exercise: Exercise){
        circle.exercises.removeAll(where: {$0.id == exercise.id})
    }
}
