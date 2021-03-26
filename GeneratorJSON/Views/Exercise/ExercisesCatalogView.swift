//
//  ExercisesCatalogView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import SwiftUI

struct ExercisesCatalogView: View {
    
    @EnvironmentObject var exercisesVM: ExercisesViewModel
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
                    ForEach(exercisesVM.exercises, id: \.id){exercise in
                        ExercisesCatalogItemView(exercise: exercise)
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .onTapGesture {
                                exercisesVM.exercise = exercise
                                showCreate.toggle()
                            }
                    }
                })
            }
        }
        .sheet(isPresented: $showCreate, content: {
            CreateExerciseView(exerciseVM: ExerciseViewModel(exercisesVM.exercise as! Exercise), close: $showCreate)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        })
        .padding()
    }
    
    
    var createIntervalButton: some View {
        Button(action:{
            exercisesVM.exercise = IntervalExercise()
            showCreate.toggle()
        }){
            HStack{
                Image(systemName: "plus.square")
                    .font(.title)
                    .foregroundColor(.black)
                
                Text("INTERVAL NEW")
                    .font(.title)
                    .foregroundColor(.black)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ExercisesCatalogView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesCatalogView()
    }
}



struct ExercisesCatalogItemView: View {
    var exercise: Exercise
    
    var body: some View {
        ZStack(alignment: .center) {
            Image(nsImage: exercise.iconImage ?? NSImage(named: "ph")!)
                .resizable()
                .scaledToFill()
            
            Color.black.opacity(0.4)
            
            Text(exercise.name)
                .font(.title)
                .foregroundColor(.white)
        }
    }
}
