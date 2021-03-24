//
//  ExercisesCatalogView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import SwiftUI

struct ExercisesCatalogView: View {
    
    @EnvironmentObject var exercisesVM: ExercisesViewModel
    
    var row = Array(repeating: GridItem(.flexible(), spacing: 15, alignment: .center), count: 5)
    
    var body: some View {
        VStack{
            ScrollView{
                
                HStack{
                    Button(action:{
                        
                    }){
                        HStack{
                            Image(systemName: "plus.square")
                                .font(.title)
                                .foregroundColor(.black)
                            
                            Text("Create new")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                }
                
                LazyVGrid(columns: row, content: {
                    ForEach(exercisesVM.exercises, id: \.id){exercise in
                        ExercisesCatalogItemView(exercise: exercise)
                            .frame(maxWidth: .infinity, maxHeight: 100)
                    }
                })
            }
        }
        .padding()
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
