//
//  StrenghtExercise.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import SwiftUI

struct StrenghtExercise: Exercise {
   
    var id: String = UUID().uuidString
    var basic: BasicExercise = BasicExercise()
    var orderAdd: Int = 0
    
    /// - TAG: Ourself vars
    var sets: [ExerciseSet] = []
    var restDuration: Int = 0
    var voiceComment: [String] = []
    
    var noLimitReps: Bool = false
    var ownWeight: Bool = false
    
    var entityType: NSManagedObject.Type {StrenghtExerciseEntity.self}
    
    // MARK: - INIT
    init(){}
    
    init(_ exercise: BasicExercise, orderAdd: Int?){
        self.basic = exercise
        self.orderAdd = orderAdd ?? 0
        self.sets = [ExerciseSet(order: 0)]
    }
    

    // MARK: - FUNCS
    mutating func setProperied(values: [String : Any]) {
        if let restValue = values["restDuration"] as? Int {
            self.restDuration = restValue
        }
        
    }
}


// MARK: - COREDATABLE
extension StrenghtExercise: CoreDatable {
   
    init<S>(entity: S) where S : NSManagedObject {
        guard let entity = entity as? StrenghtExerciseEntity else {return}
        

        self.id = entity.id ?? UUID().uuidString
        self.orderAdd = entity.order.int
        self.noLimitReps = entity.noLimitReps
        self.ownWeight = entity.ownWeight
        
        //Voice comment
        if let strVoiseComment = entity.voiceComment {
            self.voiceComment = strVoiseComment
                .components(separatedBy: ";")
                .filter({$0 != ""})
        }
        
        if let basicEntity = entity.basic {
            basic = BasicExercise(entity: basicEntity)
        }
        
        //Специальные данные силовой тренировки
        self.restDuration = entity.restDuration.int
        if let setsEntities = entity.exerciseSets as? Set<ExerciseSetEntity> {
            self.sets = setsEntities
                .compactMap({ExerciseSet(entity: $0)})
                .sorted(by: {$0.order < $1.order})
        }
        
        //Видео пока оставить в покое
    }
    
    func getEntity<S>() -> S where S : NSManagedObject {
        let entity = CoreDataFuncs.shared.getEntity(entity: StrenghtExerciseEntity.self, id: id) ?? StrenghtExerciseEntity(context: PersistenceController.shared.container.viewContext)
        
        entity.id = id
        entity.order = orderAdd.int32
        entity.restDuration = restDuration.int32
        entity.noLimitReps = noLimitReps
        entity.ownWeight = ownWeight
        entity.basic = basic.getEntity()
        
        //Voice comment
        entity.voiceComment = voiceComment.joined(separator: ";")
        
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
}

// MARK: - JSONBLE
extension StrenghtExercise{
    func getForJSON() -> [String : Any] {
        let dict: [String : Any] = [
            "id" : id,
            "basicId" : basic.id,
            "orderAdd" : orderAdd,
            "sets": sets.map({$0.getForJSON()}),
            "restDuration" : restDuration,
            "voiceComment" : voiceComment.joined(separator: ";"),
            "noRepsLimit" : noLimitReps,
            "ownWeight" : ownWeight
        ]
        
        return dict
    }
}


// MARK: - EQUTABLE
extension StrenghtExercise:Equatable {
    static func == (lhs: StrenghtExercise, rhs: StrenghtExercise) -> Bool {
        if lhs.ownWeight == rhs.ownWeight,
           lhs.noLimitReps == rhs.noLimitReps,
           lhs.id == rhs.id {
            return true
        } else {return false}

    }
}
