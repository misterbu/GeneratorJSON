//
//  JSONble.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 28.01.2022.
//

import Foundation
import SwiftyJSON

protocol JSONble {
    func getForJSON()->JSON
    static var jsonType: JSONType {get}
}
