//
//  WorkoutProgramPropertyWorkoutCatalogView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 03.02.2022.
//

import SwiftUI

struct WorkoutProgramPropertyWorkoutCatalogView<Item: CatalogTitle & HasProperties>: View {
    
    @ObservedObject var searchManager: SearchManager<Item>
    
    var body: some View {
        VStack{
            //Title
            HStack{
                Text("Select workout for added")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.6))
                Spacer()
            }
            
            //Workouts
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10){
                    ForEach(searchManager.visibleItems, id: \.id){item in
                        CatalogItemView(item: item,
                                        colorTitle: .white,
                                        fontTitle: .title3,
                                        position: .vertical)
                    }
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.15))
        .cornerRadius(15)
    }
}

struct WorkoutProgramPropertyWorkoutCatalogView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.black
            
            WorkoutProgramPropertyWorkoutCatalogView(searchManager: SearchManager([Workout.sample, Workout.sample2, Workout.sample]))
                .padding()
        }
    }
}
