//
//  WorkoutSeria.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import SwiftUI

struct WorkoutSeria: CoreDatable {
    var id: String = UUID().uuidString
    var createAt: Date = Date()
    
    var iconImage: NSImage?
    var image: NSImage?
    var video: String?
    
    var name: String = ""
    var shortDescription: String = ""
    var description: String = ""
    var workouts: [WorkoutSeriaItem] = []
    
//    var level: [LevelType] = []
//    var type: WorkType = .combine
//    var sex: SexType = .unisex
//    var target: [TargetType] = []
//    var equipment: [EquipmentType] = []
    
    var authorId: String?
    var isPro: Bool = false
    
    /// - TAG: INITs
    init(){}
    
    init<S>(entity: S) where S : NSManagedObject {
        guard let entity = entity as? WorkoutsSeriaEntity else {return}
        self.id = entity.id ?? UUID().uuidString
        self.name = entity.name ?? ""
        self.shortDescription = entity.shortDescr ?? ""
        self.description = entity.descr ?? ""
        
//        self.type = WorkType(rawValue: Int(entity.type)) ?? .hiit
//        self.sex = SexType(rawValue: Int(entity.sex)) ?? .unisex
//
//        if let targetStr = entity.target {
//            self.target = targetStr.components(separatedBy: ",")
//                .filter({$0 != ""})
//                .map({ TargetType(strValue: $0)})
//        }
//
//        if let equipnemtStr = entity.equipment {
//            self.equipment = equipnemtStr.components(separatedBy: ",")
//                .filter({$0 != ""})
//                .map({EquipmentType(strValue: $0)})
//        }
//
//        if let levelStr = entity.level {
//            self.level = levelStr
//                .components(separatedBy: ",")
//                .filter({$0 != ""})
//                .map({LevelType(strValue: $0)})
//        }
        
        self.authorId = entity.authorId
        self.isPro = entity.isPro
        
        if let iconData = entity.iconImage {
            self.iconImage = NSImage(data: iconData)
        }
        
        if let imageData = entity.image {
            self.image = NSImage(data: imageData)
        }
        
        if let workoutSeriaItemsEntities = entity.workoutItems as? Set<WorkoutSeriaItemsEntity> {
            self.workouts = workoutSeriaItemsEntities.map({WorkoutSeriaItem(entity: $0)})
        }
    }
    
    func getEntity<S>() -> S where S : NSManagedObject {
        let entity = WorkoutsSeriaEntity(context: PersistenceController.shared.container.viewContext)
        
        entity.id = id
        
        entity.name = name
        entity.shortDescr = shortDescription
        entity.descr = description
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
        
        var items = Set<WorkoutSeriaItemsEntity>()
        workouts.forEach({items.insert($0.getEntity())})
        entity.workoutItems = items as NSSet
        
        return entity as! S
    }
    
    func getForJSON() -> [String: Any] {
        let dict: [String: Any] = [
            "id": id,
            "name": name,
            "shortDescription" : shortDescription,
            "description" : description,
            "level" : level.map({$0.rawValue}),
            "type": type.rawValue,
            "sex": sex.rawValue,
            "target" : target.map({$0.rawValue}),
            "equipment" : equipment.map({$0.rawValue}),
            "autorId": authorId ?? "",
            "isPro" : isPro,
            "items": workouts.map({$0.getForJSON()})
        ]
        
        saveIcon()
        saveImage()
        
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
        guard let url = URL.getURL(location: .seriaImage, fileName: "program_image_\(id)", fileType: "jpg", create: true) else {
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
//              let newPhoto = icon.resize(withSize: NSSize(width: 400, height: 400)),
              let newPhoto = icon.crop(toSize: NSSize(width: 400, height: 400)) ,
              let data = newPhoto.imageToJPEGData(compress: 1)
        else {
            print("Save Image: Can't get data from NSimage")
            return
        }

        // 2 Get Url
        guard let url = URL.getURL(location: .seriaImage, fileName: "program_icon_\(id)", fileType: "jpg", create: true) else {
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


struct WorkoutSeriaItem: CoreDatable {

    var id: String = UUID().uuidString
    var day: Int = 0
    var workout: Workout = Workout()
    
    init(workout: Workout, day: Int){
        self.workout = workout
        self.day = day
    }
    
    /// - TAG: INITs
    init(){}
    
    init<S>(entity: S) where S : NSManagedObject {
        guard let entity = entity as? WorkoutSeriaItemsEntity else {return}
        self.id = entity.id ?? UUID().uuidString
        self.day = entity.day.int
        
        if let workoutId = entity.workoutId,
           let workoutModel = CoreDataFuncs.shared.get(entity: WorkoutEntity.self, model: Workout.self, id: workoutId) {
            self.workout = workoutModel
        } else {
            self.workout = Workout()
        }
    }
    
    func getEntity<S>() -> S where S : NSManagedObject {
        let entity = WorkoutSeriaItemsEntity(context: PersistenceController.shared.container.viewContext)
        entity.id = id
        entity.day = day.int32
        entity.workoutId = workout.id
        
        
        
        return entity as! S
    }
    
    func getForJSON() -> [String: Any] {
        let dict: [String: Any] = [
            "id": id,
            "day": day,
            "workout" : workout.id
        ]
        
        return dict
    }
    
}
