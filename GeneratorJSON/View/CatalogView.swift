//
//  CatalogView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 26.01.2022.
//

import SwiftUI

struct CatalogView<Item: CatalogTitleItem>: View {
    var items: [Item]
    @Binding var selectedItem: Item?
    
    var body: some View {
        VStack{
            //ДОБАВИТЬ ТРЕНИРОВКУ
            addButton
            
            //ОТОБРАЖАТЬ ТОЛЬКО СИЛОВЫЕ ИЛИ ИНТЕРВАЛЬНЫЕ ТРЕНИРОВКИ ИЛИ И ТО И ТО
            HStack(spacing: 20){
//                showStrenghtButton
//                showHiitButton
            }.padding(.bottom, 20)
            
            //ЭЛЕМЕНТЫ КАТАЛОГА
            VStack(spacing: 0){
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(items, id:\.id) {item in
                        CatalogItemView(item: item)
                            .background(Color.black.opacity(isSelected(item.id) ? 0.2 : 0))
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation{self.selectedItem = item}
                            }
                    }
                }
            }
        }
        
        
    }
    
    private var addButton: some View {
        Button {
          
        } label: {
            HStack(spacing: 5){
                Spacer()
                Image(systemName: "plus")
                Text("Add workout".uppercased())
                Spacer()
            }
            .font(.body)
            .foregroundColor(.white.opacity(0.6))
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(Color.black.opacity(0.2))
            .cornerRadius(5)
        }.buttonStyle(PlainButtonStyle())

    }
    
    private func isSelected(_ itemID: String) -> Bool {
        guard let selectedItem = selectedItem else {
            return false
        }
        
        return selectedItem.id == itemID
    }
}
