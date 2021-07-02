//
//  IntervalExercise.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import SwiftUI


struct IntervalExercise: Exercise, CoreDatable {
  
    /// - TAG: Protocol's vars
    var id: String = UUID().uuidString
    var basic: BasicExercise = BasicExercise()
    var orderAdd: Int = 0

    var duration: Int = 0
    var restDuration: Int = 0
    var voiceComment: String?
    
    var noTimeLimit: Bool = false
    
     
    
    /// - TAG: INITS
    init(){}
    
    init(_ base: BasicExercise, order: Int){
        self.basic = base
        self.orderAdd = order
    }
    
    init<S>(entity: S) where S : NSManagedObject {
        guard let entity = entity as? IntervalExerciseEntity else {return}
        
        self.id = entity.id ?? UUID().uuidString
        self.orderAdd = entity.order.int
        self.duration = entity.duration.int
        self.restDuration = entity.restDuration.int
        self.noTimeLimit =  entity.noTimeLimit
        self.voiceComment = entity.voiceComment
        
        if let basicEntity = entity.basic {
            basic = BasicExercise(entity: basicEntity)
        }
        
        print("IntervalExercise: Init exercise \(id)")
        
        //Видео пока оставить в покое
    }
    
    
    mutating func setProperied(values: [String : Any]) {
        if let durationValue = values["duration"] as? Int {
            self.duration = durationValue
        }
        if let restValue = values["restDuration"] as? Int {
            self.restDuration = restValue
        }
    }
    
    func getEntity<S>() -> S where S : NSManagedObject {
        let entity = IntervalExerciseEntity(context: PersistenceController.shared.container.viewContext)
        
        entity.id = id
        entity.order = orderAdd.int32
        entity.duration = duration.int32
        entity.restDuration = restDuration.int32
        entity.voiceComment = voiceComment
        entity.noTimeLimit = noTimeLimit
        entity.basic = basic.getEntity()
        
        print("IntervalExercise: Save exercise \(id)")
        
        return entity as! S
    }
    
    func getForJSON() -> [String : Any] {
        let dict: [String : Any] = [
            "id" : id,
            "basicId" : basic.id,
            "orderAdd" : orderAdd,
            "duration" : duration,
            "restDuration" : restDuration,
            "voiceComment" : voiceComment ?? "",
            "noTimeLimit" : noTimeLimit
        ]
        
        
        return dict
    }
}
