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
    
    var iconImage: NSImage?
    var image: NSImage?
    var video: String?
    
    var name: String = ""
    var shortDescription: String?
    var description: String = ""
    var voiceComment: String?
    
    var level: LevelType = .all
    var type: WorkType = .hiit
    var muscle: [String] = []
    
    var authorId: String?
    
    var isPro: Bool = false
    
    /// - TAG: Ourself vars
    var duration: Int = 0
    var restDuration: Int? 
    
     
    
    /// - TAG: INITS
    init<S>(entity: S) where S : NSManagedObject {
        guard let entity = entity as? IntervalExerciseEntity else {return}
        self.id = entity.id ?? ""
        self.name = entity.name ?? ""
        self.shortDescription = entity.shortDescr
        self.description = entity.descr ?? ""
        self.voiceComment = entity.voiceComment
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
            self.muscle = muscleStr.components(separatedBy: ",")
        }
        
        //Видео пока оставить в покое
    }
    
    func setEntity<S>(entity: S) -> S where S : NSManagedObject {
        guard let newEntity = entity as? IntervalExerciseEntity else {return entity}
        
        newEntity.id = id
        newEntity.name = name
        newEntity.shortDescr = shortDescription
        newEntity.descr = description
        newEntity.voiceComment = voiceComment
        newEntity.level = level.rawValue.int32
        newEntity.type = type.rawValue.int32
        newEntity.authorId = authorId
        newEntity.isPro = isPro
        newEntity.duration = duration.int32
        newEntity.restDuration = (restDuration ?? 0).int32
        
        newEntity.iconImage = iconImage?.imageToJPEGData()
        newEntity.image = image?.imageToJPEGData()
        
        muscle.forEach({newEntity.muscle?.append($0 + ",")})
        
        
        return newEntity as! S
    }

}
