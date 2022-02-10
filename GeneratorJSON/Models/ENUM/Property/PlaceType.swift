//
//  PlaceType.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 21.10.2021.
//

import Foundation

enum PlaceType: Int, CaseIterable, Property{
    case home = 0
    case gym = 1
    case outdoor = 2
    
    var id: String {"PlaceType_\(str)"}
    
    var str : String {
        switch self {
        case .home:
            return "Home"
        case .gym:
            return "Gym"
        case .outdoor:
            return "Outdoor"
        }
    }
    
    var type: PropertyType {.placeType}
    
    static var typeName: String {"Place"}
    static var multiSelect: Bool {false}
    
    static var allCased: [String]{
        return PlaceType.allCases.map({$0.str})
    }
}
