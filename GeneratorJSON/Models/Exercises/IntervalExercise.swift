//
//  IntervalExercise.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import SwiftUI

struct IntervalExercise: Exercise {
    /// - TAG: Protocol's vars
    var id: String = UUID().uuidString
    
    var iconImage: NSImage?
    var image: NSImage?
    var video: String?
    
    var name: String = ""
    var shortDescription: String?
    var description: String = ""
    var voiceComment: String?
    
    var level: LevelType = .all
    var type: WorkType = .combine
    var muscle: [String] = []
    
    var authorId: String?
    
    var isPro: Bool = false
    
    /// - TAG: Ourself vars
    var duration: Int
    var restDuration: Int?

}
