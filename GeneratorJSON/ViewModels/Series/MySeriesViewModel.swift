//
//  MySeriesViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 30.06.2021.
//

import SwiftUI
import Combine

class MySeriesViewModel: ObservableObject {
    @Published  var series: [WorkoutSeria] = []
    
    lazy var cancellables: [AnyCancellable] = []
    
    init(){
        self.series = CoreDataFuncs.shared.getAll(entity: WorkoutsSeriaEntity.self, model: WorkoutSeria.self)
        
        observeSaveSeria()
    }
    
    func create(){
        let seria = WorkoutSeria()
        series.append(seria)
        saveWorkout(seria)
        
        
    }
    
    func delete(_ seria: WorkoutSeria){
        //Удаляем серию
        series.removeAll(where: {$0.id == seria.id})
        
        //Удаляем в ид этой серии в тренировках, которые были в серии
        seria.workouts.forEach({
            var workout = $0
            workout.seriaId = nil
            CoreDataFuncs.shared.save(entity: WorkoutEntity.self, model: workout)
        })
        
        //Удаляем из БД
        removeSeria(seria)
    }
    
    func generateJSON(){
        //  1 Получаем адрес папки
        guard var url = URL.getURL(location: .seriaJSON, create: true) else {return}
        
        url.appendPathComponent("ProgramJSON")
        url.appendPathExtension("json")
        
        // 2 Получаем даныне
        var dics = [String: Any]()
        dics["programs"] = series.map({$0.getForJSON()})
        
        // 3 Конвектируем в JSON и записываем
        do{
            let data = try JSONSerialization.data(withJSONObject: dics)
            try data.write(to: url)
        }
        catch {
            print("We have error while write a new program ")
        }
    }
    
    
    
    // MARK: - PRIVATE FUNCS
    private func saveWorkout(_ seria: WorkoutSeria){
        CoreDataFuncs.shared.save(entity: WorkoutsSeriaEntity.self, model: seria)
    }
    
    private func removeSeria(_ seria: WorkoutSeria){
        CoreDataFuncs.shared.delete(entity: WorkoutsSeriaEntity.self, model: seria)
    }
    
    private func observeSaveSeria(){
        NotificationCenter.default.publisher(for: .saveSeria)
            .sink(receiveValue: {[weak self] value in
                guard let self = self else {return}
                
                if let seria = value.userInfo?["seria"] as? WorkoutSeria {
                    self.series.removeAll(where: {$0.id == seria.id})
                    self.series.append(seria)
                    
                    self.saveWorkout(seria)
                }
            }).store(in: &cancellables)
    }
}
