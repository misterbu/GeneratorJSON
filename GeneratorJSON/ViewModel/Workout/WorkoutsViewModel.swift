//
//  WorkoutsViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 25.03.2021.
//

import SwiftUI

class WorkoutsViewModel: ObservableObject {
    @Published var workouts: [WorkoutViewModel] = []
    @Published var workout: WorkoutViewModel?
    
    init() {
       getAllWorkouts()
        print("WorkoutsVM: workouts count \(workouts.count)")
    }
    
    func getAllWorkouts(){
        workouts = CoreDataFuncs.shared.getAll(entity: WorkoutEntity.self, model: Workout.self)
            .map({WorkoutViewModel($0)})
    }
    
    func createNewWorkout(){
        workout = Workout()
    }
    
    func choseWorkout(_ work: WorkoutViewModel){
        workout = work
    }
    
    func save(_ work: Workout?){
        //Проверяем что получили модель тренировки
        guard let work = work else {
            close()
            return
        }
        
        print("WorkoutsViewModel: Save workout \(work.name)")
        
        //1 Удаляем старую версию тренировки и добавляем новую
        workouts.removeAll(where: {$0.id == work.id})
        workouts.append(work)
        
        //2 Сохраняем в БД
        CoreDataFuncs.shared.save(entity: WorkoutEntity.self, model: work)
        
        //3 Закрываем
        close()
    }
    
    func close(){
        workout = nil
    }
}
