//
//  Exercise.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import SwiftUI


protocol Exercise {
    var id: String {get set}
    var orderAdd: Int {get set}
    
    var iconImage: NSImage? {get set}
    var image: NSImage? {get set}
    var video: String? {get set}
    
    var name: String {get set}
    var shortDescription: String {get set}
    var description: String {get set}
    var voiceComment: String {get set}
    
    var level: LevelType {get set}
    var type: WorkType  {get set}
    var muscle: [String] {get set}
    
    var authorId: String? {get set}
    var isPro: Bool {get set}
    
    mutating func setProperied(values: [String : Any])
}


