//
//  IconButton.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 11.10.2021.
//

import SwiftUI

struct IconButton: View {
    
    var icon: String
    var font: Font = .body
    var iconColor: Color = .black.opacity(0.8)
    var bgColor: Color = .white.opacity(0.4)
    var padding: CGFloat = 4
    var onTap:()->()
    
    var body: some View {
        Button {
            onTap()
        } label: {
            Image(systemName: icon)
                .font(font)
                .foregroundColor(iconColor)
                .padding(padding)
                .padding(padding)
                .background(bgColor)
                .cornerRadius(5)
                .shadow(color:.white.opacity(0.1), radius: 3, x: 2, y: 2)
                .contentShape(RoundedRectangle(cornerRadius: 5))
        }
        .buttonStyle(PlainButtonStyle())
    }
}


