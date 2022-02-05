//
//  Workout.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import SwiftUI
import SwiftyJSON

struct Workout: Identifiable, CatalogItem, HasProperties {
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
    var authorId: String?
    var isPro: Bool = false
    var properties: [Property] = [WorkType.hiit,
                                  LevelType.all,
                                  PlaceType.gym]
    
    var type: WorkType {
        if let type = properties.first(where: {$0.type == .exerciseType}) as? WorkType {
            return type
        } else {
            return .hiit
        }
    }
    
    var entityType: NSManagedObject.Type {WorkoutEntity.self}

    // MARK: - INIT
    init(){
    }
    
    
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
extension Workout: CoreDatable  {
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
        
        if let entityProperty = entity.properties{
            let propertiesIDs = entityProperty.components(separatedBy: ",")
            self.properties =  propertiesIDs.compactMap({
                HelpFuncs.getProperty(from: $0)
            })
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
        
        entity.properties = ""
        properties.forEach({entity.properties?.append($0.id + ",")})
        
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
extension Workout: JSONble {
    
    static var jsonType: JSONType {.workout}
    
    func getForJSON() -> JSON {
        let json = JSON ([
            "id": id,
            "name_en": name_en,
            "shortDescription_en" : shortDescription_en,
            "description_en" : description_en,
            "name_ru": name_ru,
            "shortDescription_ru" : shortDescription_ru,
            "description_ru" : description_ru,
            "autorId": authorId ?? "",
            "isPro" : isPro,
            "workoutCircles" : workoutCircles.map({$0.getForJSON()})
        ])

        saveImage()
        saveIcon()
        
        return json
    }
}

// MARK: - SAMPLE
extension Workout {
    static var sample: Workout {
        var workout = Workout()
        workout.name_en = "Hiit workout"
        workout.properties = [WorkType.hiit,
                              MuscleType.shoulders]
        workout.image = NSImage(named: "bgImage")
        workout.iconImage = NSImage(named: "bgImage")
        return workout
    }
    
    static var sample2: Workout {
        var workout = Workout()
        workout.name_en = "Classic workout"
        workout.properties = [WorkType.strenght,
                              MuscleType.shoulders]
        workout.image = NSImage(named: "bgImage")
        workout.iconImage = NSImage(named: "bgImage")
        return workout
    }
}
