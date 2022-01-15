//
//  CloseButton.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 03.10.2021.
//

import SwiftUI

struct CloseButton: View {
    
    var onTap: ()->()
    var color: Color = .white
    var font: Font = .title2
    
    var body: some View {
        Button {
            onTap()
        } label: {
            Image(systemName: "xmark")
                .font(font)
                .foregroundColor(color)
                .padding(5)
                .contentShape(Circle())
                
        }.buttonStyle(PlainButtonStyle())
    }
}

