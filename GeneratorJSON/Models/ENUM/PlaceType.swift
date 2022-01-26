//
//  PlaceType.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 21.10.2021.
//

import Foundation

enum PlaceType: Int, CaseIterable, StrChooseble , Property{
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
    
    init(strValue: String){
        switch strValue {
        case "Home":
            self = .home
        case "Gym":
            self = .gym
        case "Outdoor":
            self = .outdoor
        default:
            self = .home
        }
    }
    
    static var allCased: [String]{
        return PlaceType.allCases.map({$0.str})
    }
}
