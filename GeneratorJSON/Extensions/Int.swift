//
//  Int.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import Foundation

extension Int {
    var int32: Int32 {
        Int32(self)
    }
}


extension Int32 {
    var int: Int {
        Int(self)
    }
}


extension Optional where Wrapped == Int32 {
    var int: Int {
        return  Int(self ?? 0)
    }
}
