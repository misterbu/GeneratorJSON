//
//  CatalogContainer.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 26.01.2022.
//

import SwiftUI

struct CatalogContainer<Item: CatalogItem>: View {
    
    var items: [Item]
    @State var selectedItem: Item?
    
    init(items: [Item]){
        self.items = items
        self._selectedItem = .init(initialValue: items.first ?? nil)
    }
    
    var body: some View {
        HStack{
            //CatalogView
            CatalogView(items: items, selectedItem: $selectedItem)
                .frame(width: 350)
                .background(BlurWindow())
            
            //DetailViewOfCatalogItem
            if let item = selectedItem {
                DetailItemView(item: .init(get: {item},
                                           set: {self.selectedItem = $0}))
            } else {
                //Отображаем страницу предлагающую создать первый элемент
            }
        }
    }
}


