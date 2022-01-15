//
//  DefaultUsers.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 01.10.2021.
//

import Foundation

extension UserDefaults {
    enum Names: String {
        case showStrenghtExercises = "showStrenhtExercises"
        case showHiitExercises = "showHiitExercises"
    }
    
    static var showStrenhtExercises: Bool {
        set{
            UserDefaults.standard.set(newValue, forKey: Names.showStrenghtExercises.rawValue)
        }
        get{
            UserDefaults.standard.bool(forKey: Names.showStrenghtExercises.rawValue)
        }
    }
    
    static var showHiitExercises: Bool {
        set{
            UserDefaults.standard.set(newValue, forKey: Names.showHiitExercises.rawValue)
        }
        get{
            UserDefaults.standard.bool(forKey: Names.showHiitExercises.rawValue)
        }
    }
}

