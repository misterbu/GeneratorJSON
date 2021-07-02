//
//  DetailWorkoutCircleView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 28.06.2021.
//

import SwiftUI

struct DetailWorkoutCircleView: View {
    
//    @ObservedObject var workoutViewModel: MyWorkoutViewModel
    @Binding var circle: WorkoutCircle
    @State var showCatalog: Bool = false
   
    @State var selectedExercise: Exercise? = nil
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    //  TextField("Name", text: $viewModel.circle.name)
                    TextField("Name", text: $circle.name)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                    
                    Spacer(minLength: 20)
                    
                    Picker(selection: $circle.type, label: Text("Picker"), content: {
                        ForEach(CircleType.allCases, id:\.self){type in
                            Text(type.str)
                                .tag(type)
                        }
                    })
                    
                }
                
                HStack{
                    showCatalogButton
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            ForEach(circle.exercises, id:\.id){exercise in
                                ShortExerciseView(exercise: exercise)
                                    .padding(10)
                                    .overlay(deleteExerciseButton(exercice: exercise), alignment: .topTrailing)
                                    .onTapGesture {
                                        selectedExercise = exercise
                                    }
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.3))
            .cornerRadius(20)
            .sheet(isPresented: $showCatalog) {
                AddExerciseCatalogView(viewModel: AddExerciseCatalogViewModel(), circle: $circle, show: $showCatalog)
            }
            
            //Сввойства упражнения
            if let exercise = selectedExercise as? IntervalExercise {
                IntervalExercisePropertyView(viewModel: IntervalExercisePropertyViewModel(exercise: exercise), circle: $circle, selectedExercise: $selectedExercise)
            } else if let exersice = selectedExercise as? StrenghtExercise {
                StrenghtExercisePropertyView(viewModel: StrenghtExercisePropertyViewModel(exercise: exersice), circle: $circle, selectedExercise: $selectedExercise)
            }
        }
   
    }
    
    var showCatalogButton: some View {
        Button {
            withAnimation{ showCatalog.toggle() }
        } label: {
            Image(systemName: "plus.circle")
                .resizable()
                .frame(width: 40, height: 40)
        }.buttonStyle(PlainButtonStyle())

    }
    
    func deleteExerciseButton(exercice: Exercise) -> some View {
        Button {
            withAnimation{ circle.exercises.removeAll(where: {$0.id == exercice.id}) }
            
        } label: {
            Image(systemName: "xmark")
                .font(.callout)
                .foregroundColor(.primary)
        }.buttonStyle(PlainButtonStyle())

    }
}




