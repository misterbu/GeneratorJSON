//
//  NSTextView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 01.10.2021.
//

import Foundation
import AppKit

extension NSTextView {
    open override var frame: CGRect {
        didSet {
            backgroundColor = .clear //<<here clear
            drawsBackground = true
        }
        
    }
}
