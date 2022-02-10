//
//  WorkoutProgramPropertyWorkoutCatalogView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 03.02.2022.
//

import SwiftUI

struct AdditionalItemsCatalog<Item: HasProperties & CatalogTitle>: View {
    @ObservedObject var searchManager: SearchManager<Item>
    var title: String?
    var subtitle: String?
    var onSelect: (Item)->()
    var onClose: ()->()
    
    @FocusState var searchFocused: Bool
   
    @State var sortedType: SortedType = .byName

    enum SortedType {
        case byName, byMuscle
        var name: String {
            switch self {
            case .byName: return "by name"
            case .byMuscle: return "by muscle"
            }
        }
    }
    
    init(searchManager: SearchManager<Item>,
         title: String?,
         subtitle: String?,
         onSelect: @escaping (Item)->(),
         onClose: @escaping ()->()){
        self.onSelect = onSelect
        self.onClose = onClose
        self.searchManager = searchManager
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack(spacing: 15){
            
            CloseButton(color: .white, font: .title) {
                onClose()
            }
            
            //Title
            HStack{
                Spacer()
                VStack{
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .textCase(.uppercase)
                    }
                    if let title = title {
                        Text(title)
                            .font(.title)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .textCase(.uppercase)
                    }
                }
                Spacer()
            }
            
            //Search bar
            SearchBarView(search: $searchManager.search,
                          focusedSearchField: $searchFocused,
                          onResetSearch: {searchManager.searchReset()})
                .frame(maxWidth: .infinity, alignment: .leading)
            
            //Buttons for sorted items
            HStack(spacing: 20){
                Spacer()
                sortedButton(for: .byName)
                sortedButton(for: .byMuscle)
            }
            
            //Workouts
            ScrollView(.vertical, showsIndicators: false) {
                //SORTED BY NAME
                if sortedType == .byName{
                    VStack(spacing: 5){
                        ForEach(searchManager.visibleItems.sorted(by: {$0.name > $1.name}), id: \.id){item in
                            CatalogItemView(item: item,
                                            colorTitle: .white.opacity(0.8),
                                            fontTitle: .title2,
                                            position: .horizontal,
                                            properties: searchManager.searchedProperties .filter({ property in
                                                                        item.properties
                                                                            .contains(where: {$0.id == property.id})}))
                                .onTapGesture {
                                    onSelect(item)
                                }
                        }
                        
                    }
                }
                //SORTED BY MUSCLE
                else {
                    VStack(alignment: .leading, spacing: 40){
                        ForEach(MuscleType.allCases, id: \.id){muscle in
                            if getItems(for: muscle).count > 0 {
                                VStack(alignment: .leading, spacing: 5){
                                    Text(muscle.str)
                                        .font(.body)
                                        .foregroundColor(.white.opacity(0.4))
                                        .textCase(.uppercase)
                                    
                                    ForEach(getItems(for: muscle), id: \.id){item in
                                        CatalogItemView(item: item,
                                                        colorTitle: .white.opacity(0.8),
                                                        fontTitle: .title2,
                                                        position: .horizontal,
                                                        properties: searchManager.searchedProperties.filter({ property in
                                                                                    item.properties
                                                                                        .contains(where: {$0.id == property.id})}))
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
        }
    }
    
    private func sortedButton(for type: SortedType) -> some View {
        Button {
            withAnimation{sortedType = type}
        } label: {
            Text(type.name)
                .font(.callout)
                .foregroundColor(type == sortedType ? .white : .white.opacity(0.6))
        }
    }
    
    private func getItems(for muscle: MuscleType) -> [Item]{
        searchManager.visibleItems
                    .filter({$0.properties.contains(where: {$0.id == muscle.id})})
    }
}

struct AdditionalCatalogItemsView_Previews: PreviewProvider {
    struct Test: View {
        @Namespace var ns
        
        var body: some View{ ZStack{
            Color.black
            
            AdditionalItemsCatalog(searchManager: SearchManager([Workout.sample,
                                                                 Workout.sample2,
                                                                 Workout.sample]),
                                   title: "To Tuesday",
                                   subtitle: "Select workout for",
                                   onSelect: {_ in},
                                   onClose: {})
                .buttonStyle(PlainButtonStyle())
                .padding()
        }
            
        }
    }
    static var previews: some View {
       Test()
    }
}
