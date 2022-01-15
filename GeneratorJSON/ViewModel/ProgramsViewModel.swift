//
//  ProgramViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 12.10.2021.
//

import SwiftUI
import Combine

class ProgramsViewModel: ObservableObject {
    private var cancellables: [AnyCancellable] = []
    
    var allPrograms: [WorkoutProgmar] = []
    @Published var visiblePrograms: [WorkoutProgmar] = []
    
    @Published var typeFilter: [WorkType] = []

    @Published var selectProgram: WorkoutProgmar = WorkoutProgmar()

    // MARK: - INIT
    init(){
        getAllPrograms()
    }
    
    // MARK: - GET/SET PROGRAMS
    private func getAllPrograms(){
        allPrograms = CoreDataFuncs.shared.getAll(entity: WorkoutsSeriaEntity.self, model: WorkoutProgmar.self)
        visiblePrograms.append(contentsOf: allPrograms)
        print("Program count = \(allPrograms.count)")
    }
    
    // MARK: - FILTER
    private func observeFilters(){
        $typeFilter
            .sink(receiveValue: {[weak self]  typeTypes in
                guard let self = self else {return}
                
                var programs = self.allPrograms
                
                //Фильтрация по ТИПУ
                if typeTypes.count > 0 {
                    programs = programs.filter({ program in
                        typeTypes.contains(where: {$0 == program.type})
                    })
                }
                
                DispatchQueue.main.async {
                    self.visiblePrograms = programs
                }
            }).store(in: &cancellables)
    }
    
    // MARK: - SAVE/ADD/DELETE EXERCISES
    func add(){
        print("ADD PROGRAM")
        let program = WorkoutProgmar()
        allPrograms.append(program)
        visiblePrograms.append(program)
        
        self.selectProgram = program
    }
    
    func delete(_ program: WorkoutProgmar){
        print("DELETE PROGRAM")
        //1. Убераем выбор
        selectProgram = WorkoutProgmar()
        
        //2. Удаляем из БД
        CoreDataFuncs.shared.delete(entity: WorkoutsSeriaEntity.self, model: program)
        
        //3. Удаляем из списков упр
        allPrograms.removeAll(where: {$0.id == program.id})
        visiblePrograms.removeAll(where: {$0.id == program.id})
    }
    
    func save(_ program: WorkoutProgmar){
        print("SAVE PROGRAM")
        //1. Сохраняем упражнение в БД
        CoreDataFuncs.shared.save(entity: WorkoutsSeriaEntity.self, model: program)
        
        //2. Обновляем массив упражнений
        self.allPrograms.removeAll(where: {$0.id == program.id})
        self.allPrograms.append(program)
        
        if let index = visiblePrograms.firstIndex(where: {$0.id == program.id}){
            visiblePrograms.remove(at: index)
            visiblePrograms.insert(program, at: index)
        }
    }
    
    // MARK: - GET IMAGE AND NAME OF PROGRAMS
    func getProgram(for id: String) -> WorkoutProgmar? {
        return nil
    }
    
    // MARK: - JSON
    func generateJSON(){
        //  1 Получаем адрес папки
        guard var url = URL.getURL(location: .seriaJSON, create: true) else {return}
        
        url.appendPathComponent("ProgramJSON")
        url.appendPathExtension("json")
        
        // 2 Получаем даныне
        var dics = [String: Any]()
        dics["programs"] = allPrograms.map({$0.getForJSON()})
        
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

