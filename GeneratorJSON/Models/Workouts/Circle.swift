//
//  Circle.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 25.03.2021.
//

import Foundation
import CoreData

struct WorkoutCircle: CoreDatable {
    var id: String = UUID().uuidString
    var orderAdd: Int = 0
    var name: String = ""
    var canGetOff: Bool = false
    var exercises: [Exercise] = []
    
    
    /// - TAG: INITs
    init(order: Int){
        self.orderAdd = order
    }
    
    init<S>(entity: S) where S : NSManagedObject {
        guard let entity = entity as? CircleEntity else {return}
        
        self.id = entity.id ?? UUID().uuidString
        self.orderAdd = Int(entity.orderAdd)
        self.name = entity.name ?? ""
        self.canGetOff = entity.canGetOff
        
        //Получаем все типы тренировок из CD и сортируем их в нужном порядке
        if let intervalsEntities = entity.intervalExercises as? Set<IntervalExerciseEntity>  {
            intervalsEntities.forEach({exercises.append(IntervalExercise(entity: $0))})
        }
        if let strengthEntities = entity.strenghtExercises as? Set<StrenghtExerciseEntity>{
            strengthEntities.forEach({exercises.append(StrenghtExercise(entity: $0))})
        }
        exercises.sort(by: {$0.orderAdd < $1.orderAdd})
        
        print("WorkoutCircle: Init circle id \(id), exercises \(exercises.count)")
    }
    
    func getEntity<S>() -> S where S : NSManagedObject {
        let entity = CircleEntity(context: PersistenceController.shared.container.viewContext)
        entity.id = id
        entity.orderAdd = orderAdd.int32
        entity.name = name
        entity.canGetOff = canGetOff
        
        //Сохраняем упражнения
        var intervalsEntities = Set<IntervalExerciseEntity>()
        var strenghtEntities = Set<StrenghtExerciseEntity>()
        exercises.forEach({
            switch $0.basic.type {
            case .combine:
                //Доделать для комбинированно
            print("Here will be a combine")
            case .hiit:
                if let model = $0 as? IntervalExercise {
                    intervalsEntities.insert(model.getEntity())
                }
            case .strenght:
                if let model = $0 as? StrenghtExercise {
                    strenghtEntities.insert(model.getEntity())
                }
            case .stretching:
                //Доделать для растяжки
                print("Here will be a stretching")
            }
        })
        entity.intervalExercises = intervalsEntities as NSSet
        entity.strenghtExercises = strenghtEntities as NSSet
        
        print("WorkoutCircle: Save circle \(id),  Interval exercises count \(entity.intervalExercises?.count)")
        print("WorkoutCircle: Save circle \(id),  Strenght exercises count \(entity.strenghtExercises?.count)")
        
        return entity as! S
    }
    
    
    /// - TAG: Private funcs
    private func getExercise(_ id: String) -> Exercise? {
        print("Circle: Get exercise \(id)")
        if let interval = CoreDataFuncs.shared.get(entity: IntervalExerciseEntity.self, model: IntervalExercise.self, id: id) {
            return interval
        } else if let strenght = CoreDataFuncs.shared.get(entity: StrenghtExerciseEntity.self, model: StrenghtExercise.self, id: id) {
            return strenght
        } else {
            return nil
        }
    }
}
