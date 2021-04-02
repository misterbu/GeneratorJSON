//
//  WorkoutSeriaItemViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 01.04.2021.
//

import SwiftUI

class WorkoutSeriaItemViewModel: ObservableObject {
    @Published var day: String 
    @Published var workoutVM: WorkoutViewModel
    
    init(_ workout: WorkoutViewModel){
        self.workoutVM = workout
        self.day = "0"
    }
    
    init(_ item: WorkoutSeriaItem){
        self.workoutVM = WorkoutViewModel(item.workout)
        self.day = String(item.day)
    }
    
    func getItem(_ seriaId: String) -> WorkoutSeriaItem? {
        guard let day = Int(day), day > 0 else {return nil}
        //1 Сохраняем в тренировке id серии
        workoutVM.changeSeriaId(id: seriaId)
        
        //2 Передаем item
        return WorkoutSeriaItem(workout: workoutVM.workout, day: day)
    }
}
