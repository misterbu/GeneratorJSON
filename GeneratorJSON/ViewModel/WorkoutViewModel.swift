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

    @Published var workoutCircles: [WorkoutCircle] = []
    
   
    
    init(_ workout: Workout){
        self.workout = workout
    }
    
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
                
                if let value = value.first {
                    self.workout.level = LevelType.allCases[value]
                }
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
                self.workout.target = self.target.compactMap({
                    guard $0 < TargetType.allCases.count else {return nil}
                    return TargetType.allCases[$0]
                })
                
            }).store(in: &cancellables)
    }
    
    private func changeEquipment(){
        $equipnemt
            .sink(receiveValue: {[weak self] value in
                guard let self = self else {return}
                self.workout.equipment = self.equipnemt.compactMap({
                    guard $0 < EquipmentType.allCases.count else {return nil}
                    return EquipmentType.allCases[$0]
                })
            }).store(in: &cancellables)
    }
}
