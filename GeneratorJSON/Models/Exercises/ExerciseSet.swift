//
//  ExerciseSet.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 29.03.2021.
//

import Foundation
import CoreData

struct ExerciseSet: Equatable {
    var id: String = UUID().uuidString
    var order: Int = 0
    var reps: Int = 0
    var weight: Double = 0
    var isWarm: Bool = false
    var voiceComment:[String] = []
    
    var entityType: NSManagedObject.Type {ExerciseSetEntity.self}
    
    // MARK: - INIT
    init(order: Int){
        self.order = order
        self.reps = 10
        self.weight = 10
    }
}

// MARK: - COREDATA
extension ExerciseSet: CoreDatable{
    init<S>(entity: S) where S : NSManagedObject {
        guard let entity = entity as? ExerciseSetEntity else {return}
        id = entity.id ?? UUID().uuidString
        order = entity.order.int
        reps = entity.reps.int
        weight = entity.weight
        isWarm = entity.isWarm
        
        //Voice comment
        if let strVoiseComment = entity.voiceComment {
            self.voiceComment = strVoiseComment
                .components(separatedBy: ";")
                .filter({$0 != ""})
        }
    }
    
    func getEntity<S>() -> S where S : NSManagedObject {
        let entity = CoreDataFuncs.shared.getEntity(entity: ExerciseSetEntity.self, id: id) ?? ExerciseSetEntity(context: PersistenceController.shared.container.viewContext)
        entity.id = id
        entity.order = order.int32
        entity.reps = reps.int32
        entity.weight = weight
        entity.isWarm = isWarm
        
        //Voice comment
        entity.voiceComment = voiceComment.joined(separator: ";")
        
        return entity as! S
    }
}

extension ExerciseSet{
    func getForJSON() -> [String : Any] {
        let dict: [String : Any] = [
            "id" : id,
            "orderAdd" : order,
            "reps": reps,
            "weight": weight,
            "isWarmUp": isWarm,
            "voiceComment" : voiceComment.joined(separator: ";")
        ]
        
        return dict
    }
}
