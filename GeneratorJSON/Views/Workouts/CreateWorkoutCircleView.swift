//
//  CreateWorkoutCircleView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 26.03.2021.
//

import SwiftUI

struct CreateWorkoutCircleView: View {
    @ObservedObject var circleVM: WorkoutCircleViewModel
    var type: WorkType
    
    var body: some View{
        
        VStack {
            
            //Name and CanGetOff
            HStack(spacing: 30){
                TextField("Name", text: $circleVM.workoutCircle.name)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(5)
                
                Spacer()
                    
                
                //Can GetOff
                Text("CanGetOff")
                    .font(.body)
                    .foregroundColor(.black)
                    .padding(.trailing, 10)
                
                Button(action:{
                    circleVM.workoutCircle.canGetOff.toggle()
                }){
                    Image(systemName:  circleVM.workoutCircle.canGetOff ? "circle.fill" : "circle")
                        .font(.title)
                        .foregroundColor(.black)
                }.buttonStyle(PlainButtonStyle())
            }
            
            
            //Exercises
            VStack{
                if type == .hiit {
                    ForEach(0..<circleVM.intervalsExercises.count, id: \.self){index in
                        CreateIntervalExerciveCircleView(viewModel: circleVM.intervalsExercises[index])
                    }
                } else if type == .strenght {
                    ForEach(0..<circleVM.strenghtExercises.count, id: \.self){index in
                        CreateStrenghtExerciveCircleView(viewModel: circleVM.strenghtExercises[index])
                    }
                }
            }
            
            //Button
            HStack(spacing: 20){
                Button(action:{
                    circleVM.showCatalog(type)
                }){
                    HStack(spacing: 5){
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                            .font(.body)
                        Text("ADD EXERCISE")
                    }
                    .padding(5)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1))
                    
                }.buttonStyle(PlainButtonStyle())
                
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack{
//                        ForEach(circleVM.workoutCircle.exercises, id: \.id){exercise in
//                            ZStack{
//                                Image(nsImage: exercise.basic.iconImage ?? NSImage(named: "ph")!)
//                                    .resizable()
//                                    .scaledToFill()
//                                
//                                Color.black.opacity(0.4)
//                                
//                                Text(exercise.basic.name)
//                                    .font(.body)
//                                    .foregroundColor(.white)
//                            }
//                            .frame(width: 150, height: 110)
//                            .clipShape(RoundedRectangle(cornerRadius: 5))
//                        }
//                    }
//                }
            }
        }
        .sheet(isPresented: $circleVM.showExercisesCatalog) {
            ExerciseCatalogForCreateWorkotView(circleVM: circleVM, type: type)
        }
    }
}


struct ExerciseCatalogForCreateWorkotView: View {
    
    @EnvironmentObject var exercisesVM: ExercisesViewModel
    @ObservedObject var circleVM: WorkoutCircleViewModel
    var type: WorkType
    
    private let row = Array(repeating: GridItem(.flexible(), spacing: 15, alignment: .center), count: 5)
    
    var body: some View{
        VStack{
            
            Button(action:{
                circleVM.closeCatalog()
            }){
               Image(systemName: "xmark")
                .font(.title)
                .foregroundColor(.black)
                .contentShape(Circle())
            }
            .buttonStyle(PlainButtonStyle())
            
            LazyVGrid(columns: row, alignment: .center, spacing: 20) {
                ForEach(exercisesVM.getExercises(type)){exercise in
                    VStack {
                        Image(nsImage: exercise.iconImage ?? NSImage(named: "ph")!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipped()
                        Text(exercise.name)
                            .foregroundColor(.black)
                            .font(.body)
                    }
                    .onTapGesture {
                        circleVM.choseExercise(exercise: exercise)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .frame(minWidth: 700, maxWidth: .infinity, minHeight: 700, maxHeight: .infinity)
        .onAppear{
            print(type)
        }
    }
}




