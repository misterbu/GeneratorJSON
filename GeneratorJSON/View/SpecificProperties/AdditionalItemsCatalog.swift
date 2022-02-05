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
            Text("Search")
                .foregroundColor(.white.opacity(0.5))
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.1))
                .clipShape(Capsule())
            
            
            //Workouts
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 5){
                    ForEach(searchManager.visibleItems, id: \.id){item in
                        CatalogItemView(item: item,
                                        colorTitle: .white.opacity(0.8),
                                        fontTitle: .title2,
                                        position: .horizontal)
                            .onTapGesture {
                                onSelect(item)
                            }
                    }
                    
                }
            }
        }
        
    }
}

struct AdditionalCatalogItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.black
            
            AdditionalItemsCatalog(searchManager: SearchManager([Workout.sample,
                                                                                   Workout.sample2,
                                                                                   Workout.sample]),
                                                     title: "To Tuesday",
                                                     subtitle: "Select workout for",
                                                     onSelect: {_ in},
                                                     onClose: {})
                .padding()
        }
    }
}
