//
//  MultiCaseChooseView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 28.03.2021.
//

import SwiftUI

struct MultiCaseChoseView: View {
    
    var name: String
    @Binding var selected: [Int]
    var multiChoose: Bool = false
    var array: [String]
    
    var body: some View {
        VStack{
            Text(name)
                .font(.body)
                .foregroundColor(Color.black.opacity(0.6))
                .padding(.bottom, 20)
            
            ForEach(0..<array.count, id: \.self){index in
                VStack(spacing: 50) {
                    Text(array[index])
                        .font(.body)
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(selected.contains(index) ? Color.black.opacity(0.2) : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                        .onTapGesture {
                            if selected.contains(index) {
                                selected.removeAll(where: {$0 == index})
                            } else  {
                                if !multiChoose {
                                    selected.removeAll()
                                }
                                selected.append(index)
                            }
                        }
                }
            }
        }
    }
}
