//
//  WorkoutsViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 02.10.2021.
//

import SwiftUI
import Combine

class WorkoutsViewModel: ObservableObject {
    private var cancellables: [AnyCancellable] = []
    
    var allWorkouts: [Workout] = []
    @Published var visibleWorkouts: [Workout] = []
    
    @Published var typeFilter: [WorkType] = []
    @Published var muscleFilter: [MuscleType] = []

    @Published var selectedWorkout: Workout = Workout()
   
    
    // MARK: - INIT
    init(){
        //1. СКАЧИВАЕМ ВСЕ ТРЕНИРОВКИ
        getAllWorkouts()
        
        //2. ПОДПИСЫВАЕМСЯ НА ИЗМЕНЕНИЯ
        observeFilters()
    }
    
    
    // MARK: - GET/SET WORKOUTS
    private func getAllWorkouts(){
        allWorkouts = CoreDataFuncs.shared.getAll(entity: WorkoutEntity.self, model: Workout.self)
        self.visibleWorkouts.append(contentsOf: allWorkouts)
    }
    
    // MARK: - FILTER
    private func observeFilters(){
        $typeFilter
            .combineLatest($muscleFilter)
            .sink(receiveValue: {[weak self]  typeTypes, muscleTypes in
                guard let self = self else {return}
                
                var workouts = self.allWorkouts
                
                //Фильтрация по ТИПУ
                if typeTypes.count > 0 {
                    workouts = workouts.filter({ workout in
                        typeTypes.contains(where: {$0 == workout.type})
                    })
                }
                
                //Фильтрация по мышцам
                if muscleTypes.count > 0 {
                    workouts = workouts.filter({ workout in
                        muscleTypes.contains { muscle in
                            workout.muscle.contains(where: {$0 == muscle})
                        }
                    })
                }
                
                DispatchQueue.main.async {
                    self.visibleWorkouts = workouts
                }
            }).store(in: &cancellables)
    }
    

    
    // MARK: - SAVE/ADD/DELETE EXERCISES
    func add(){
        print("ADD WORKOUT")
        let workout = Workout()
        allWorkouts.append(workout)
        visibleWorkouts.append(workout)
        
        self.selectedWorkout = workout
    }
    
    func delete(_ workout: Workout){
        print("DELETE WORKOUT")
        //1. Убераем выбор
        selectedWorkout = Workout()
        
        //2. Удаляем из БД
        CoreDataFuncs.shared.delete(entity: WorkoutEntity.self, model: workout)
        
        //3. Удаляем из списков упр
        allWorkouts.removeAll(where: {$0.id == workout.id})
        visibleWorkouts.removeAll(where: {$0.id == workout.id})
    }
    
    func save(_ workout: Workout){
        print("SAVE WORKOUT")
        //1. Сохраняем упражнение в БД
        CoreDataFuncs.shared.save(entity: WorkoutEntity.self, model: workout)
        
        //2. Обновляем массив упражнений
        self.allWorkouts.removeAll(where: {$0.id == workout.id})
        self.allWorkouts.append(workout)
        
        if let index = visibleWorkouts.firstIndex(where: {$0.id == workout.id}){
            visibleWorkouts.remove(at: index)
            visibleWorkouts.insert(workout, at: index)
        }
    }
    
    // MARK: - EDIT WORKOUT
    func addSeriaId(for workout: Workout, seriaId: String){
        var changedWorkout = workout
        changedWorkout.seriaId = seriaId
        
        save(changedWorkout)
    }
    
    func deleteSeriaId(for workout: Workout){
        var changedWorkout = workout
        changedWorkout.seriaId = nil
        
        save(changedWorkout)
    }
    
    // MARK: - JSON
    func generateJSON(){
        //  1 Получаем адрес папки
        guard var url = URL.getURL(location: .workoutJSON, create: true) else {return}
        
        url.appendPathComponent("WorkoutJSON")
        url.appendPathExtension("json")
        
        // 2 Получаем даныне
        var dics = [String: Any]()
        dics["workouts"] = allWorkouts.map({$0.getForJSON()})
        
        // 3 Конвектируем в JSON и записываем
        do{
            let data = try JSONSerialization.data(withJSONObject: dics)
            try data.write(to: url)
        }
        catch {
            print("We have error while write a new exersise ")
        }
    }
}
