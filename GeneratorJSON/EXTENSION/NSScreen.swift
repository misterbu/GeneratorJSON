//
//  NSScreen.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 01.10.2021.
//

import SwiftUI

extension NSScreen {
    static var width: CGFloat {self.main?.visibleFrame.width ?? 0}
    static var height: CGFloat{self.main?.visibleFrame.height ?? 0}
}
