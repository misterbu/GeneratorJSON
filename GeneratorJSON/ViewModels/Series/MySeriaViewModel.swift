//
//  MySeriaViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 30.06.2021.
//

import SwiftUI
import Combine

class MySeriaViewModel: ObservableObject {
    @Published var seria: WorkoutSeria
    
    @Published var iconURL: URL?
    @Published var imageURL: URL?
    @Published var level: [Int] = []
    @Published var type: [Int] = []
    @Published var sex: [Int] = []
    @Published var target: [Int] = []
    @Published var equipnemt: [Int] = []
    
    lazy var cancellables: [AnyCancellable] = []
    
    init(_ seria: WorkoutSeria){
        self.seria = seria
        
        addIcon()
        addImage()
        changeSex()
        changeType()
        changeLevel()
        changeTarget()
        changeEquipment()
        
        //init vars
        if let index = WorkType.allCases.firstIndex(of: seria.type) {
            type = [index]
        }
        if let index = SexType.allCases.firstIndex(of: seria.sex) {
            sex = [index]
        }
        target = seria.target.compactMap({
            if let index = TargetType.allCases.firstIndex(of: $0),
               !self.target.contains(index) {
                return index
            } else {
                return nil
            }
        })
        equipnemt = seria.equipment.compactMap({
            if let index = EquipmentType.allCases.firstIndex(of: $0),
               !self.equipnemt.contains(index) {
                return index
            } else {
                return nil
            }
        })
        level = seria.level.compactMap({
            if let index = LevelType.allCases.firstIndex(of: $0),
               !self.level.contains(index) {
                return index
            } else {return nil}
        })
    }
    
    func save(){
        var userInfo = [AnyHashable: Any]()
        
        userInfo["seria"] = seria
        
        NotificationCenter.default.post(name: .saveSeria, object: nil, userInfo: userInfo)
    }
    
    func delete(workout: Workout){
        //Удаляем тренировку из серии тренировок
        seria.workouts.removeAll(where: {$0.id == workout.id})
        
        //Удаляем ид серии тренировок из тренировки
        var workout1 = workout
        workout1.seriaId = nil
        CoreDataFuncs.shared.save(entity: WorkoutEntity.self, model: workout1)
        
    }
    
    // MARK: - PRIVATE FUNCS
    private func addImage() {
        $imageURL
            .sink(receiveValue: {[weak self] url in
                guard let self = self else {return}
                if let url = url {
                    self.seria.image = NSImage(byReferencing: url)
                }
            }).store(in: &cancellables)
    }
    
    private func addIcon() {
        $iconURL
            .sink(receiveValue: {[weak self] url in
                guard let self = self else {return}
                if let url = url {
                    self.seria.iconImage = NSImage(byReferencing: url)
                }
            }).store(in: &cancellables)
    }
    
    private func changeLevel(){
        $level
            .sink(receiveValue: {[weak self] value in
                guard let self = self else {return}
                
                self.seria.level = value.compactMap({
                    guard $0 < LevelType.allCases.count else {return nil}
                    return LevelType.allCases[$0]
                })
            }).store(in: &cancellables)
    }
    
    private func changeType(){
        $type
            .sink(receiveValue: {[weak self] value in
                guard let self = self else {return}
                if let value = value.first {
                    self.seria.type = WorkType.allCases[value]
                }
            }).store(in: &cancellables)
    }
    
    private func changeSex(){
        $sex
            .sink(receiveValue: {[weak self] value in
                guard let self = self else {return}
                if let value = value.first {
                    self.seria.sex = SexType.allCases[value]
                }
            }).store(in: &cancellables)
    }
    
    private func changeTarget(){
        $target
            .sink(receiveValue: {[weak self] value in
                guard let self = self else {return}
                self.seria.target = value.compactMap({
                    guard $0 < TargetType.allCases.count else {return nil}
                    return TargetType.allCases[$0]
                })
                
            }).store(in: &cancellables)
    }
    
    private func changeEquipment(){
        $equipnemt
            .sink(receiveValue: {[weak self] value in
                guard let self = self else {return}
                self.seria.equipment = value.compactMap({
                    guard $0 < EquipmentType.allCases.count else {return nil}
                    return EquipmentType.allCases[$0]
                })
            }).store(in: &cancellables)
    }
}
