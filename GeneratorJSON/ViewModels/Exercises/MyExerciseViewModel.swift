//
//  MyExerciseViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 27.06.2021.
//

import SwiftUI
import Combine


class MyExerciseViewModel:  ObservableObject{

    
    @Published var exercise: BasicExercise
    
    @Published var iconURL: URL?
    @Published var imageURL: URL?
    
    @Published var level: [Int] = []
    @Published var type: [Int] = []
    @Published var muscule: [Int] = []
    
    lazy var cancellables: [AnyCancellable] = []
    
    
    // MARK: - INITS
    init(exercise: BasicExercise){
        self.exercise = exercise
        
        addIcon()
        addImage()
        
        //Change level
        changeLevel()
        changeType()
        changeMuscle()
        
        //Init level
        level = exercise.level.compactMap({
            if let index = LevelType.allCases.firstIndex(of: $0),
               !self.level.contains(index) {
                return index
            } else {return nil}
        })
        //init type
        if let index = WorkType.allCases.firstIndex(of: exercise.type) {
            type = [index]
        }
        //init muscle
        muscule = exercise.muscle.compactMap({
            if let index = MuscleType.allCases.firstIndex(of: MuscleType(strValue: $0)),
               !self.muscule.contains(index) {
                return index
            } else {return nil}
        })
    }
    
    // MARK: - PUBLIC FUNCS
    func save(){
        //Информируем об изменнеии упражнения
        var userInfo = [AnyHashable: Any]()
        userInfo["exercise"] = exercise
        NotificationCenter.default.post(name: .saveExercise, object: nil, userInfo: userInfo)
    }
    
    
    // MARK: - PRIVATE FUNCS
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
                
                self.exercise.level = value.compactMap({
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
}

