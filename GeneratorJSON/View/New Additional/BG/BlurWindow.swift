//
//  BlurWindow.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 01.10.2021.
//

import SwiftUI

struct BlurWindow: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let wind = NSVisualEffectView()
        wind.blendingMode = .behindWindow
        return wind
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        
    }
}
