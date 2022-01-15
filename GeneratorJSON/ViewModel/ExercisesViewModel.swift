//
//  ExercisesViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 01.10.2021.
//

import SwiftUI
import Combine

class ExercisesViewModel: ObservableObject {
    
    private var cancellables: [AnyCancellable] = []
    
    var allExerises: [BasicExercise] = []
    @Published var visibleExercises: [BasicExercise] = []
    
    @Published var muscleFilter: [MuscleType] = []
    @Published var typeFilter: [WorkType] = []
    
    @Published var selectedExercise: BasicExercise = BasicExercise()
    
   
    
    // MARK: - INIT
    init() {
        //1. СКАЧИВАЕМ ВСЕ УПРАЖНЕНИЯ
        self.getAllExercises()
         
        //2. Подписываемся на изменения
        self.observeFilters()
    }
    
    // MARK: - GET/SET EXERCISES
    private func getAllExercises(){
        self.allExerises = CoreDataFuncs.shared.getAll(entity: ExerciseEntity.self, model: BasicExercise.self)
        self.visibleExercises.append(contentsOf: allExerises)
    }
    
    // MARK: - FILTER
    private func observeFilters(){
        $muscleFilter
            .combineLatest($typeFilter)
            .sink { [weak self] muscleTypes, typeTypes  in
                guard let self = self else {return}

                var exercises = self.allExerises
                
                //Фильтрация по ГРУППАМ МЫШЦ
                if muscleTypes.count > 0 {
                    exercises = exercises.filter({ exercise in
                        muscleTypes.contains(where: { muscle in
                            exercise.muscle.contains(where: {$0 == muscle})
                        })
                    })
                }
                
                //Фильтрация по ТИПУ
                if typeTypes.count > 0 {
                    exercises = exercises.filter({ exercise in
                        typeTypes.contains(where: {$0 == exercise.type})
                        
                    })
                }
                
                //Устанавливаем видимые упр
                DispatchQueue.main.async {
                    self.visibleExercises = exercises
                }
                
            }.store(in: &cancellables)
            
    }
    
    // MARK: - SAVE/ADD/DELETE EXERCISES
    func add(){
        print("ADD EXERCISE")
        let exercise = BasicExercise()
        allExerises.append(exercise)
        visibleExercises.append(exercise)
        selectedExercise = exercise
    }
    
    func delete(_ exercise: BasicExercise){
        print("DELETE EXERCISE")
        
        //1. Убераем выбор
        selectedExercise = BasicExercise()
        
        //2. Удаляем из БД
        CoreDataFuncs.shared.delete(entity: ExerciseEntity.self, model: exercise)
        
        //3. Удаляем из списков упр
        allExerises.removeAll(where: {$0.id == exercise.id})
        visibleExercises.removeAll(where: {$0.id == exercise.id})
    }
    
    func save(_ exercise: BasicExercise){
        print("SAVE EXERCISE")
        //1. Сохраняем упражнение в БД
        CoreDataFuncs.shared.save(entity: ExerciseEntity.self, model: exercise)
        
        //2. Обновляем массив упражнений
        self.allExerises.removeAll(where: {$0.id == exercise.id})
        self.allExerises.append(exercise)
        
        if let index = visibleExercises.firstIndex(where: {$0.id == exercise.id}){
            visibleExercises.remove(at: index)
            visibleExercises.insert(exercise, at: index)
        }
    }
    
    
    // MARK: - JSON
    func generateJSON(){
        //  1 Получаем адрес папки
        guard var url = URL.getURL(location: .exerciseJSON, create: true) else {return}
        
        url.appendPathComponent("ExerciseJSON")
        url.appendPathExtension("json")
        
        // 2 Получаем даныне
        var dics = [String: Any]()
        dics["exercises"] = allExerises.map({$0.getForJSON()})
        
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
