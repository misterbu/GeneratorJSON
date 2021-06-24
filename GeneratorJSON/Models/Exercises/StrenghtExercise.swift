//
//  StrenghtExercise.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import SwiftUI

struct StrenghtExercise: Exercise, CoreDatable {
   
    
    /// - TAG: Protocol's vars
    var id: String = UUID().uuidString
    var basic: BasicExercise = BasicExercise()
    var orderAdd: Int = 0
    
    /// - TAG: Ourself vars
    var sets: [ExerciseSet] = []
    var restDuration: Int = 0
    var voiceComment: String?
    
    /// - TAG: INITS
    
    init(_ base: BasicExercise, order: Int){
        self.basic = base
        self.orderAdd = order
    }
    
    init<S>(entity: S) where S : NSManagedObject {
        guard let entity = entity as? StrenghtExerciseEntity,
              let basicExerciseId = entity.exerciseId,
                 let model = CoreDataFuncs.shared.get(entity: ExerciseEntity.self, model: BasicExercise.self, id: basicExerciseId) else {return}
        

        self.id = entity.id ?? UUID().uuidString
        self.orderAdd = entity.order.int
        self.basic = model
        self.voiceComment = entity.voiceComment
          
        //Специальные данные силовой тренировки
        self.restDuration = entity.restDuration.int
        if let setsEntities = entity.exerciseSets as? Set<ExerciseSetEntity> {
            self.sets = setsEntities
                .compactMap({ExerciseSet(entity: $0)})
                .sorted(by: {$0.order < $1.order})
        }
        
        //Видео пока оставить в покое
    }
    
    mutating func setProperied(values: [String : Any]) {
        if let restValue = values["restDuration"] as? Int {
            self.restDuration = restValue
        }
        
    }
    
    func getEntity<S>() -> S where S : NSManagedObject {
        let entity = StrenghtExerciseEntity(context: PersistenceController.shared.container.viewContext)
        
        entity.id = id
        entity.order = orderAdd.int32
        entity.exerciseId = basic.id
        entity.voiceComment = voiceComment
        entity.restDuration = restDuration.int32
        
        var setsEntities = Set<ExerciseSetEntity>()
        sets.forEach({
            if let setEntity = $0.getEntity() as? ExerciseSetEntity {
                setsEntities.insert(setEntity)
            }
        })
        entity.exerciseSets = setsEntities as NSSet
        
        print("StrenghtExercise: Save exercise \(id)")
        
        return entity as! S
    }
    
    func getForJSON() -> [String : Any] {
        let dict: [String : Any] = [
            "id" : id,
            "basicId" : basic.id,
            "orderAdd" : orderAdd,
            "sets": sets.map({$0.getForJSON()}),
            "restDuration" : restDuration,
            "voiceComment" : voiceComment ?? ""
        ]
        
        return dict
    }

}
