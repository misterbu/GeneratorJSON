//
//  StrChooseble.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 01.10.2021.
//

import SwiftUI

protocol StrChooseble{
    var str: String {get}
    static var allCased: [String] {get}
    init(strValue: String)
}
