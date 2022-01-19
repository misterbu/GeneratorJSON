//
//  Workout.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import SwiftUI
import SwiftyJSON

struct Workout: Identifiable, Reviewble, CoreDatable {
    var id: String = UUID().uuidString
    var createAt: Date = Date()
    var orderAdd: Int = 0
    
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
    
    var workoutCircles: [WorkoutCircle] = []
    var seriaId: String?
    
    var level: [LevelType] = []
    var type: WorkType = .combine
    var muscle: [MuscleType] = []
    var sex: SexType = .unisex
    var target: [TargetType] = []
    var equipment: [EquipmentType] = []
    var place: PlaceType = .home
    
    var authorId: String?
    
    var isPro: Bool = false
    
    
    // MARK: - INIT
    init(){}
    
    
    // MARK: - FUNCS
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


// MARK: - COREDATABLE
extension Workout  {
    init<S>(entity: S) where S : NSManagedObject {
        guard let entity = entity as? WorkoutEntity else {return}
        self.id = entity.id ?? UUID().uuidString
        self.orderAdd = entity.orderAdd.int
        self.createAt = entity.createAt ?? Date()
        self.name_en = entity.name ?? ""
        self.shortDescription_en = entity.shortDescr ?? ""
        self.description_en = entity.descr ?? ""
        self.name_ru = entity.nameRu ?? ""
        self.shortDescription_ru = entity.shortDescrRu ?? ""
        self.description_ru = entity.descrRu ?? ""
        
        self.seriaId = entity.seriesWorkouts
        
        self.type = WorkType(rawValue: Int(entity.type)) ?? .hiit
        self.sex = SexType(rawValue: Int(entity.sex)) ?? .unisex
        self.place = PlaceType(rawValue: entity.place.int) ?? .home
        
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
        
        if let muscleStr = entity.muscle {
            self.muscle = muscleStr.components(separatedBy: ",")
                .filter({$0 != ""})
                .map({MuscleType(strValue: $0)})
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
        let entity = CoreDataFuncs.shared.getEntity(entity: WorkoutEntity.self, id: id) ??
                        WorkoutEntity(context: PersistenceController.shared.container.viewContext)
        
        entity.id = id
        entity.orderAdd = orderAdd.int32
        entity.createAt = createAt
        
        entity.name = name_en
        entity.shortDescr = shortDescription_en
        entity.descr = description_en
        entity.nameRu = name_ru
        entity.shortDescrRu = shortDescription_ru
        entity.descrRu = description_ru
        
        entity.seriesWorkouts = seriaId
        entity.type = type.rawValue.int32
        entity.sex = sex.rawValue.int32
        entity.place = place.rawValue.int32
        entity.authorId = authorId
        entity.isPro = isPro
        
        entity.target = ""
        target.forEach({entity.target?.append($0.str + ",")})
        
        entity.equipment = ""
        equipment.forEach({entity.equipment?.append($0.str + ",")})
        
        entity.muscle = ""
        muscle.forEach({entity.muscle?.append($0.str + ",")})
        
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
}

// MARK: - JSONBle
extension Workout {
    func getForJSON() -> [String: Any]{
        let dict: [String: Any] = [
            "id": id,
            "name_en": name_en,
            "shortDescription_en" : shortDescription_en,
            "description_en" : description_en,
            "name_ru": name_ru,
            "shortDescription_ru" : shortDescription_ru,
            "description_ru" : description_ru,
            "serieaId" : seriaId ?? "",
            "level" : level.map({$0.rawValue}),
            "muscle": muscle.map({$0.rawValue}),
            "type": type.rawValue,
            "sex": sex.rawValue,
            "target" : target.map({$0.rawValue}),
            "equipment" : equipment.map({$0.rawValue}),
            "place" : place.rawValue,
            "autorId": authorId ?? "",
            "isPro" : isPro,
            "workoutCircles" : workoutCircles.map({$0.getForJSON()})
        ]

        saveImage()
        saveIcon()
        
        return dict
    }
}
