//
//  ExerciseSet.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 29.03.2021.
//

import Foundation
import CoreData

struct ExerciseSet: CoreDatable {
    var id: String = UUID().uuidString
    var order: Int = 0
    var reps: Int = 0
    var weight: Double = 0
    var isWarm: Bool = false
    
    
    /// - TAG: INITs
    init(){}
    
    init<S>(entity: S) where S : NSManagedObject {
        guard let entity = entity as? ExerciseSetEntity else {return}
        order = entity.order.int
        reps = entity.reps.int
        weight = entity.weight
        isWarm = entity.isWarm
    }
    
    func getEntity<S>() -> S where S : NSManagedObject {
        let entity = ExerciseSetEntity(context: PersistenceController.shared.container.viewContext)
        entity.order = order.int32
        entity.reps = reps.int32
        entity.weight = weight
        entity.isWarm = isWarm
        
        return entity as! S
    }
}
