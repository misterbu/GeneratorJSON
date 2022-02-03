//
//  ProgramViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 12.10.2021.
//

import SwiftUI
import Combine
import SwiftyJSON

final class ProgramsManager: ObservableObject, ItemManager, JSONManager {
    
    typealias Item = WorkoutProgmar
    
    @Published var items: [WorkoutProgmar]
    var itemsPublished: Published<[WorkoutProgmar]> { _items }
    var itemsPublisher: Published<[WorkoutProgmar]>.Publisher { $items }
    
    @Published var selectedItem: WorkoutProgmar? = nil
    var selectedItemPublished: Published<Item?> { _selectedItem }
    var selectedItemPublisher: Published<Item?>.Publisher { $selectedItem }
   
    
    // MARK: - INIT
    init(){
        items = CoreDataFuncs.shared.getAll(entity: WorkoutsSeriaEntity.self, model: WorkoutProgmar.self)
        selectedItem = items.first
    }

    
    // MARK: - GET IMAGE AND NAME OF PROGRAMS
    func getProgram(for id: String) -> WorkoutProgmar? {
        return nil
    }
    
}
