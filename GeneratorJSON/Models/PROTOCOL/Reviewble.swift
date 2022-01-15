//
//  Reviewble.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 02.10.2021.
//

import Foundation
import AppKit

protocol Reviewble {
    var id: String {get set}
    var name: String {get}
    var image: NSImage? {get}
    var type: WorkType {get}
}
