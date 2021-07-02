//
//  AddWorkoutViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 30.06.2021.
//

import Foundation

class AddWorkoutViewModel: ObservableObject {
    var allWorkouts: [Workout] = []
    
    init(){
        self.allWorkouts = CoreDataFuncs.shared.getAll(entity: WorkoutEntity.self, model: Workout.self)
    }
    
    //Добавляем в тренировку ИД серии тренировок и сохраняем эту тренировку в БД
    func addSeriaToWorkout(seriaId: String, workout: Workout) -> Workout{
        var workout1 = workout
        workout1.seriaId = seriaId
        
        CoreDataFuncs.shared.save(entity: WorkoutEntity.self, model: workout1)
        
        return workout1
    }
}
