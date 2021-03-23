//
//  WorkoutViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 05.03.2021.
//


import SwiftUI
import Combine
import SwiftyJSON

class WorkoutViewModel1: ObservableObject {
  
    /// - TAG: Private pr
    private var cancellables: [AnyCancellable] = []
    private let jsonName = "WorkoutJSON"
    
    /// - TAG: Published
    @Published var models: [Workout1] = []
    
    init(){
        //Получаем модели и подписываемся на их изменения
        models = getModels()
        updateModelsChanges()
    }
    
    private func updateModelsChanges(){
        cancellables = []
        
        models.forEach { workout in
            let c = workout.objectWillChange
                .sink(receiveValue: {[weak self] _ in
                    guard let self = self else {return}
                    self.objectWillChange
                })
            
            cancellables.append(c)
        }
    }
    
    private func getModels() -> [Workout1]{
        
        // 1 Получаем адрес папки Загрузки
        guard var url = URL.getURL(location: .workoutJSON, create: false) else {
            return []
        }
        url.appendPathComponent("WorkoutJSON")
        url.appendPathExtension("json")
        
        // 2 Пробуем извлечь информацию
        guard let data = try? Data(contentsOf: url, options: .mappedIfSafe),
              let json = try? JSON(data: data),
              let jsonArray = json["workouts"].array
        else {
            print("File \(jsonName) is not exist or it doesn't contain JSON data")
            return []
        }
        
        return jsonArray.compactMap({Workout1(data: $0)})
        
    }
    
    func saveModels(){
        //  1 Получаем адрес папки
        guard var url = URL.getURL(location: .workoutJSON, create: true) else {return}
        
        url.appendPathComponent("WorkoutJSON")
        url.appendPathExtension("json")
        
        
        // 2 Получаем даныне
        var dics = [String: Any]()
        dics["workouts"] = models.compactMap({$0.getDictinary()})
        
        // 3 Конвектируем в JSON и записываем
        do{
            let data = try JSONSerialization.data(withJSONObject: dics)
            try data.write(to: url)
        }
        catch {
            print("We have error while write a new exersise ")
        }
    }
    
    func addNewModel(new model: Workout1) {
        models.append(model)
        saveModels()
        updateModelsChanges()
    }
    
    
    func changeReleated(ids: [String]){
        ids.forEach({id in
            if let model = models.first(where: {$0.id == id}){
                model.releatedWorkouts = ids
            }
        })
    }
}
