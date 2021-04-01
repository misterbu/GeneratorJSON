//
//  WorkoutViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 25.03.2021.
//

import SwiftUI
import Combine

class WorkoutViewModel: ObservableObject {
    
    lazy var cancellables: [AnyCancellable] = []
    
    /// - TAG: Published
    @Published var workout: Workout
    
    @Published var iconURL: URL?
    @Published var imageURL: URL?
    @Published var level: [Int] = []
    @Published var type: [Int] = []
    @Published var sex: [Int] = []
    @Published var target: [Int] = []
    @Published var equipnemt: [Int] = []

    @Published var workoutCircles: [WorkoutCircleViewModel] = []
    
   
    /// - TAG: INITs
    init(_ workout: Workout){
        self.workout = workout
        
        addIcon()
        addImage()
        changeSex()
        changeType()
        changeLevel()
        changeTarget()
        changeEquipment()
        
        //init vars
        if let index = WorkType.allCases.firstIndex(of: workout.type) {
            type = [index]
        }
        if let index = SexType.allCases.firstIndex(of: workout.sex) {
            sex = [index]
        }
        target = workout.target.compactMap({
            if let index = TargetType.allCases.firstIndex(of: $0),
               !self.target.contains(index) {
                return index
            } else {
                return nil
            }
        })
        equipnemt = workout.equipment.compactMap({
            if let index = EquipmentType.allCases.firstIndex(of: $0),
               !self.equipnemt.contains(index) {
                return index
            } else {
                return nil
            }
        })
        
        level = workout.level.compactMap({
            if let index = LevelType.allCases.firstIndex(of: $0),
               !self.level.contains(index) {
                return index
            } else {return nil}
        })
        
        workoutCircles = workout.workoutCircles.map({WorkoutCircleViewModel($0)})
    }
    
    /// - TAG: Public funcs
    func createNewCircle(){
        workoutCircles.append(WorkoutCircleViewModel())
    }
    
    func getModelForSave() -> Workout? {
        // 1 Добавляем  циклы в Workout
        workout.workoutCircles = workoutCircles.compactMap({$0.getCircle(workout.type)})
        
        //2 Проверяем что основные данные добавлены иначе возвращаем nil
        if workout.workoutCircles.count > 0,
           workout.image != nil, workout.iconImage != nil,
           workout.name != "", workout.description != "",
           workout.level.count > 0 {
            return workout
        } else {
            return nil
        }
    }
    
    func remove(_ work: Workout){
        
    }
    
    
    /// - TAG: Private funcs
    private func addImage() {
        $imageURL
            .sink(receiveValue: {[weak self] url in
                guard let self = self else {return}
                if let url = url {
                    self.workout.image = NSImage(byReferencing: url)
                }
            }).store(in: &cancellables)
    }
    
    private func addIcon() {
        $iconURL
            .sink(receiveValue: {[weak self] url in
                guard let self = self else {return}
                if let url = url {
                    self.workout.iconImage = NSImage(byReferencing: url)
                }
            }).store(in: &cancellables)
    }
    
    private func changeLevel(){
        $level
            .sink(receiveValue: {[weak self] value in
                guard let self = self else {return}
                
                self.workout.level = value.compactMap({
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
                    self.workout.type = WorkType.allCases[value]
                }
            }).store(in: &cancellables)
    }
    
    private func changeSex(){
        $sex
            .sink(receiveValue: {[weak self] value in
                guard let self = self else {return}
                if let value = value.first {
                    self.workout.sex = SexType.allCases[value]
                }
            }).store(in: &cancellables)
    }
    
    private func changeTarget(){
        $target
            .sink(receiveValue: {[weak self] value in
                guard let self = self else {return}
                self.workout.target = value.compactMap({
                    guard $0 < TargetType.allCases.count else {return nil}
                    return TargetType.allCases[$0]
                })
                
            }).store(in: &cancellables)
    }
    
    private func changeEquipment(){
        $equipnemt
            .sink(receiveValue: {[weak self] value in
                guard let self = self else {return}
                self.workout.equipment = value.compactMap({
                    guard $0 < EquipmentType.allCases.count else {return nil}
                    return EquipmentType.allCases[$0]
                })
            }).store(in: &cancellables)
    }
}
