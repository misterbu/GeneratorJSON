//
//  CreateExerciseView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 24.03.2021.
//

import SwiftUI

struct CreateExerciseView: View {
    
    @EnvironmentObject var exercisesVM: ExercisesViewModel
    @ObservedObject var exerciseVM: CreateExerciseViewModel

    
    
    var body: some View {
        VStack{
            HStack{
                Button(action:{
                    exercisesVM.close()
                }){
                    Image(systemName: "xmark")
                        .font(.title)
                        .foregroundColor(.black)
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, 40)
                Spacer()
                
                
                //Is Pro
                Text("Is Pro")
                    .font(.body)
                    .foregroundColor(.black)
                    .padding(.trailing, 10)
                
                Button(action:{
                    exerciseVM.exercise.isPro.toggle()
                }){
                    Image(systemName: exerciseVM.exercise.isPro ? "circle.fill" : "circle")
                        .font(.title)
                        .foregroundColor(.black)
                }.buttonStyle(PlainButtonStyle())
            }
            
            
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack(spacing: 20){
                    //Images
                    HStack(spacing: 20){
                        Spacer()
                        AddImageButton(imageURL: $exerciseVM.iconURL, image: $exerciseVM.exercise.iconImage, name: "Icon")
                        Spacer()
                        AddImageButton(imageURL: $exerciseVM.imageURL, image: $exerciseVM.exercise.image, name: "Image")
                        Spacer()
                    }
                    
                    //Text
                    TextField("Name", text: $exerciseVM.exercise.name)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(5)
                    
                    TextField("Short Description", text: $exerciseVM.exercise.shortDescription)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(5)
                    
                    TextField("Description", text: $exerciseVM.exercise.description)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(5)
                    
                    TextField("Voice Comment", text: $exerciseVM.exercise.voiceComment)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(5)
                    
                    //Types
                    HStack(alignment: .top, spacing: 30){
                       
                        MultiCaseChoseView(name: "LEVEL", selected: $exerciseVM.level, multiChoose: true, array: LevelType.allCases.map({$0.str}))
                        MultiCaseChoseView(name: "Type", selected: $exerciseVM.type, array: WorkType.allCases.map({$0.str}))
                        MultiCaseChoseView(name: "Muscle", selected: $exerciseVM.muscule, multiChoose: true, array: MuscleType.allCases.map({$0.str}))
                    }
                    
                    Button(action:{
                        exercisesVM.save(exerciseVM.exercise)
                    }){
                        Text("SAVE")
                            .font(.title)
                            .foregroundColor(.black)
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 2))
                    }.buttonStyle(PlainButtonStyle())
                }
                
                
            })
        }.padding()
    }
}



