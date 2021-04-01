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
                    ForEach(0..<workoutsVM.workouts.count, id: \.self){index in
                        WorktouCatalogItemView(workoutVM: workoutsVM.workouts[index])
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .onTapGesture {
                                workoutsVM.choseWorkout(workoutsVM.workouts[index])
                            }
                    }
                })
            }
        }
        .padding()
        .sheet(item: $workoutsVM.workout) { workout in
            CreateWorkoutView(workoutVM: workout)
        }
        
    }
    
    
    var createIntervalButton: some View {
        Button(action:{
            workoutsVM.createNewWorkout()
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
    var workoutVM: WorkoutViewModel
    
    var body: some View {
        ZStack(alignment: .center) {
            Image(nsImage: workoutVM.workout.image ?? NSImage(named: "ph")!)
                .resizable()
                .scaledToFill()
            
            Color.black.opacity(0.4)
            
            Text(workoutVM.workout.name)
                .font(.title)
                .foregroundColor(.white)
        }
    }
}
