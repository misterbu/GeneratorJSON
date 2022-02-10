//
//  Circle.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 25.03.2021.
//

import Foundation
import CoreData

struct WorkoutCircle: Identifiable, CoreDatable {

    var id: String = UUID().uuidString
    var orderAdd: Int = 0
    var name: String = ""
    var canGetOff: Bool = false
 //   var type: CircleType = .main
    var exercises: [Exercise] = []
    
    var entityType: NSManagedObject.Type {CircleEntity.self}
    
    // MARK: -  INIT
    init(order: Int){
        self.orderAdd = order
        self.name = "Circle " + "\(order + 1)"
    }


    // MARK: - PRIVATE FUNCS
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


// MARK: - COREDATABLE
extension WorkoutCircle {
    init<S>(entity: S) where S : NSManagedObject {
        guard let entity = entity as? CircleEntity else {return}
        
        self.id = entity.id ?? UUID().uuidString
        self.orderAdd = Int(entity.orderAdd)
        self.name = entity.name ?? ""
        self.canGetOff = entity.canGetOff
       // self.type = CircleType(rawValue: entity.type.int) ?? .main
        
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
        let entity = CoreDataFuncs.shared.getEntity(entity: CircleEntity.self, id: id) ??  CircleEntity(context: PersistenceController.shared.container.viewContext)
        entity.id = id
        entity.orderAdd = orderAdd.int32
        entity.name = name
        entity.canGetOff = canGetOff
      //  entity.type = type.rawValue.int32
        
        //Сохраняем упражнения
        var intervalsEntities = Set<IntervalExerciseEntity>()
        var strenghtEntities = Set<StrenghtExerciseEntity>()
        exercises.forEach({
            switch $0.basic.type {
            case .hiit:
                if let model = $0 as? IntervalExercise {
                    intervalsEntities.insert(model.getEntity())
                }
            case .strenght:
                if let model = $0 as? StrenghtExercise {
                    strenghtEntities.insert(model.getEntity())
                }}
        })
        entity.intervalExercises = intervalsEntities as NSSet
        entity.strenghtExercises = strenghtEntities as NSSet
        
        return entity as! S
    }
}

// MARK: - JSONBLE
extension WorkoutCircle {
    func getForJSON() -> [String: Any] {
        let dict: [String: Any] = [
            "id" : id,
            "orderAdd": orderAdd,
            "name" : name,
            "canGetOff" : canGetOff,
            "exercises" : exercises.map({$0.getForJSON()}),
       //     "type": type.rawValue
        ]
        
        return dict
    }
}

// MARK: - EQUTABLE
extension WorkoutCircle: Equatable {
    static func == (lhs: WorkoutCircle, rhs: WorkoutCircle) -> Bool {
        guard lhs.name == rhs.name,
           lhs.canGetOff == rhs.canGetOff,
          //    lhs.type.str == rhs.type.str,
              lhs.exercises.count == rhs.exercises.count else {return false}
        
        return true
    }
}

extension WorkoutCircle {
    static var sample: WorkoutCircle {
        var value = WorkoutCircle(order: 0)
        value.name = "Circle 1" 
        value.exercises.append(StrenghtExercise.sample)
        value.exercises.append(StrenghtExercise.sample)
        return value
    }
}
