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

    var authorId: String?
    var isPro: Bool = false
    
    var properties: [Property] = []
    
    var type: WorkType {
        if let type = properties.first(where: {$0.type == .exerciseType}) as? WorkType {
            return type
        } else {
            return .hiit
        }
    }
    var entityType: NSManagedObject.Type {WorkoutsSeriaEntity.self}
    
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
        entity.authorId = authorId
        entity.isPro = isPro
        
        entity.properties = ""
        properties.forEach({entity.properties?.append($0.id + ",")})
        
        if let data = try? JSONEncoder().encode(plan) {
            entity.plan = data
        }
            
        entity.iconImage = iconImage?.imageToJPEGData()
        entity.image = image?.imageToJPEGData()
        
        return entity as! S
    }
}

// MARK: - JSONBle
extension WorkoutProgmar: JSONble{
    static var jsonType: JSONType {.program}
    func getForJSON() -> JSON {
        var json = JSON([
            "id": id,
            "name_en": name_en,
            "shortDescription_en" : shortDescription_en,
            "description_en" : description_en,
            "name_ru": name_ru,
            "shortDescription_ru" : shortDescription_ru,
            "description_ru" : description_ru,
            "autorId": authorId ?? "",
            "isPro" : isPro
        ])

              json["plan"] = JSON(plan)

        
        saveIcon()
        saveImage()
        
        return json
    }
}
