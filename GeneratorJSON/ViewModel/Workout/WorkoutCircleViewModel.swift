//
//  WorkoutCircleViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 26.03.2021.
//

import SwiftUI

class WorkoutCircleViewModel: Identifiable, ObservableObject {
    @Published var workoutCircle: WorkoutCircle
    @Published var intervalsExercises: [IntervalExerciseCircleViewModel]
    @Published var strenghtExercises: [StrenghtExerciseCircleViewModel]
    
    @Published var showExercisesCatalog: Bool = false

    init(order: Int){
        self.workoutCircle = WorkoutCircle(order: order)
        self.intervalsExercises = []
        self.strenghtExercises = []
    }
    
    init(_ circle: WorkoutCircle){
        self.workoutCircle = circle
        
        self.intervalsExercises = circle.exercises.compactMap({
            if let interval = $0 as? IntervalExercise {
                return IntervalExerciseCircleViewModel(interval)
            } else {
                return nil
            }
        })
        
        self.strenghtExercises = circle.exercises.compactMap({
            if let strenght = $0 as? StrenghtExercise {
                return StrenghtExerciseCircleViewModel(strenght)
            } else {
                return nil
            }
        })
    }
    
    func addExercise(_ exercise: Exercise){
        workoutCircle.exercises.append(exercise)
    }
    
    //Открываем каталог упражнений
    func showCatalog(_ type: WorkType){
        self.showExercisesCatalog.toggle()
    }
    
    //Закрываем каталог
    func closeCatalog(){
        showExercisesCatalog = false
    }
    
    //Выбираем упражнение из каталога
    func choseExercise(exercise: BasicExercise){
        //1 Добавляем упражнение
        let type = exercise.type
        if type == .hiit {
            intervalsExercises.append(IntervalExerciseCircleViewModel(exercise, order: intervalsExercises.count))
        } else if type == .strenght {
            strenghtExercises.append(StrenghtExerciseCircleViewModel(exercise, order: strenghtExercises.count))
        }
        
        //2 Закрываем каталог
        closeCatalog()
    }
    
    
    //Возвращаем цикл или nil если он не заполнен
    func getCircle(_ type: WorkType) -> WorkoutCircle? {
        //1. В зависимости от типа тренировки заполняем цикл упражнениями
        if type == .hiit {
            workoutCircle.exercises = intervalsExercises.compactMap({ $0.getExercise() })
            //Если в цикле есть упражнения возвращаем цикл иначе nil
            print("WorkoutCircleViewModel: Get Circle \"\(workoutCircle.name)\", exercises count \(workoutCircle.exercises.count)")
            return workoutCircle.exercises.count > 0 ? workoutCircle : nil
        } else if type == .strenght {
            workoutCircle.exercises = strenghtExercises.compactMap({$0.getExercise()})
            print("WorkoutCircleViewModel: Get Circle \"\(workoutCircle.name)\", exercises count \(workoutCircle.exercises.count)")
            return workoutCircle.exercises.count > 0 ? workoutCircle : nil
        } else {
            return nil
        }
    }
    
    
    //Удаляем упражение
    func remove(_ exer: IntervalExerciseCircleViewModel){
        print("WorkoutCircleViewModel: remove interval exercise ")
        //1 Удаляем из списка
        intervalsExercises.removeAll(where: {$0.id == exer.id})
        //2 Удаляем из БД
        CoreDataFuncs.shared.delete(entity: IntervalExerciseEntity.self, model: exer.exercise)
    }
    
    //Удаляем упражение
    func remove(_ exer: StrenghtExerciseCircleViewModel){
        print("WorkoutCircleViewModel: remove strenght exercise ")
        //1 Удаляем из списка
        strenghtExercises.removeAll(where: {$0.id == exer.id})
        //2 Удаляем из БД
        CoreDataFuncs.shared.delete(entity: StrenghtExerciseEntity.self, model: exer.exercise)
    }
}




class IntervalExerciseCircleViewModel: Identifiable, ObservableObject {
    @Published var exercise: IntervalExercise
    
    @Published var duration: String = "" {
        willSet{
            if let number = Int(newValue), number >= 0 {
                exercise.duration = number
            }
        }
    }
    @Published var voiceComment: String = "" {
        willSet{
            exercise.voiceComment = newValue == "" ? nil : newValue
        }
    }
    
    init(_ base: BasicExercise, order: Int) {
        self.exercise = IntervalExercise(base, order: order)
    }
    
    init(_ exercise: IntervalExercise) {
        self.exercise = exercise
        self.duration = String(exercise.duration)
        self.voiceComment = exercise.voiceComment ?? ""
    }
    
    func getExercise() -> Exercise? {
        print("IntervalExerciseCircleViewModel: Get exercise \(exercise.basic.name), duration \(exercise.duration)")
        return exercise.duration > 0 ? exercise : nil
    }
    
    func remove(_ exerc: Exercise){
        
    }
}





class StrenghtExerciseCircleViewModel: Identifiable, ObservableObject {
    @Published var exercise: StrenghtExercise
    @Published var sets: [SetsStrenghtExerciseCircleViewModel] = []
    
    init(_ base: BasicExercise, order: Int) {
        self.exercise = StrenghtExercise(base, order: order)
    }
    
    init(_ exercise: StrenghtExercise){
        self.exercise = exercise
        self.sets = exercise.sets.map({SetsStrenghtExerciseCircleViewModel($0)})
    }
    
    func createNewSet(){
        sets.append(SetsStrenghtExerciseCircleViewModel(order: sets.count))
    }
    
    func getExercise() -> Exercise? {
        //1 Получаем сеты
        exercise.sets = sets.compactMap({$0.getSet()})
        
        print("StrenghtExerciseCircleViewModel: Get exercise \(exercise.basic.name), sets count \(exercise.sets.count)")
        //2 Если количество сетов > 0 возвращаем упражнение
        return exercise.sets.count > 0 ? exercise : nil
    }
}





class SetsStrenghtExerciseCircleViewModel: ObservableObject {
    @Published var exerciseSet: ExerciseSet
    
    @Published var reps: String = "0" {
        willSet{
            if let number = Int(newValue), number >= 0 {
                exerciseSet.reps = number
            }
        }
    }
    
    
    init(_ set: ExerciseSet){
        self.exerciseSet = set
        self.reps = "\(set.reps)"
    }
    
    init(order: Int){
        self.exerciseSet = ExerciseSet(order: order)
    }
    
    func getSet() -> ExerciseSet? {
        return exerciseSet.reps > 0 ? exerciseSet : nil
    }
}
