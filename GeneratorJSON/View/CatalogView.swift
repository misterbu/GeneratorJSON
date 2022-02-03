//
//  CatalogView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 26.01.2022.
//

import SwiftUI

struct CatalogView<Item: CatalogTitle & HasProperties>: View {
    @ObservedObject var searchManager: SearchManager<Item>
    @Binding var selectedItem: Item?
    var onAdd: ()->()
    
    init(items: [Item], selectedItem: Binding<Item?>, onAdd: @escaping ()->()){
        self._selectedItem = selectedItem
        self.onAdd = onAdd
        self.searchManager = SearchManager(items)
    }
    
    var body: some View {
        VStack{
            //ДОБАВИТЬ ТРЕНИРОВКУ
            addButton
            
            //ОТОБРАЖАТЬ ТОЛЬКО СИЛОВЫЕ ИЛИ ИНТЕРВАЛЬНЫЕ ТРЕНИРОВКИ ИЛИ И ТО И ТО
            HStack(spacing: 20){
                showStrenghtButton
                showHiitButton
            }.padding(.bottom, 20)
            
            //ЭЛЕМЕНТЫ КАТАЛОГА
            VStack(spacing: 0){
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(searchManager.visibleItems, id:\.id) {item in
                        CatalogItemView(item: item)
                            .background(Color.black.opacity(isSelected(item.id) ? 0.2 : 0))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .onTapGesture {
                                withAnimation{self.selectedItem = item}
                            }
                    }
                }
            }
        }
        .padding()
    }
    
    private var addButton: some View {
        Button {
          onAdd()
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
    
    private var showHiitButton: some View {
        Button {
            searchManager.selectFilter(WorkType.hiit)
        } label: {
            Text("HIIT")
                .foregroundColor(.white)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .frame(width: 150)
                .background(Color.orange.opacity(searchManager.selectedFilters.contains(where: {$0.id == WorkType.hiit.id}) ? 1 : 0.2))
                .cornerRadius(5)

        }
        .buttonStyle(PlainButtonStyle())
    }

    private var showStrenghtButton: some View {
        Button {
            searchManager.selectFilter(WorkType.strenght)
        } label: {
            Text("STRENGHT")
                .foregroundColor(.white)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .frame(width: 150)
                .background(Color.blue.opacity(searchManager.selectedFilters.contains(where: {$0.id == WorkType.strenght.id}) ? 1 : 0.2))
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


struct CatalogView_Preview: PreviewProvider{
    static var previews: some View {
        CatalogContainer(manager: WorkoutsManager())
            .preferredColorScheme(.dark)
    }
}
