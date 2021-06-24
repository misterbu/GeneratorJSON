//
//  Exercise.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import SwiftUI


protocol Exercise {
    var id: String {get set}
    var basic: BasicExercise {get set}
    var orderAdd: Int {get set}
    
    mutating func setProperied(values: [String : Any])
    
    func getForJSON() -> [String: Any]
}


