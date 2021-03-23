//
//  Exercise.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 04.03.2021.
//

import Foundation
import SwiftyJSON
import SwiftUI


class Exercise1: ObservableObject {
   
    @Published var title: String
    @Published var description: String
    @Published var voiceComment: String
    @Published var tags: [String]
    var duration: Int
    var id: String
    var type: ExerciseType
    
    @Published var photo: NSImage?
    var video: String?
    
    @Published var durationStr = "" {
        willSet {
            if let value = Int(newValue) {
                duration = value
            }
        }
    }
    
    init(){
        self.id = UUID().uuidString
        self.title = ""
        self.description = ""
        self.voiceComment = ""
        self.type = .hiit
        self.tags = []
        self.photo = nil
        self.video = nil
        self.duration = 0
    }
    
    
    init(data: JSON) {
        self.id = data["id"].string ?? ""
        self.title = data["name"].string ?? ""
        self.description = data["desc"].string ?? ""
        self.tags = data["tags"].arrayObject as? [String] ?? []
        self.voiceComment = data["voiceComment"].string ?? ""
        self.duration = data["duration"].int ?? 0
        self.type = ExerciseType(rawValue: (data["type"].int ?? 0)) ?? .rest
        
        //Get photo and video
        getImage(id: id)
    }
    
    func getDictinary() -> [String: Any]{
        var dict: [String : Any] = [
            "id" : id,
            "name" : title,
            "tags" : tags,
            "type" : type.rawValue,
            "duration": duration
        ]
        
        if description != "" {
            dict["desc"] = description
        }
        if  voiceComment != "" {
            dict["voiceComment"] = voiceComment
        }
        
        //Проверяем фото и видео
        
        return dict
        //return try? JSONSerialization.data(withJSONObject: dict)
    }
    
    func getImage(id: String){
        guard let url = URL.getURL(location: .exerciseImage, fileName: "exercise_image_\(id)", fileType: "jpg", create: false) else {return}
        if FileManager.default.fileExists(atPath: url.path) {
            photo = NSImage(byReferencing: url)
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
        photo = NSImage(byReferencing: url)
    }
    
    
    func saveImage(){
        //1 Get data from image
        guard let photo = photo,
              let newPhoto = photo.resize(withSize: NSSize(width: 1080, height: 1920)),
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
        guard let icon = photo,
              let newPhoto = icon.resize(withSize: NSSize(width: 200, height: 200)),
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




enum ExerciseType: Int {
    case rest = 0
    case hiit = 1
    case light = 2
}
