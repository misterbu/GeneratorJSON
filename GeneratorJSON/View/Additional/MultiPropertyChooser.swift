//
//  MultiPropertyChooser.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 01.10.2021.
//

import SwiftUI

struct MultiPropertyChoser<Type: StrChooseble>: View {
    
    var name: String
    @Binding var selects: [Type]
    
    var body: some View {
        VStack(spacing: 8){
            Text(name)
                .foregroundColor(.white)
            Divider()
                .padding(.horizontal)
                .frame(width: 100)
            
            ForEach(Type.allCased, id:\.self){item in
                Button {
                    if isItemSelected(item) {
                        selects.removeAll(where: {$0.str == item})
                    } else {
                        selects.append(Type.init(strValue: item))
                    }
                } label: {
                    Text(item.uppercased())
                        .font(.body)
                        .fontWeight(isItemSelected(item) ? .semibold : .regular)
                        .foregroundColor(isItemSelected(item) ? .white : .white.opacity(0.5))
                }.buttonStyle(PlainButtonStyle())

            }
        }
    }
    
    func isItemSelected(_ item: String) -> Bool {
        self.selects.contains(where: {$0.str == item})
    }
}

struct MultiPropertyChoser_Previews: PreviewProvider {
    static var previews: some View {
        MultiPropertyChoser(name: "Type", selects: .constant([MuscleType.legs]))
            .padding()
            .background(Color.black)
    }
}

