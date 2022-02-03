//
//  CatalogItemView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 26.01.2022.
//

import SwiftUI


struct CatalogItemView<Item: CatalogTitle>: View {
    var item: Item
    
    var body: some View {
        HStack(spacing: 20){
            if let image = item.image {
                Image(nsImage: image)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(item.type == .hiit ? Color.orange : Color.blue,
                                        lineWidth: 3))
                    .padding(5)
                    
            }
            
            Text(item.name)
                .lineLimit(2)
                .font(.title)
                .foregroundColor(.primary)
                .frame(maxWidth: 250, alignment: .leading)
            
            Spacer(minLength: 30)
        }
        .contentShape(Rectangle())
        .padding(5)
        .cornerRadius(10)
    }
}
