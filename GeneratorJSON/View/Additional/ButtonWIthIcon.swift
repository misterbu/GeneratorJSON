//
//  ButtonWIthIcon.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 02.10.2021.
//

import SwiftUI

struct ButtonWIthIcon: View {
    
    var name: String
    var icon: String
    var isBig: Bool = false
    var onTap:()->()
    
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 5){
                Image(systemName: icon)
                Text(name.uppercased())
            }
            .font(isBig ? .title : .body)
            .foregroundColor(.black.opacity(0.8))
            .padding(.horizontal, isBig ? 15: 10)
            .padding(.vertical, isBig ? 8 : 5)
            .background(Color.white.opacity(0.4))
            .cornerRadius(5)
            .shadow(color: .white.opacity(0.1), radius: 3, x: 2, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


