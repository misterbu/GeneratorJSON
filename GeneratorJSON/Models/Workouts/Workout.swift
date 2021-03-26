//
//  Workout.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import SwiftUI

struct Workout: CoreDatable {
    var id: String = UUID().uuidString
    var createAt: Date = Date()
    
    var iconImage: NSImage?
    var image: NSImage?
    var video: String?
    
    var name: String = ""
    var shortDescription: String = ""
    var description: String = ""
    var workoutCircles: [WorkoutCircle] = []
    var seriesId: [String] = []
    
    var level: LevelType = .all
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
        self.id = entity.id ?? ""
        self.createAt = entity.createAt ?? Date()
        self.name = entity.name ?? ""
        self.shortDescription = entity.shortDescr ?? ""
        self.description = entity.descr ?? ""
        
        self.level = LevelType(rawValue: Int(entity.level)) ?? .all
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
        
        if let seriesStr = entity.seriesWorkouts {
            self.seriesId = seriesStr.components(separatedBy: ",")
                .filter({$0 != ""})
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
            self.workoutCircles.sort(by: {$0.orderAdd > $1.orderAdd})
        }
    }
    
    func getEntity<S>() -> S where S : NSManagedObject {
        let entity = WorkoutEntity(context: PersistenceController.shared.container.viewContext)
        
        entity.id = id
        entity.createAt = createAt
        
        entity.name = name
        entity.shortDescr = shortDescription
        entity.descr = description
        entity.level = level.rawValue.int32
        entity.type = type.rawValue.int32
        entity.sex = sex.rawValue.int32
        entity.authorId = authorId
        entity.isPro = isPro
        
        target.forEach({entity.target?.append($0.str + ",")})
        equipment.forEach({entity.equipment?.append($0.str + ",")})
        seriesId.forEach({entity.seriesWorkouts?.append($0 + ",")})
        
        entity.iconImage = iconImage?.imageToJPEGData()
        entity.image = image?.imageToJPEGData()
        
        //Сохраняем циклы, не забыв указать им порядковый номер
        var order = 0
        var circlesEntities = Set<CircleEntity>()
        workoutCircles.forEach({
            var circle = $0
            circle.orderAdd = order
            circlesEntities.insert(circle.getEntity())
            order += 1
        })
        
        return entity as! S
    }
}
