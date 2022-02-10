//
//  CircleType.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 25.06.2021.
//
//
//import Foundation
//
//enum CircleType: Int, CaseIterable {
//    case warmUp = 0
//    case main = 1
//    case coolDown = 2
//    
//    init(strValue: String){
//        switch strValue {
//        case "Warm Up":
//            self = .warmUp
//        case "Main":
//            self = .main
//        case "Cool Down":
//            self = .coolDown
//        default:
//            self = .main
//        }
//    }
//    
//    var str: String {
//        switch self {
//        case .warmUp:
//            return "Warm Up"
//        case .main:
//            return "Main"
//        case .coolDown:
//            return "Cool Down"
//        }
//    }
//    
//    static var allCased: [String] {
//        CircleType.allCases.map({$0.str})
//    }
//}
