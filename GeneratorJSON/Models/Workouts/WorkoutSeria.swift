//
//  WorkoutSeria.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import SwiftUI

struct WorkoutSeria {
    var id: String = UUID().uuidString
    var createAt: Date = Date()
    
    var iconImage: NSImage?
    var image: NSImage?
    var video: String?
    
    var name: String = ""
    var shortDescription: String?
    var description: String = ""
    var workouts: [Workout] = []
    var restDuration: Int?
    
    var level: LevelType = .all
    var type: WorkType = .combine
    var sex: SexType = .unisex
    var target: [TargetType] = []
    var equipment: [EquipmentType] = []
    
    var authorId: String?
}
