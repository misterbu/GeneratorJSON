//
//  WorkoutSeria.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import SwiftUI
import SwiftyJSON

struct WorkoutProgmar: Reviewble, CatalogItem, HasProperties {
    var id: String = UUID().uuidString
    var createAt: Date = Date()
    
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
    
    var plan: [String: String] = [:]
    
    var level: [LevelType] = []
    var type: WorkType = .combine
    var sex: SexType = .unisex
    var target: [TargetType] = []
    var equipment: [EquipmentType] = []
    var place: PlaceType = .home
    
    var authorId: String?
    var isPro: Bool = false
    
    var properties: [Property] = []
    
    
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


// MARK: - COREDATABLE
extension WorkoutProgmar: CoreDatable {
    init<S>(entity: S) where S : NSManagedObject {
        guard let entity = entity as? WorkoutsSeriaEntity else {return}
        self.id = entity.id ?? UUID().uuidString
        self.name_en = entity.name ?? ""
        self.shortDescription_en = entity.shortDescr ?? ""
        self.description_en = entity.descr ?? ""
        self.name_ru = entity.nameRu ?? ""
        self.shortDescription_ru = entity.shortDescrRu ?? ""
        self.description_ru = entity.descrRu ?? ""
        
        if let planData = entity.plan,
           let value = try? JSONDecoder().decode([String: String].self, from: planData) {
            self.plan = value
        }
        
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
        
        self.authorId = entity.authorId
        self.isPro = entity.isPro
        
        if let iconData = entity.iconImage {
            self.iconImage = NSImage(data: iconData)
        }
        
        if let imageData = entity.image {
            self.image = NSImage(data: imageData)
        }
        
    }
    
    func getEntity<S>() -> S where S : NSManagedObject {
        let entity = CoreDataFuncs.shared.getEntity(entity: WorkoutsSeriaEntity.self, id: id) ?? WorkoutsSeriaEntity(context: PersistenceController.shared.container.viewContext)
        
        entity.id = id
        entity.name = name_en
        entity.shortDescr = shortDescription_en
        entity.descr = description_en
        entity.nameRu = name_ru
        entity.shortDescrRu = shortDescription_ru
        entity.descrRu = description_ru
        entity.type = type.rawValue.int32
        entity.sex = sex.rawValue.int32
        entity.place = place.rawValue.int32
        entity.authorId = authorId
        entity.isPro = isPro
        
        if let data = try? JSONEncoder().encode(plan) {
            entity.plan = data
        }
        
        entity.target = ""
        target.forEach({entity.target?.append($0.str + ",")})
        
        entity.equipment = ""
        equipment.forEach({entity.equipment?.append($0.str + ",")})
        
        entity.level = ""
        level.forEach({entity.level?.append($0.str + ",")})
        
        entity.iconImage = iconImage?.imageToJPEGData()
        entity.image = image?.imageToJPEGData()
        
        return entity as! S
    }
}

// MARK: - JSONBle
extension WorkoutProgmar{
    func getForJSON() -> JSON {
        var json = JSON([
            "id": id,
            "name_en": name_en,
            "shortDescription_en" : shortDescription_en,
            "description_en" : description_en,
            "name_ru": name_ru,
            "shortDescription_ru" : shortDescription_ru,
            "description_ru" : description_ru,
            "level" : level.map({$0.rawValue}),
            "type": type.rawValue,
            "sex": sex.rawValue,
            "target" : target.map({$0.rawValue}),
            "equipment" : equipment.map({$0.rawValue}),
            "place" : place.rawValue,
            "autorId": authorId ?? "",
            "isPro" : isPro
        ])

              json["plan"] = JSON(plan)

        
        saveIcon()
        saveImage()
        
        return json
    }
}
