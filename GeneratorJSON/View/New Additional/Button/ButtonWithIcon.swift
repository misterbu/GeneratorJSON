//
//  ButtonWIthIcon.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 02.10.2021.
//

import SwiftUI

struct ButtonWithIcon: View {
    
    var name: String
    var icon: String
    var font: Font = .body
    var contentColor: Color
    var bgColor: Color
    var horizontalPadding: CGFloat
    var verticalPadding: CGFloat 
    var onTap:()->()
    
    init(name: String,
         icon: String,
         type: TypeButton,
         contentColor: Color = .black.opacity(0.8),
         bgColor: Color = .white.opacity(0.4),
         onTap: @escaping ()->()){
        self.name = name
        self.icon = icon
        self.contentColor = contentColor
        self.bgColor = bgColor
        self.font = type == .small ? .body : .title
        self.horizontalPadding = type == .small ? 10 : 15
        self.verticalPadding = type == .small ? 5 : 10
        self.onTap = onTap
    }
    
    init(name: String,
         icon: String,
         font: Font = .body,
         contentColor: Color = .black.opacity(0.8),
         bgColor: Color = .white.opacity(0.4),
         horizontalPadding: CGFloat = 10,
         verticalPadding: CGFloat = 5,
         onTap: @escaping ()->()){
        self.name = name
        self.icon = icon
        self.contentColor = contentColor
        self.bgColor = bgColor
        self.font = font
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.onTap = onTap
        
    }
    
    
    enum TypeButton {
        case small, big
    }
    
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 5){
                Image(systemName: icon)
                Text(name.uppercased())
            }
            .font(font)
            .foregroundColor(contentColor)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(bgColor)
            .cornerRadius(5)
            .shadow(color: bgColor.opacity(0.4), radius: 3, x: 2, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


