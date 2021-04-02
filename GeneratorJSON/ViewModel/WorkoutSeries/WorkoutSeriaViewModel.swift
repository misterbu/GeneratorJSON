//
//  WorkoutSeriaViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 01.04.2021.
//

import SwiftUI
import Combine

class WorkoutSeriaViewModel: Identifiable, ObservableObject {
    
    lazy var cancellables: [AnyCancellable] = []
    
    @Published var seria: WorkoutSeria
    @Published var items: [WorkoutSeriaItemViewModel] = []
    
    @Published var iconURL: URL?
    @Published var imageURL: URL?
    @Published var level: [Int] = []
    @Published var type: [Int] = []
    @Published var sex: [Int] = []
    @Published var target: [Int] = []
    @Published var equipnemt: [Int] = []
    
    @Published var showWorkoutCatalog: Bool = false
    
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
        
        items = seria.workouts.map({WorkoutSeriaItemViewModel($0)})
    }
    
    
    /// - TAG: Public funcs
    func showCatalog(){
        showWorkoutCatalog.toggle()
    }
    
    func closeCatalog(){
        showWorkoutCatalog.toggle()
    }
    
    func chooseWorkout(_ work: WorkoutViewModel){
        items.append(WorkoutSeriaItemViewModel(work))
    }
    
    func save(){
        //1 Добавляем items в seria
        seria.workouts = items.compactMap({$0.getItem(seria.id)})
        
        //2 Сохраняем в БД
        CoreDataFuncs.shared.save(entity: WorkoutsSeriaEntity.self, model: seria)

        //3 Уведомляем об добавляении новой серии
        NotificationCenter.default.post(name: .saveNewSeria, object: nil, userInfo: nil)
    }
    
    /// - TAG: Private funcs
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
