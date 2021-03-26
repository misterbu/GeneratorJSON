//
//  ExerciseViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 24.03.2021.
//

import SwiftUI
import Combine


class ExerciseViewModel: ObservableObject {
    
    lazy var cancellables: [AnyCancellable] = []
    
    /// - TAG: Published
    @Published var exercise: Exercise
    @Published var iconURL: URL?
    @Published var imageURL: URL?
    @Published var level: [Int] = []
    @Published var type: [Int] = []
    @Published var muscule: [Int] = []
    @Published var duration: String = ""
    
    
    var canUse: Bool {
        if exercise.name != "",
           exercise.description != "",
           exercise.image != nil,
           exercise.iconImage != nil {
            return true
        } else {
            return false
        }
    }
    
    init(_ exersice: Exercise) {
        self.exercise = exersice
        

        //Subscribe to change Image
        addIcon()
        addImage()
        
        //Change level
        changeLevel()
        
        //changeType
        changeType()
        
        //change muscle
        changeMuscle()
        
        //Init level
        if let index = LevelType.allCases.firstIndex(of: exercise.level) {
            level = [index]
        }
        
        //init type
        if let index = WorkType.allCases.firstIndex(of: exersice.type) {
            type = [index]
        }
        
        //init muscle
        print("Muscle \(exersice.muscle)")
        muscule = exersice.muscle.compactMap({
            if let index = MuscleType.allCases.firstIndex(of: MuscleType(strValue: $0)),
               !self.muscule.contains(index) {
                return index
            } else {return nil}
        })
        
        //Set specific values
        if let interval = exersice as? IntervalExercise {
            print("duration = \(interval.duration)")
            duration = String(interval.duration)
        }
    }
    
    
    private func addImage() {
        $imageURL
            .sink(receiveValue: {[weak self] url in
                guard let self = self else {return}
                if let url = url {
                    self.exercise.image = NSImage(byReferencing: url)
                }
            }).store(in: &cancellables)
    }
    
    private func addIcon() {
        $iconURL
            .sink(receiveValue: {[weak self] url in
                guard let self = self else {return}
                if let url = url {
                    self.exercise.iconImage = NSImage(byReferencing: url)
                }
            }).store(in: &cancellables)
    }
    
    private func changeLevel(){
        $level
            .sink(receiveValue: {[weak self] value in
                guard let self = self else {return}
                
                if let value = value.first {
                    self.exercise.level = LevelType.allCases[value]
                }
            }).store(in: &cancellables)
        
        
    }
    
    private func changeType(){
        $type
            .sink(receiveValue: {[weak self] value in
                guard let self = self else {return}
                if let value = value.first {
                    self.exercise.type = WorkType.allCases[value]
                }
            }).store(in: &cancellables)
    }
    
    private func changeMuscle(){
        $muscule
            .sink(receiveValue: {[weak self] value in
                guard let self = self else {return}
                
                self.exercise.muscle = value.compactMap({
                    guard $0 < MuscleType.allCases.count else {return nil}
                    return MuscleType.allCases[$0].str
                })
            }).store(in: &cancellables)
    }
    
    func changeDuration(value: String){
        print("change duration1 \(value)")
        if let durationInt = Int(value) {
            var values = [String: Any]()
            values["duration"] = durationInt
            print("change duration2 \(durationInt)")
            //Устанавливаем особенные значения через функцию
            self.exercise.setProperied(values: values)
        }
        
    }
    
    func save(){
        if let interval = exercise as? IntervalExercise {
            CoreDataFuncs.shared.save(entity: IntervalExerciseEntity.self, model: interval)
        } else if let strenght = exercise as? StrenghtExercise{
            //Сиовая
        }
        //Добавить про тренировку с растяжкой
    }
}
