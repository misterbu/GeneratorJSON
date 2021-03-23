//
//  ChooseView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 06.03.2021.
//

import SwiftUI


struct ChooseView: View {
    
    var items: [NamedEnums]
    @Binding var close: Bool
    @Binding var selected: Int
    
    var body: some View{
        VStack(spacing: 40){
            Spacer()
            ForEach(0..<items.count, id: \.self) {index in
                HStack{
                    Spacer()
                    Text(items[index].str)
                        .font(.largeTitle)
                        .onTapGesture {
                            selected = index
                            close = false
                        }
                    Spacer()
                }
            }
            Spacer()
        }
    }
}
