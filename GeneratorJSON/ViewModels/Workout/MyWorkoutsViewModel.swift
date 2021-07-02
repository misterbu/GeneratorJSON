//
//  MyWorkoutsViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 28.06.2021.
//

import SwiftUI
import Combine

class MyWorkoutsViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    
    lazy var cancellables: [AnyCancellable] = []
    
    init(){
        //Получаем все тренировки
        self.workouts.append(contentsOf: CoreDataFuncs.shared.getAll(entity: WorkoutEntity.self, model: Workout.self))
        print("WorkoutsVM: Workouts count! \(workouts.count)")
        
        //Подписываемся на сохранение тренировки
        observeSaveWorkout()
    }
    
    // MARK: - PUBLIC FUNCS
    func create(){
        let workout = Workout()
        workouts.append(workout)
        saveWorkout(workout)
    }

    
    func delete(workout: Workout){
        //Удаляем упражнение из списка упражнений
        workouts.removeAll(where: {$0.id == workout.id})
        
        //Удаляем из БД
        removeWorkout(workout: workout)
    }
    
    func generateJSON(){
        //  1 Получаем адрес папки
        guard var url = URL.getURL(location: .workoutJSON, create: true) else {return}
        
        url.appendPathComponent("WorkoutJSON")
        url.appendPathExtension("json")
        
        // 2 Получаем даныне
        var dics = [String: Any]()
        dics["workouts"] = workouts.map({$0.getForJSON()})
        
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
    private func saveWorkout(_ workout: Workout){
        CoreDataFuncs.shared.save(entity: WorkoutEntity.self, model: workout)
    }
    
    private func removeWorkout(workout: Workout){
        CoreDataFuncs.shared.delete(entity: WorkoutEntity.self, model: workout)
    }
    
    private func observeSaveWorkout(){
        NotificationCenter.default.publisher(for: .saveWorkout)
            .sink(receiveValue: {[weak self] value in
                guard let self = self else {return}
                
                if let workout = value.userInfo?["workout"] as? Workout {
                    self.workouts.removeAll(where: {$0.id == workout.id})
                    self.workouts.append(workout)
                    
                    self.saveWorkout(workout)
                }
            }).store(in: &cancellables)
    }
}
