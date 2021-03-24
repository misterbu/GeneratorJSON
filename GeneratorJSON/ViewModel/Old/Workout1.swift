//
//  Workout.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 05.03.2021.
//

import Foundation
import SwiftyJSON
import SwiftUI


class Workout1: ObservableObject {
   
//    @Published var title: String
//    @Published var description: String
//    @Published var voiceComment: String
    //    @Published var tags: [String]
    //    var id: String
    //    var type: ExerciseType
    
    var id: String = ""
    var createAt: Date = Date()
    
    @Published var image: NSImage?

    @Published var name: String = ""
    @Published var description: String = ""
    @Published var exersises: [String]  = []// id упражнений
    
    
    @Published var selectedType: Int = 0 {
        willSet{
            type = WorkoutType.allCases[newValue]
        }
    }
    @Published var selectedLevel: Int = 0 {
        willSet{
            level = WorkoutLevel.allCases[newValue]
        }
    }
    @Published var tags: [String] = []
    var type: WorkoutType = WorkoutType.interval
    var level: WorkoutLevel = WorkoutLevel.started
    @Published var isPro: Bool = false
    @Published var releatedWorkouts: [String] = []  // id тренировок, включая текущую
   
    
    
    
    
    
    init(){
//        self.id = UUID().uuidString
//        self.name = ""
//        self.description = ""
//        self.tags = []
//        self.type = .interval
//        self.level = .started
//        self.isPro = true
//        self.releatedWorkouts = []
//        self.exersises = []
//        self.image = nil
    }
    
    
    init(data: JSON) {
        self.id = data["id"].string ?? ""
        self.name = data["name"].string ?? ""
        self.description = data["desc"].string ?? ""
        self.tags = data["tags"].arrayObject as? [String] ?? []
        self.type = WorkoutType(rawValue: (data["type"].int ?? 0)) ?? .interval
        self.level = WorkoutLevel(rawValue: (data["level"].int ?? 1)) ?? .started
        self.isPro = data["isPro"].bool ?? true
        self.releatedWorkouts = data["releatedWorkouts"].arrayObject as? [String] ?? []
        self.exersises = data["exercises"].arrayObject as? [String] ?? []
        
        //Get photo and video
        getImage(id: id)
    }
    
    func getDictinary() -> [String: Any]{
        let dict: [String : Any] = [
            "id" : id,
            "name" : name,
            "desc" : description,
            "tags" : tags,
            "type" : type.rawValue,
            "level" : level.rawValue,
            "isPro" : isPro,
            "releatedWorkouts" : releatedWorkouts,
            "exercises" : exersises
        ]
        
        return dict
        //return try? JSONSerialization.data(withJSONObject: dict)
    }
    
    func getImage(id: String){
        guard let url = URL.getURL(location: .workoutImage, fileName: "workout_image_\(id)", fileType: "jpg", create: false) else {return}
        if FileManager.default.fileExists(atPath: url.path) {
            image = NSImage(byReferencing: url)
        }
    }
    
    func addTag(_ value: String){
        guard  value != "" else {return}
        //Создаем массив тегов из полученной строчки (теги разделены запятой)
        //До этого убираем из полученной строчки все пробелы
        let tagStr = value.replacingOccurrences(of: " ", with: "")
        let tagArray = tagStr.components(separatedBy: ",")
        
        //Если такого тега еще нет, добавляем его
        tagArray.forEach({ tag in
            if !tags.contains(where: {tag == $0}) {
                tags.append(tag)
            }
        })
    }
    
    func deleteTag(_ index: Int) {
        tags.remove(at: index)
    }
    
    func addImage(url: URL) {
        image = NSImage(byReferencing: url)
    }
    
    
    func saveImage(){
        //1 Get data from image
        guard let image = image,
              let newImage = image.resize(withSize: NSSize(width: 1920, height: 1080)),
              let data = newImage.imageToJPEGData(compress: 0.7)
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
        guard let icon = image,
              let newIcon = icon.resize(withSize: NSSize(width: 200, height: 200)),
              let data = newIcon.imageToJPEGData(compress: 1)
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




enum WorkoutType: Int, CaseIterable, NamedEnums {
    case interval = 0
    case strenght = 1
    
    var str: String {
        switch self {
        
        case .interval:
            return "Interval training"
        case .strenght:
            return "Strenght training"
        }
    }
}

enum WorkoutLevel: Int, CaseIterable, NamedEnums {
    case started = 1
    case middle = 10
    case profi = 100
    
    var str: String {
        switch self {
        
        case .started:
            return "Started level"
        case .middle:
            return "Middle level"
        case .profi:
            return "Profi level"
        }
    }
}
