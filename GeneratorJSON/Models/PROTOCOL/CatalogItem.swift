//
//  CatalogItem.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 26.01.2022.
//

import Foundation
import SwiftUI

typealias CatalogItem = CatalogTitle & CatalogDetail

protocol CatalogTitle {
    var id: String {get}
    var name: String {get}
    var image: NSImage? {get}
    var type: WorkType {get}
    
    init()
}


protocol CatalogDetail {
    var id: String {get}
    
    var iconImage: NSImage? {get set}
    var image: NSImage? {get set}
    var video: String? {get set}
    
    var name_en: String  {get set}
    var shortDescription_en: String {get set}
    var description_en: String {get set}
    
    var name_ru: String  {get set}
    var description_ru: String {get set}
    var shortDescription_ru: String {get set}
    
    var isPro: Bool {get set}
}
