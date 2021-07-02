//
//  ExercisePropertiesViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 29.06.2021.
//

import SwiftUI

class ExercisePropertiesViewModel: ObservableObject{
    @Published var exercise: Exercise
    
    @Published var duration: Int = 0
    @Published var noTimeLimit: Bool = false
    
    init(exercise: Exercise){
        self.exercise = exercise
    }
    
    func save(){
        var userInfo = [AnyHashable: Any]()
        userInfo["exerise"] = exercise
        NotificationCenter.default.post(name: .changeExerciseInWorkout, object: nil, userInfo: userInfo)
    }
}
