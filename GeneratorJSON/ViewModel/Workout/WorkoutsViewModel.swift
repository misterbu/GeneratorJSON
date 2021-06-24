//
//  WorkoutsViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 25.03.2021.
//

import Combine
import SwiftUI

class WorkoutsViewModel: ObservableObject {
    @Published var workouts: [WorkoutViewModel] = []
    @Published var workout: WorkoutViewModel?
    
    /// - TAG: Combine
    private lazy var cancellables: [AnyCancellable] = []
    
    
    /// - TAG: INITs
    init() {
        //1 Подписываемся на уведомление о добавлении новых тренировок
        NotificationCenter.default.publisher(for: .saveNewWorkout)
            .sink(receiveValue: {[weak self] _ in
                guard let self = self else {return}
                //1.1 Обновняем каталог тренировок
                self.getAllWorkouts()
                
                //1.2 Закрываем окно создания или редоктирования тренировок
                self.close()
            }).store(in: &cancellables)
        
        //2 Проверяем тренировки по умолчанию
        getAllWorkouts()
        
        
        print("WorkoutsVM: workouts count \(workouts.count)")
    }
    
    func getAllWorkouts(){
        workouts = CoreDataFuncs.shared.getAll(entity: WorkoutEntity.self, model: Workout.self)
            .map({WorkoutViewModel($0)})
    }
    
    func createNewWorkout(){
        workout = WorkoutViewModel(Workout())
    }
    
    func choseWorkout(_ work: WorkoutViewModel){
        workout = work
    }
    
    func close(){
        workout = nil
    }
    
    func getFreeWorkouts() -> [WorkoutViewModel] {
        return workouts.filter({$0.workout.seriaId == nil || $0.workout.seriaId == "" })
    }
    
    func generateJSON(){
        //  1 Получаем адрес папки
        guard var url = URL.getURL(location: .workoutJSON, create: true) else {return}
        
        url.appendPathComponent("WorkoutJSON")
        url.appendPathExtension("json")
        
        // 2 Получаем даныне
        var dics = [String: Any]()
        dics["workouts"] = workouts.map({$0.workout.getForJSON()})
        
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
