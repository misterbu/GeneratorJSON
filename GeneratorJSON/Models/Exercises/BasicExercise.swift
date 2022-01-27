//
//  BasicExercise.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 29.03.2021.
//

import Foundation
import CoreData
import SwiftUI
import SwiftyJSON

struct BasicExercise: Identifiable, Reviewble, CatalogItem, HasProperties {
    var id: String = UUID().uuidString
    
    var iconImage: NSImage?
    var image: NSImage?
    var video: String?
    
    var name_en: String = "Default"
    var shortDescription_en: String = ""
    var description_en: String = ""
    
    var name_ru: String = ""
    var description_ru: String = ""
    var shortDescription_ru: String = ""
    
    var name: String {name_en}
    var shortDescription: String {shortDescription_en}
    var description: String {description_en}
    
    var voiceComment: [String] = []
    
    var level: [LevelType] = []
    var type: WorkType = .hiit
    var muscle: [MuscleType] = []
    var equipment: [EquipmentType] = []
    
    var authorId: String?
    
    var isPro: Bool = false
    
    var properties: [Property] {
        get{
            var value = [Property]()
            value.append(contentsOf: level)
            value.append( type)
            value.append(contentsOf: muscle)
            return value
        }
        set{}
    }
    
    // MARK: -  INIT
    init(){}

    // MARK: - FUNCS
    func saveImage(){
        //1 Get data from image
        guard let photo = image,
              // let newPhoto = photo.crop(toSize: NSSize(width: 1080, height: 1920)),
              let data = photo.imageToJPEGData(compress: 0.7)
        else {
            print("Save Image: Can't get data from NSimage")
            return
        }
        
        // 2 Get Url
        guard let url = URL.getURL(location: .exerciseImage, fileName: "exercise_image_\(id)", fileType: "jpg", create: true) else {
            print("Save Image: Can't get URL")
            return
        }
        
        // Save Image
        do{
            try data.write(to: url)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func saveIcon(){
        //1 Get data from image
        guard let icon = iconImage,
             // let newPhoto = icon.crop(toSize: NSSize(width: 400, height: 400)),
              let data = icon.imageToJPEGData(compress: 0.5)
        else {
            print("Save Image: Can't get data from NSimage")
            return
        }
        
        // 2 Get Url
        guard let url = URL.getURL(location: .exerciseImage, fileName: "exercise_icon_\(id)", fileType: "jpg", create: true) else {
            print("Save Image: Can't get URL")
            return
        }
        
        // Save Image
        do{
            try data.write(to: url)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}


// MARK: - COREDATABLE
extension BasicExercise: CoreDatable {
    init<S>(entity: S) where S : NSManagedObject {
        guard let entity = entity as? ExerciseEntity else {return}
        
        self.id = entity.id ?? UUID().uuidString
        self.name_en = entity.name ?? ""
        self.shortDescription_en = entity.shortDescr ?? ""
        self.description_en = entity.descr ?? ""
        self.name_ru = entity.nameRu ?? ""
        self.shortDescription_ru = entity.shortDescrRu ?? ""
        self.description_ru = entity.descrRu ?? ""
       // self.level = LevelType(rawValue: Int(entity.level)) ?? .all
        self.type = WorkType(rawValue: Int(entity.type)) ?? .hiit
        self.authorId = entity.autorId
        self.isPro = entity.isPro
        
        //Voice comment
        if let strVoiseComment = entity.voiceComment {
            self.voiceComment = strVoiseComment
                .components(separatedBy: ";")
                .filter({$0 != ""})
        }
        
        if let iconData = entity.iconImage {
            self.iconImage = NSImage(data: iconData)
        }
        
        if let imageData = entity.image {
            self.image = NSImage(data: imageData)
        }
        
        if let muscleStr = entity.muscle {
            self.muscle = muscleStr.components(separatedBy: ",")
                .filter({$0 != ""})
                .map({MuscleType(strValue: $0)})
        }
        if let equipnemtStr = entity.equipment {
            self.equipment = equipnemtStr.components(separatedBy: ",")
                .filter({$0 != ""})
                .map({EquipmentType(strValue: $0)})
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
        let entity = CoreDataFuncs.shared.getEntity(entity: ExerciseEntity.self, id: id) ?? ExerciseEntity(context: PersistenceController.shared.container.viewContext)
        
        entity.id = id
        entity.name = name_en
        entity.shortDescr = shortDescription_en
        entity.descr = description_en
        entity.nameRu = name_ru
        entity.shortDescrRu = shortDescription_ru
        entity.descrRu = description_ru
        entity.type = type.rawValue.int32
        entity.autorId = authorId
        entity.isPro = isPro
        
        //Voice comment
        entity.voiceComment = voiceComment.joined(separator: ";")
        
        entity.iconImage = iconImage?.imageToJPEGData()
        entity.image = image?.imageToJPEGData()
        
        entity.muscle = ""
        muscle.forEach({entity.muscle?.append($0.str + ",")})
        
        entity.equipment = ""
        equipment.forEach({entity.equipment?.append($0.str + ",")})
        
        entity.level = ""
        level.forEach({entity.level?.append($0.str + ",")})
        
        //add video
        
        return entity as! S
    }
}

// MARK: - JSOBLE
extension BasicExercise {
    func getForJSON() -> [String : Any] {
        let dict: [String : Any] = [
            "id" : id,
            "name_en": name_en,
            "shortDescription_en" : shortDescription_en,
            "description_en" : description_en,
            "name_ru": name_ru,
            "shortDescription_ru" : shortDescription_ru,
            "description_ru" : description_ru,
            "voiceComment" : voiceComment.joined(separator: ";"),
            "level" : level.map({$0.rawValue}),
            "type": type.rawValue,
            "muscle" : muscle.map({$0.rawValue}),
            "autorId": authorId ?? "",
            "isPro" : isPro
        ]
        
        //Сохраняем изображения
        saveImage()
        saveIcon()
        
        return dict
    }
}
