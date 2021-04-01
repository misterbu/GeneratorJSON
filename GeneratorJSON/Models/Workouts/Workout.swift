//
//  Workout.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import SwiftUI

struct Workout: Identifiable, CoreDatable {
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
            print("add new circles ")
        }
        
        print("Get workout from CD, circles count \(entity.workoutCircles?.count)")
        print("Get workout from CD, target \(entity.target)")
        print("Get workout from CD, equipment \(entity.equipment)")
    }
    
    func getEntity<S>() -> S where S : NSManagedObject {
        let entity = WorkoutEntity(context: PersistenceController.shared.container.viewContext)
        
        entity.id = id
        entity.createAt = createAt
        
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
        
        entity.seriesWorkouts = ""
        seriesId.forEach({entity.seriesWorkouts?.append($0 + ",")})
        
        entity.level = ""
        level.forEach({entity.level?.append($0.str + ",")})
        
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
        entity.workoutCircles = circlesEntities as NSSet
        
        print("Workout. Save wrokout \(id), circles count \(entity.workoutCircles?.count) ")
        print("Workout. Save wrokout \(id), target \(entity.target) ")
        print("Workout. Save wrokout \(id), equipment \(entity.equipment) ")
        
        return entity as! S
    }
}
