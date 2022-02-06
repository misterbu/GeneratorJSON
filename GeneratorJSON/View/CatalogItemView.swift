//
//  CatalogItemView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 26.01.2022.
//

import SwiftUI


struct CatalogItemView<Item: CatalogTitle & HasProperties>: View {
    var item: Item
    var colorTitle: Color = .primary
    var fontTitle: Font = .title
    var position: PositionType = .horizontal
    var properties: [Property]? = nil
   
    enum PositionType {
        case horizontal, vertical
    }
    
    var body: some View {
        ZStack{
            //For horizontal type
            if position == .horizontal {
                HStack(spacing: 20){
                    itemImage
                    itemTitle
                    Spacer(minLength: 30)
                }
            //For vertical
            } else {
                VStack(spacing: 5){
                    itemImage
                    itemTitle
                }
            }
        }
        .contentShape(Rectangle())
        .padding(5)
        .cornerRadius(10)
    }
    
    var itemImage: some View {
        
        Image(nsImage: item.image ?? NSImage(named: "bgImage")!)
            .resizable()
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(item.type == .hiit ? Color.orange : Color.blue,
                                lineWidth: 3))
            .padding(5)
    }
    
    var itemTitle: some View {
        VStack(alignment: .leading){
            Text(item.name)
                .lineLimit(2)
                .font(fontTitle)
                .foregroundColor(colorTitle)
                .frame(maxWidth: 250, alignment: .leading)
            
            //Show property name when we searched item by this property
            if let properties = properties, properties.count > 0 {
                HStack(spacing: 5){
                    ForEach(properties.prefix(2), id:\.id){property in
                        Text("#\(property.str)")
                            .font(.system(size: 9, weight: .medium))
                            .foregroundColor(Color.white.opacity(0.7))
                            .textCase(.uppercase)
                    }
                }
            }
        }
    }
    

}

