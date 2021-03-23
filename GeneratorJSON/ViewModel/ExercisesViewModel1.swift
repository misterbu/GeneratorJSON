//
//  ExerciseViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 04.03.2021.
//

import SwiftUI
import Combine
import SwiftyJSON

class ExercisesViewModel1: ObservableObject {
    
    /// - TAG: Private pr
    private var cancellables: [AnyCancellable] = []
    private let jsonName = "ExersisesJSON"
    
    /// - TAG: Published
    @Published var models: [Exercise1] = []
    var exercise = Exercise1()
    
    init(){
        //Получаем модели и подписываемся на их изменения
        models = getExercises()
        updateModelsChanges()
    }
    
    private func updateModelsChanges(){
        cancellables = []
        
        models.forEach { exercise in
            let c = exercise.objectWillChange
                .sink(receiveValue: {[weak self] _ in
                    guard let self = self else {return}
                    self.objectWillChange
                })
            
            cancellables.append(c)
        }
    }
    
    private func getExercises() -> [Exercise1]{
        
        // 1 Получаем адрес папки Загрузки
        guard var url = URL.getURL(location: .exerciseJSON, create: false) else {
            return []
        }
        url.appendPathComponent("ExerciseJSON")
        url.appendPathExtension("json")
        
        // 2 Пробуем извлечь информацию
        guard let data = try? Data(contentsOf: url, options: .mappedIfSafe),
              let json = try? JSON(data: data),
              let jsonArray = json["exercises"].array
        else {
            print("File \(jsonName) is not exist or it doesn't contain JSON data")
            return []
        }
        
        return jsonArray.compactMap({Exercise1(data: $0)})
        
    }
    
    func saveExercise(){
        //  1 Получаем адрес папки
        guard var url = URL.getURL(location: .exerciseJSON, create: true) else {return}
        
        url.appendPathComponent("ExerciseJSON")
        url.appendPathExtension("json")
        
        
        // 2 Получаем даныне
        var dics = [String: Any]()
        dics["exercises"] = models.compactMap({$0.getDictinary()})
        
        // 3 Конвектируем в JSON и записываем
        do{
            let data = try JSONSerialization.data(withJSONObject: dics)
            try data.write(to: url)
        }
        catch {
            print("We have error while write a new exersise ")
        }
    }
    
    func addNewModel(new model: Exercise1) {
        models.append(model)
        saveExercise()
        updateModelsChanges()
    }
}

