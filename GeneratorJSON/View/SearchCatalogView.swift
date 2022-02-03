//
//  SearchCatalogView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 29.01.2022.
//

import SwiftUI
//
struct SearchCatalogView<Item: CatalogItem & HasProperties>: View {

    @ObservedObject var searchManager: SearchManager<Item>
    var title: String?
    var onSelect: (Item)->() = {_ in}
    
    @State var sortedBy: SortedType = .byName
    
    enum SortedType {
        case byName, byMuscle
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            //TITLE
            if let title = title {
                HStack{
                    Spacer()
                Text(title)
                    .foregroundColor(.white)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .textCase(.uppercase)
                    Spacer()
                }
            }
            
            //Search
            
            //SORTED BUTTONS
            HStack(spacing: 20){
                sortedButton(name: "by name", by: .byName)
                sortedButton(name: "by muscle", by: .byMuscle)
            }
            
            //RESULT
            //1. SORTED BY NAMES
            if sortedBy == .byName {
                VStack(spacing: 10){
                    ForEach(searchManager.visibleItems.sorted(by: {$0.name > $1.name}), id: \.id){item in
                        CatalogItemView(item: item)
                            .onTapGesture {
                                onSelect(item)
                            }
                    }
                }
                //2. GROUPED BY MUSCLE
            } else {
                VStack(spacing: 30){
                    ForEach(MuscleType.allCases, id: \.id){muscle in
                        VStack(spacing: 10){
                            Text("\(muscle.str)")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.7))
                                .fontWeight(.semibold)
                                .textCase(.uppercase)
                            
                            ForEach(getItemsFor(muscle), id: \.id){item in
                                CatalogItemView(item: item)
                                    .onTapGesture {
                                        onSelect(item)
                                    }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    private func sortedButton(name: String, by: SortedType) -> some View{
        Button {
            withAnimation{
                self.sortedBy = by
            }
        } label: {
            Text(name)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.7))
        }
    }
    
    private func getItemsFor(_ muscle: MuscleType)->[Item]{
        searchManager.visibleItems
            .filter({$0.properties
                .contains(where: {$0.id == muscle.id})})
    }
}

