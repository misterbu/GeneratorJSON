//
//  MyWorkoutViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 28.06.2021.
//

import SwiftUI
import Combine

class MyWorkoutViewModel: ObservableObject{
    @Published var workout: Workout
    
    @Published var iconURL: URL?
    @Published var imageURL: URL?
    @Published var level: [Int] = []
    @Published var type: [Int] = []
    @Published var sex: [Int] = []
    @Published var target: [Int] = []
    @Published var equipnemt: [Int] = []
    
    @Published var selectedExercise: Exercise? = nil
    
    lazy var cancellables: [AnyCancellable] = []
    
    init(workout: Workout){
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
    }
    
    // MARK: - PUBLIC FUNCS
    func addCircle(){
        workout.workoutCircles.append(WorkoutCircle(order: workout.workoutCircles.count))
    }
    
    func deleteCircle(index: Int) {
        workout.workoutCircles.remove(at: index)
    }
    
    func save(){
        var userInfo = [AnyHashable: Any]()
        userInfo["workout"] = workout
        NotificationCenter.default.post(name: .saveWorkout, object: nil, userInfo: userInfo)
    }
    
    
    // MARK: - PRIVATE FUNCS
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
