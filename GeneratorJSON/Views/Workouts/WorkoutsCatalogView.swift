//
//  WorkoutsCatalogView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 25.03.2021.
//

import SwiftUI

struct WorkoutsCatalogView: View {
    
    @EnvironmentObject var workoutsVM: WorkoutsViewModel
    @State var showCreate: Bool = false
    
    private let row = Array(repeating: GridItem(.flexible(), spacing: 15, alignment: .center), count: 5)
    
    var body: some View {
        VStack{
            ScrollView{
                
                HStack{
                    //Create new exercise
                    createIntervalButton
                    
                }
                
                LazyVGrid(columns: row, content: {
                    ForEach(workoutsVM.workouts, id: \.id){workout in
                        WorktouCatalogItemView(workout: workout)
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .onTapGesture {
                                workoutsVM.workout = workout
                                showCreate.toggle()
                            }
                    }
                })
            }
        }
        .padding()
        .sheet(isPresented: $showCreate, content: {
            CreateWorkoutView(workoutVM: WorkoutViewModel(workoutsVM.workout!), close: $showCreate)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        })
        
    }
    
    
    var createIntervalButton: some View {
        Button(action:{
            workoutsVM.workout = Workout()
            showCreate.toggle()
        }){
            HStack{
                Image(systemName: "plus.square")
                    .font(.title)
                    .foregroundColor(.black)
                
                Text("WORKOUT NEW")
                    .font(.title)
                    .foregroundColor(.black)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct WorkoutsCatalogView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsCatalogView()
    }
}




struct WorktouCatalogItemView: View {
    var workout: Workout
    
    var body: some View {
        ZStack(alignment: .center) {
            Image(nsImage: workout.iconImage ?? NSImage(named: "ph")!)
                .resizable()
                .scaledToFill()
            
            Color.black.opacity(0.4)
            
            Text(workout.name)
                .font(.title)
                .foregroundColor(.white)
        }
    }
}
