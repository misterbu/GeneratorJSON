//
//  ExercisesViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import SwiftUI

class ExercisesViewModel: ObservableObject {
    @Published var exercises: [BasicExercise] = []
    @Published var exercise: BasicExercise?
    
    init(){
       // resetCD()
        getAllExerciseCD()
        print("ExercisesVM: exercises count \(exercises.count)")
    }
    
    
    func getAllExerciseCD(){
        exercises = CoreDataFuncs.shared.getAll(entity: ExerciseEntity.self, model: BasicExercise.self)
    }
    
    func getExercises(_ type: WorkType) -> [BasicExercise]{
        return exercises.filter({$0.type == type})
    }
    
    func createNewExercise(){
        exercise = BasicExercise()
    }
    
    func chooseExercise(_ exerc: BasicExercise){
        exercise = exerc
    }
    
    func save(_ exerc: BasicExercise){
        
        //1 Удаляем старую версию упраженния если уже есть и добавляем новую
        exercises.removeAll(where: {$0.id == exerc.id})
        exercises.append(exerc)

        //2 Сохраняем в БД
        CoreDataFuncs.shared.save(entity: ExerciseEntity.self, model: exerc)
        
        //3 Закрываем вью
        close()
        
    }
    
    func close(){
        exercise = nil
    }
    
    
    private func resetCD(){
        CoreDataFuncs.shared.deleteAll(entity: CircleEntity.self)
        CoreDataFuncs.shared.deleteAll(entity: IntervalExerciseEntity.self)
        CoreDataFuncs.shared.deleteAll(entity: StrenghtExerciseEntity.self)
        CoreDataFuncs.shared.deleteAll(entity: WorkoutEntity.self)
    }
}

