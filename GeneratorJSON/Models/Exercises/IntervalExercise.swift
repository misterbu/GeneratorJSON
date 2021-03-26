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
    var orderAdd: Int = 0
    
    var iconImage: NSImage?
    var image: NSImage?
    var video: String?
    
    var name: String = ""
    var shortDescription: String = ""
    var description: String = ""
    var voiceComment: String = ""
    
    var level: LevelType = .all
    var type: WorkType = .hiit
    var muscle: [String] = []
    
    var authorId: String?
    
    var isPro: Bool = false
    
    /// - TAG: Ourself vars
    var duration: Int = 0
    var restDuration: Int? 
    
     
    
    /// - TAG: INITS
    init(){}
    
    init<S>(entity: S) where S : NSManagedObject {
        guard let entity = entity as? IntervalExerciseEntity else {return}
        self.id = entity.id ?? ""
        self.orderAdd = Int(entity.orderAdd)
        self.name = entity.name ?? ""
        self.shortDescription = entity.shortDescr ?? ""
        self.description = entity.descr ?? ""
        self.voiceComment = entity.voiceComment ?? ""
        self.level = LevelType(rawValue: Int(entity.level)) ?? .all
        self.type = WorkType(rawValue: Int(entity.type)) ?? .hiit
        self.authorId = entity.authorId
        self.isPro = entity.isPro
        self.duration = Int(entity.duration)
        self.restDuration = Int(entity.restDuration)
        
        if let iconData = entity.iconImage {
            self.iconImage = NSImage(data: iconData)
        }
        
        if let imageData = entity.image {
            self.image = NSImage(data: imageData)
        }
        
        if let muscleStr = entity.muscle {
            self.muscle = muscleStr.components(separatedBy: ",").filter({$0 != ""})
        }
        
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
        entity.orderAdd = orderAdd.int32
        entity.name = name
        entity.shortDescr = shortDescription
        entity.descr = description
        entity.voiceComment = voiceComment
        entity.level = level.rawValue.int32
        entity.type = type.rawValue.int32
        entity.authorId = authorId
        entity.isPro = isPro
        entity.duration = duration.int32
        entity.restDuration = (restDuration ?? 0).int32
        
        entity.iconImage = iconImage?.imageToJPEGData()
        entity.image = image?.imageToJPEGData()
        
        entity.muscle = ""
        muscle.forEach({entity.muscle!.append($0 + ",")})
        
        return entity as! S
    }

    func setOrder<S>(entity: S, order: Int) -> S where S : NSManagedObject {
        guard let newEntity = entity as? IntervalExerciseEntity else {return entity}
        newEntity.orderAdd = orderAdd.int32
        return newEntity as! S
    }
}
