//
//  BasicExercise.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 29.03.2021.
//

import Foundation
import CoreData
import SwiftUI

struct BasicExercise: Identifiable, CoreDatable {
    var id: String = UUID().uuidString
    
    var iconImage: NSImage?
    var image: NSImage?
    var video: String?
    
    var name: String = ""
    var shortDescription: String = ""
    var description: String = ""
    var voiceComment: String = ""
    
    var level: [LevelType] = []
    var type: WorkType = .hiit
    var muscle: [String] = []
    
    var authorId: String?
    
    var isPro: Bool = false
    
    
    /// - TAG: INITs
    init(){}
    
    init<S>(entity: S) where S : NSManagedObject {
        guard let entity = entity as? ExerciseEntity else {return}
        
        self.id = entity.id ?? UUID().uuidString
        self.name = entity.name ?? ""
        self.shortDescription = entity.shortDescr ?? ""
        self.description = entity.descr ?? ""
        self.voiceComment = entity.voiceComment ?? ""
       // self.level = LevelType(rawValue: Int(entity.level)) ?? .all
        self.type = WorkType(rawValue: Int(entity.type)) ?? .hiit
        self.authorId = entity.autorId
        self.isPro = entity.isPro
        
        if let iconData = entity.iconImage {
            self.iconImage = NSImage(data: iconData)
        }
        
        if let imageData = entity.image {
            self.image = NSImage(data: imageData)
        }
        
        if let muscleStr = entity.muscle {
            self.muscle = muscleStr.components(separatedBy: ",").filter({$0 != ""})
        }
        
        if let levelStr = entity.level {
            self.level = levelStr
                .components(separatedBy: ",")
                .filter({$0 != ""})
                .map({LevelType(strValue: $0)})
        }
        
        //addVideo
    }
    
    func getEntity<S>() -> S where S : NSManagedObject {
        let entity = ExerciseEntity(context: PersistenceController.shared.container.viewContext)
        
        entity.id = id
        entity.name = name
        entity.shortDescr = shortDescription
        entity.descr = description
        entity.voiceComment = voiceComment
        entity.type = type.rawValue.int32
        entity.autorId = authorId
        entity.isPro = isPro
        
        entity.iconImage = iconImage?.imageToJPEGData()
        entity.image = image?.imageToJPEGData()
        
        entity.muscle = ""
        muscle.forEach({entity.muscle?.append($0 + ",")})
        
        entity.level = ""
        level.forEach({entity.level?.append($0.str + ",")})
        
        //add video
        
        return entity as! S
    }
}
