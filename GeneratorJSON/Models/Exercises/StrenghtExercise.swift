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
    var orderAdd: Int = 0
    
    var iconImage: NSImage?
    var image: NSImage?
    var video: String?
    
    var name: String = ""
    var shortDescription: String = ""
    var description: String = ""
    var voiceComment: String = ""
    
    var level: LevelType = .all
    var type: WorkType = .combine
    var muscle: [String] = []
    
    var authorId: String?
    
    var isPro: Bool = false
    
    /// - TAG: Ourself vars
    var count: Int = 0
    var weight: Double?
    var restDuration: Int?
    var isWarmUp: Bool = false
    
    /// - TAG: INITS
    init<S>(entity: S) where S : NSManagedObject {
        guard let entity = entity as? StrenghtExerciseEntity else {return}
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
        self.restDuration = Int(entity.restDuration)
        self.count = (entity.count ).int
        self.weight = entity.weight
        self.isWarmUp = entity.isWarmup
        
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
        if let countValue = values["count"] as? Int {
            self.count = countValue
        }
        
        if let weightValue = values["weight"] as? Double {
            self.weight = weightValue
        }
        
        if let isWarmUpValue = values["isWarmUp"] as? Bool {
            self.isWarmUp = isWarmUpValue
        }
        if let restValue = values["restDuration"] as? Int {
            self.restDuration = restValue
        }
        
    }
    
    func getEntity<S>() -> S where S : NSManagedObject {
        let entity = StrenghtExerciseEntity(context: PersistenceController.shared.container.viewContext)
        
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
        entity.restDuration = (restDuration ?? 0).int32
        entity.count = count.int32
        entity.weight = weight ?? 0
        entity.isWarmup = isWarmUp
        
        entity.iconImage = iconImage?.imageToJPEGData()
        entity.image = image?.imageToJPEGData()
        
        entity.muscle = ""
        muscle.forEach({entity.muscle?.append($0 + ",")})
        
        
        return entity as! S
    }

}
