//
//  URL+ext.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 04.03.2021.
//

import Foundation

extension URL {
    static func getURL(location: MyLocation, fileName: String? = nil, fileType: String? = nil, create: Bool) -> URL? {
        //Go to Download
        guard let downloadFolderURL = try? FileManager.default.url(for: .downloadsDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        else {
            print("Can't access to Document folder")
            return nil
        }
        
        // 2 Go to specific app
        var url: URL
        switch location {
        case .exerciseJSON:
            url = downloadFolderURL.appendingPathComponent("FitApp/Exercises", isDirectory: true)
        case .exerciseImage:
            url = downloadFolderURL.appendingPathComponent("FitApp/Exercises/Image", isDirectory: true)
        case .exerciseVideo:
            url = downloadFolderURL.appendingPathComponent("FitApp/Exercises/Video", isDirectory: true)
        
        case .workoutJSON:
            url = downloadFolderURL.appendingPathComponent("FitApp/Workouts", isDirectory: true)
        case .workoutImage:
            url = downloadFolderURL.appendingPathComponent("FitApp/Workouts/Image", isDirectory: true)
        case .workoutVideo:
            url = downloadFolderURL.appendingPathComponent("FitApp/Workouts/Video", isDirectory: true)
        case .seriaJSON:
            url = downloadFolderURL.appendingPathComponent("FitApp/Program", isDirectory: true)
        case .seriaImage:
            url = downloadFolderURL.appendingPathComponent("FitApp/Program/Image", isDirectory: true)
        case .seriaVideo:
            url = downloadFolderURL.appendingPathComponent("FitApp/Program/Video", isDirectory: true)
        }
        
        if create,!FileManager.default.fileExists(atPath: url.path){
            do {
                try FileManager.default.createDirectory(at: url,withIntermediateDirectories: true, attributes: nil)
                
            } catch {
                print("Can't create folder")
                return nil
            }
        }
        
        
        if let name = fileName, let type = fileType {
            url.appendPathComponent(name)
            url.appendPathExtension(type)
        }
        
        return url
    }
}



enum MyLocation {
    case exerciseJSON
    case exerciseImage
    case exerciseVideo
    
    case workoutJSON
    case workoutImage
    case workoutVideo
    
    case seriaJSON
    case seriaImage
    case seriaVideo
}
