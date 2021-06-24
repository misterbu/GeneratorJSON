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
    
    func getForJSON() -> [String : Any] {
        var dict: [String : Any] = [
            "id" : id,
            "name" : name,
            "shortDescription" : shortDescription,
            "description" : description,
            "voiceComment" : voiceComment,
            "level" : level.map({$0.rawValue}),
            "type": type.rawValue,
            "muscle" : muscle,
            "autorId": authorId ?? "",
            "isPro" : isPro,
        ]
        
        //Сохраняем изображения
        saveImage()
        saveIcon()
        
        return dict
    }
    
        func saveImage(){
            //1 Get data from image
            guard let photo = image,
                  let newPhoto = photo.crop(toSize: NSSize(width: 1080, height: 1920)),
                  let data = newPhoto.imageToJPEGData(compress: 0.7)
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
                  let newPhoto = icon.crop(toSize: NSSize(width: 400, height: 400)),
                  let data = newPhoto.imageToJPEGData(compress: 1)
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



//struct JJJJ {
//    
//    
//    init(data: JSON) {
//        self.id = data["id"].string ?? ""
//        self.title = data["name"].string ?? ""
//        self.description = data["desc"].string ?? ""
//        self.tags = data["tags"].arrayObject as? [String] ?? []
//        self.voiceComment = data["voiceComment"].string ?? ""
//        self.duration = data["duration"].int ?? 0
//        self.type = ExerciseType(rawValue: (data["type"].int ?? 0)) ?? .rest
//        
//        //Get photo and video
//        getImage(id: id)
//    }
//    
//    func getDictinary() -> [String: Any]{
//        var dict: [String : Any] = [
//            "id" : id,
//            "name" : title,
//            "tags" : tags,
//            "type" : type.rawValue,
//            "duration": duration
//        ]
//        
//        if description != "" {
//            dict["desc"] = description
//        }
//        if  voiceComment != "" {
//            dict["voiceComment"] = voiceComment
//        }
//        
//        //Проверяем фото и видео
//        
//        return dict
//        //return try? JSONSerialization.data(withJSONObject: dict)
//    }
//    
//    func getImage(id: String){
//        guard let url = URL.getURL(location: .exerciseImage, fileName: "exercise_image_\(id)", fileType: "jpg", create: false) else {return}
//        if FileManager.default.fileExists(atPath: url.path) {
//            photo = NSImage(byReferencing: url)
//        }
//    }
//    
//    func addTag(_ value: String){
//        guard  value != "" else {return}
//        //Создаем массив тегов из полученной строчки (теги разделены запятой)
//        //До этого убираем из полученной строчки все пробелы
//        let tagStr = value.replacingOccurrences(of: " ", with: "")
//        let tagArray = tagStr.components(separatedBy: ",")
//        
//        //Если такого тега еще нет, добавляем его
//        tagArray.forEach({ tag in
//            if !tags.contains(where: {tag == $0}) {
//                tags.append(tag)
//            }
//        })
//    }
//    
//    func deleteTag(_ index: Int) {
//        tags.remove(at: index)
//    }
//    
//    func addImage(url: URL) {
//        photo = NSImage(byReferencing: url)
//    }
//    
//    
//    func saveImage(){
//        //1 Get data from image
//        guard let photo = photo,
//              let newPhoto = photo.resize(withSize: NSSize(width: 1080, height: 1920)),
//              let data = newPhoto.imageToJPEGData(compress: 0.7)
//        else {
//            print("Save Image: Can't get data from NSimage")
//            return
//        }
//        
//        // 2 Get Url
//        guard let url = URL.getURL(location: .exerciseImage, fileName: "exercise_image_\(id)", fileType: "jpg", create: true) else {
//            print("Save Image: Can't get URL")
//            return
//        }
//        
//        // Save Image
//        do{
//            try data.write(to: url)
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }
//    
//    func saveIcon(){
//        //1 Get data from image
//        guard let icon = photo,
//              let newPhoto = icon.resize(withSize: NSSize(width: 200, height: 200)),
//              let data = newPhoto.imageToJPEGData(compress: 1)
//        else {
//            print("Save Image: Can't get data from NSimage")
//            return
//        }
//        
//        // 2 Get Url
//        guard let url = URL.getURL(location: .exerciseImage, fileName: "exercise_icon_\(id)", fileType: "jpg", create: true) else {
//            print("Save Image: Can't get URL")
//            return
//        }
//        
//        // Save Image
//        do{
//            try data.write(to: url)
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }
//}
