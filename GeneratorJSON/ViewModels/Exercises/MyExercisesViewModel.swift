//
//  MyExercisesViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 25.06.2021.
//

import SwiftUI
import Combine

class MyExercisesViewModel: ObservableObject {
    @Published var exercises: [BasicExercise] = []
    //@Published var selectedExercise: MyExerciseViewModel?
    
    lazy var cancellables: [AnyCancellable] = []
    
    init(){
       // resetCD()
        //Получаем все упражнения
        exercises.append(contentsOf: CoreDataFuncs.shared.getAll(entity: ExerciseEntity.self, model: BasicExercise.self))
        print("ExercisesVM: exercises count! \(exercises.count)")
        
        //Подписываемся на сохраниние упражнений
        observeSaveExerices()
    }
    
    // MARK: - PUBLIC FUNCS
    func create(){
        let exercise = BasicExercise()
        exercises.append(exercise)
        saveExercise(exercise)
    }

    
    func delete(exercise: BasicExercise){
        //Удаляем упражнение из списка упражнений
        exercises.removeAll(where: {$0.id == exercise.id})
        
        //Удаляем из БД
        removeExercise(exercise: exercise)
    }
    
    func generateJSON(){
        //  1 Получаем адрес папки
        guard var url = URL.getURL(location: .exerciseJSON, create: true) else {return}
        
        url.appendPathComponent("ExerciseJSON")
        url.appendPathExtension("json")
        
        // 2 Получаем даныне
        var dics = [String: Any]()
        dics["exercises"] = exercises.map({$0.getForJSON()})
        
        // 3 Конвектируем в JSON и записываем
        do{
            let data = try JSONSerialization.data(withJSONObject: dics)
            try data.write(to: url)
        }
        catch {
            print("We have error while write a new exersise ")
        }
    }
    
    
    // MARK: - PRIVATE FUNCS
    private func saveExercise(_ exercise: BasicExercise){
        CoreDataFuncs.shared.save(entity: ExerciseEntity.self, model: exercise)
    }
    
    private func removeExercise(exercise: BasicExercise){
        CoreDataFuncs.shared.delete(entity: ExerciseEntity.self, model: exercise)
    }
    
    private func resetCD(){
        CoreDataFuncs.shared.deleteAll(entity: CircleEntity.self)
        CoreDataFuncs.shared.deleteAll(entity: IntervalExerciseEntity.self)
        CoreDataFuncs.shared.deleteAll(entity: StrenghtExerciseEntity.self)
        CoreDataFuncs.shared.deleteAll(entity: WorkoutEntity.self)
        CoreDataFuncs.shared.deleteAll(entity: ExerciseSetEntity.self)
    }
    
    private func observeSaveExerices(){
        NotificationCenter.default.publisher(for: .saveExercise)
            .sink(receiveValue: {[weak self] value in
                guard let self = self else {return}
                
                //Если мы получаем сохранненое упражение изменяем его в списке и сохраняем в БД
                if let exercise = value.userInfo?["exercise"] as? BasicExercise {
                    self.exercises.removeAll(where: {$0.id == exercise.id})
                    self.exercises.append(exercise)
                    
                    self.saveExercise(exercise)
                }
            }).store(in: &cancellables)
    }
}

