//
//  SpecialProgram.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 12.10.2021.
//

import Foundation
import CoreData

struct SpecialProgram {
    var id: String = UUID().uuidString
    var name = ""
    var description = ""
    var items: [Reviewble] = []
    
    var entityType: NSManagedObject.Type {SpecialEntity.self}
    
    init(){}
    
}


extension SpecialProgram: CoreDatable {
    init<S>(entity: S) where S : NSManagedObject {
        guard let entity = entity as? SpecialEntity else {return}
        self.id = entity.id ?? UUID().uuidString
        self.name = entity.name ?? ""
        self.description = entity.descr ?? ""
        
        if let workoutsEntities = entity.workouts as? Set<WorkoutEntity> {
            self.items = workoutsEntities.map({Workout(entity: $0)})
        }
        
        if let programsEntities = entity.programs as? Set<WorkoutsSeriaEntity> {
            self.items = programsEntities.map({WorkoutProgmar(entity: $0)})
        }
    }
    
    func getEntity<S>() -> S where S : NSManagedObject {
        let entity = CoreDataFuncs.shared.getEntity(entity: SpecialEntity.self, id: id) ??
                SpecialEntity(context: PersistenceController.shared.container.viewContext)
        
        entity.id = id
        entity.name = name
        entity.descr = description
        
        var workouts = Set<WorkoutEntity>()
        var programs = Set<WorkoutsSeriaEntity>()
        items.forEach({
            if let workout = $0 as? Workout {
                workouts.insert(workout.getEntity())
            } else if let program = $0 as? WorkoutProgmar {
                programs.insert(program.getEntity())
            }
        })
        entity.workouts = workouts as NSSet
        entity.programs = programs as NSSet
        
        return entity as! S
    }
}
