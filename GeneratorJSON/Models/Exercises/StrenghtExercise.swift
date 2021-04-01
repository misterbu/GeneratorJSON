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
    
    init(_ base: BasicExercise){
        self.basic = base
    }
    
    init<S>(entity: S) where S : NSManagedObject {
        guard let entity = entity as? StrenghtExerciseEntity,
              let basicExerciseId = entity.exerciseId,
                 let model = CoreDataFuncs.shared.get(entity: ExerciseEntity.self, model: BasicExercise.self, id: basicExerciseId) else {return}
        

        self.id = entity.id ?? UUID().uuidString
        self.basic = model
        self.voiceComment = entity.voiceComment
        
        
        //Специальные данные силовой тренировки
        self.restDuration = entity.restDuration.int
        if let setsEntities = entity.exerciseSets as? Set<ExerciseSetEntity> {
            self.sets = setsEntities
                .compactMap({ExerciseSet(entity: $0)})
                .sorted(by: {$0.order > $1.order})
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
        entity.exerciseId = basic.id
        entity.voiceComment = voiceComment
        entity.restDuration = restDuration.int32
        
        var order = 0
        var setsEntities = Set<ExerciseSetEntity>()
        sets.forEach({
            if let setEntity = $0.getEntity() as? ExerciseSetEntity {
                setEntity.order = order.int32
                setsEntities.insert(setEntity)
                order += 1
            }
        })
        
        print("StrenghtExercise: Save exercise \(id)")
        
        return entity as! S
    }

}
