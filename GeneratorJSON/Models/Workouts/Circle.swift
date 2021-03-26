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
    
    init<S>(entity: S) where S : NSManagedObject {
        guard let entity = entity as? CircleEntity else {return}
        
        self.id = entity.id ?? UUID().uuidString
        self.orderAdd = Int(entity.orderAdd)
        self.name = entity.name ?? ""
        self.canGetOff = entity.canGetOff
        
        //Получаем все типы тренировок из CD и сортируем их в нужном порядке
        if let intervalsEntities = entity.intervalExercises as? Set<IntervalExerciseEntity> {
            exercises.append(contentsOf: intervalsEntities.map({IntervalExercise(entity: $0)}))
        }
        if let strenghtEntities = entity.strenghtExercises as? Set<StrenghtExerciseEntity> {
            exercises.append(contentsOf: strenghtEntities.map({StrenghtExercise(entity: $0)}))
        }
        exercises.sort(by: {$0.orderAdd > $1.orderAdd})
    }
    
    func getEntity<S>() -> S where S : NSManagedObject {
        let entity = CircleEntity(context: PersistenceController.shared.container.viewContext)
        entity.id = id
        entity.orderAdd = orderAdd.int32
        entity.name = name
        entity.canGetOff = canGetOff
        
        //Сохраняем упражнения
        //Записываем порядок их расположения, увеличивая order
        var order = 0
        var intervalEntities = Set<IntervalExerciseEntity>()
        var strenghtEntities = Set<StrenghtExerciseEntity>()
        exercises.forEach({
            if var inteval = $0 as? IntervalExercise {
                inteval.orderAdd = order
                intervalEntities.insert(inteval.getEntity())
            } else if var strenght = $0 as? StrenghtExercise {
                strenght.orderAdd = order
                strenghtEntities.insert(strenght.getEntity())
            }
            order += 1
        })
        
        return entity as! S
    }
}
