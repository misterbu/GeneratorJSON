//
//  Workout.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import SwiftUI
import SwiftyJSON

struct Workout: Identifiable, CoreDatable {
    var id: String = UUID().uuidString
    var createAt: Date = Date()
    
    var iconImage: NSImage?
    var image: NSImage?
    var video: String?
    
    var name: String = "Default"
    var shortDescription: String = ""
    var description: String = ""
    var workoutCircles: [WorkoutCircle] = []
    var seriaId: String?
    
    var level: [LevelType] = []
    var type: WorkType = .combine
    var sex: SexType = .unisex
    var target: [TargetType] = []
    var equipment: [EquipmentType] = []
    
    var authorId: String?
    
    var isPro: Bool = false
    
    
    /// - TAG: INITs
    init(){}
    
    init<S>(entity: S) where S : NSManagedObject {
        guard let entity = entity as? WorkoutEntity else {return}
        self.id = entity.id ?? UUID().uuidString
        self.createAt = entity.createAt ?? Date()
        self.name = entity.name ?? ""
        self.shortDescription = entity.shortDescr ?? ""
        self.description = entity.descr ?? ""
        self.seriaId = entity.seriesWorkouts
        
        self.type = WorkType(rawValue: Int(entity.type)) ?? .hiit
        self.sex = SexType(rawValue: Int(entity.sex)) ?? .unisex
        
        if let targetStr = entity.target {
            self.target = targetStr.components(separatedBy: ",")
                .filter({$0 != ""})
                .map({ TargetType(strValue: $0)})
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
        
        self.authorId = entity.authorId
        self.isPro = entity.isPro
        
        if let iconData = entity.iconImage {
            self.iconImage = NSImage(data: iconData)
        }
        
        if let imageData = entity.image {
            self.image = NSImage(data: imageData)
        }

        //add circles
        if let circlesEntities = entity.workoutCircles as? Set<CircleEntity> {
            self.workoutCircles = circlesEntities.map({WorkoutCircle(entity: $0)})
            self.workoutCircles.sort(by: {$0.orderAdd < $1.orderAdd})
            print("add new circles ")
        }
        
    }
    
    func getEntity<S>() -> S where S : NSManagedObject {
        let entity = WorkoutEntity(context: PersistenceController.shared.container.viewContext)
        
        entity.id = id
        entity.createAt = createAt
        
        entity.name = name
        entity.shortDescr = shortDescription
        entity.descr = description
        entity.seriesWorkouts = seriaId
        entity.type = type.rawValue.int32
        entity.sex = sex.rawValue.int32
        entity.authorId = authorId
        entity.isPro = isPro
        
        entity.target = ""
        target.forEach({entity.target?.append($0.str + ",")})
        
        entity.equipment = ""
        equipment.forEach({entity.equipment?.append($0.str + ",")})
        
        entity.level = ""
        level.forEach({entity.level?.append($0.str + ",")})
        
        entity.iconImage = iconImage?.imageToJPEGData()
        entity.image = image?.imageToJPEGData()
        
        //Сохраняем циклы, не забыв указать им порядковый номер
     
        var circlesEntities = Set<CircleEntity>()
        workoutCircles.forEach({
            circlesEntities.insert($0.getEntity())
        })
        entity.workoutCircles = circlesEntities as NSSet
        
        
        return entity as! S
    }
    
    func getForJSON() -> [String: Any]{
        let dict: [String: Any] = [
            "id": id,
            "name": name,
            "shortDescription" : shortDescription,
            "description" : description,
            "serieaId" : seriaId ?? "",
            "level" : level.map({$0.rawValue}),
            "type": type.rawValue,
            "sex": sex.rawValue,
            "target" : target.map({$0.rawValue}),
            "equipment" : equipment.map({$0.rawValue}),
            "autorId": authorId ?? "",
            "isPro" : isPro,
            "workoutCircles" : workoutCircles.map({$0.getForJSON()})
        ]

        saveImage()
        saveIcon()
        
        return dict
    }
    
    func saveImage(){
        //1 Get data from image
        guard let photo = image,
              let newPhoto = photo.resize(withSize: NSSize(width: 1080, height: 1920)),
              let data = newPhoto.imageToJPEGData(compress: 0.7)
        else {
            print("Save Image: Can't get data from NSimage")
            return
        }

        // 2 Get Url
        guard let url = URL.getURL(location: .workoutImage, fileName: "workout_image_\(id)", fileType: "jpg", create: true) else {
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
              let newPhoto = icon.resize(withSize: NSSize(width: 400, height: 400)),
              let data = newPhoto.imageToJPEGData(compress: 1)
        else {
            print("Save Image: Can't get data from NSimage")
            return
        }

        // 2 Get Url
        guard let url = URL.getURL(location: .workoutImage, fileName: "workout_icon_\(id)", fileType: "jpg", create: true) else {
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


//
//func getDictinary() -> [String: Any]{
//    var dict: [String : Any] = [
//        "id" : id,
//        "name" : title,
//        "tags" : tags,
//        "type" : type.rawValue,
//        "duration": duration
//    ]
//
//    if description != "" {
//        dict["desc"] = description
//    }
//    if  voiceComment != "" {
//        dict["voiceComment"] = voiceComment
//    }
//
//    //Проверяем фото и видео
//
//    return dict
//    //return try? JSONSerialization.data(withJSONObject: dict)
//}
//
//func getImage(id: String){
//    guard let url = URL.getURL(location: .exerciseImage, fileName: "exercise_image_\(id)", fileType: "jpg", create: false) else {return}
//    if FileManager.default.fileExists(atPath: url.path) {
//        photo = NSImage(byReferencing: url)
//    }
//}
//
//func addTag(_ value: String){
//    guard  value != "" else {return}
//    //Создаем массив тегов из полученной строчки (теги разделены запятой)
//    //До этого убираем из полученной строчки все пробелы
//    let tagStr = value.replacingOccurrences(of: " ", with: "")
//    let tagArray = tagStr.components(separatedBy: ",")
//
//    //Если такого тега еще нет, добавляем его
//    tagArray.forEach({ tag in
//        if !tags.contains(where: {tag == $0}) {
//            tags.append(tag)
//        }
//    })
//}
//
//func deleteTag(_ index: Int) {
//    tags.remove(at: index)
//}
//
//func addImage(url: URL) {
//    photo = NSImage(byReferencing: url)
//}
//
//
//func saveImage(){
//    //1 Get data from image
//    guard let photo = photo,
//          let newPhoto = photo.resize(withSize: NSSize(width: 1080, height: 1920)),
//          let data = newPhoto.imageToJPEGData(compress: 0.7)
//    else {
//        print("Save Image: Can't get data from NSimage")
//        return
//    }
//
//    // 2 Get Url
//    guard let url = URL.getURL(location: .exerciseImage, fileName: "exercise_image_\(id)", fileType: "jpg", create: true) else {
//        print("Save Image: Can't get URL")
//        return
//    }
//
//    // Save Image
//    do{
//        try data.write(to: url)
//    } catch let error {
//        print(error.localizedDescription)
//    }
//}
//
//func saveIcon(){
//    //1 Get data from image
//    guard let icon = photo,
//          let newPhoto = icon.resize(withSize: NSSize(width: 200, height: 200)),
//          let data = newPhoto.imageToJPEGData(compress: 1)
//    else {
//        print("Save Image: Can't get data from NSimage")
//        return
//    }
//
//    // 2 Get Url
//    guard let url = URL.getURL(location: .exerciseImage, fileName: "exercise_icon_\(id)", fileType: "jpg", create: true) else {
//        print("Save Image: Can't get URL")
//        return
//    }
//
//    // Save Image
//    do{
//        try data.write(to: url)
//    } catch let error {
//        print(error.localizedDescription)
//    }
//}
