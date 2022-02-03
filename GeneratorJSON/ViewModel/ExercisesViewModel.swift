//
//  ExercisesViewModel.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 01.10.2021.
//

import SwiftUI
import Combine

final class ExercisesViewModel: ObservableObject, ItemManager, JSONManager {

    typealias Item = BasicExercise
    
    @Published var items: [BasicExercise]
    var itemsPublished: Published<[BasicExercise]>{ _items }
    var itemsPublisher: Published<[BasicExercise]>.Publisher {$items}
    
    @Published var selectedItem: BasicExercise? = nil
    var selectedItemPublished: Published<Item?> { _selectedItem }
    var selectedItemPublisher: Published<Item?>.Publisher { $selectedItem }

    // MARK: - INIT
    init() {
        self.items = CoreDataFuncs.shared.getAll(entity: ExerciseEntity.self, model: BasicExercise.self)
        self.selectedItem = items.first
    }
    
}
