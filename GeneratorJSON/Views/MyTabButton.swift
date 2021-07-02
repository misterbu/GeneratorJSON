//
//  MyTabButton.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 25.06.2021.
//

import SwiftUI

struct MyTabButton: View {
    
    var image: String
    var title: String
    @Binding var selectedButton: String
    
    var body: some View {
        Button(action: {
            withAnimation{selectedButton = title}
        }, label: {
            VStack{
                Image(systemName: image)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(selectedButton == title ? .primary : .gray)
                Text(title)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(selectedButton == title ? .primary : .gray)
            }
            .padding(.vertical, 8)
            .frame(width: 70)
            .background(Color.primary.opacity(selectedButton == title ? 0.15 : 0))
            .cornerRadius(10)
            .contentShape(Rectangle())
        })
        .buttonStyle(PlainButtonStyle())
    }
}


