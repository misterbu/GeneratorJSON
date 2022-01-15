//
//  PropertyChoser.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 01.10.2021.
//

import SwiftUI

struct PropertyChoser<Type: StrChooseble>: View {
    
    var name: String
    @Binding var select: Type
    
    var body: some View {
        VStack(spacing: 8){
            Text(name)
                .foregroundColor(.white)
            Divider()
                .padding(.horizontal)
                .frame(width: 100)
            
            ForEach(Type.allCased, id:\.self){item in
                Button {
                    select = .init(strValue: item)
                } label: {
                    Text(item.uppercased())
                        .font(.body)
                        .fontWeight(item == select.str ? .semibold : .regular)
                        .foregroundColor(item == select.str ? .white : .white.opacity(0.5))
                }.buttonStyle(PlainButtonStyle())

            }
        }
    }
}

struct PropertyChoser_Previews: PreviewProvider {
    static var previews: some View {
        PropertyChoser(name: "Type", select: .constant(MuscleType.legs))
            .padding()
            .background(Color.black)
    }
}
