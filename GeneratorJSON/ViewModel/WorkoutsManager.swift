//
//  WorkoutsViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 02.10.2021.
//

import SwiftUI
import Combine

final class WorkoutsManager: ObservableObject, ItemManager, JSONManager {

    

    typealias Item = Workout
    typealias CoreDataItem = Workout
    
    @Published var items: [Workout] = []
    var itemsPublished: Published<[Workout]> {_items}
    var itemsPublisher: Published<[Workout]>.Publisher {$items}
    
    @Published var selectedItem: Workout? = nil
    var selectedItemPublished: Published<Item?> { _selectedItem }
    var selectedItemPublisher: Published<Item?>.Publisher { $selectedItem }

    // MARK: - INIT
    init(){
        items = CoreDataFuncs.shared.getAll(entity: WorkoutEntity.self, model: Workout.self)
        selectedItem = items.first
    }

    // MARK: - EDIT WORKOUT
    func addSeriaId(for workout: Workout, seriaId: String){
        var changedWorkout = workout
        changedWorkout.seriaId = seriaId
        
     //   save(changedWorkout)
    }
    
    func deleteSeriaId(for workout: Workout){
        var changedWorkout = workout
        changedWorkout.seriaId = nil
        
      //  save(changedWorkout)
    }
}
