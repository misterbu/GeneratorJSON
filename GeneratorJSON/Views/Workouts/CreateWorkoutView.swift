//
//  CreateWorkoutView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 25.03.2021.
//

import SwiftUI

struct CreateWorkoutView: View {
    
    @ObservedObject var workoutVM: WorkoutViewModel
    @Binding var close: Bool
    
    
    var body: some View {
        VStack{
            HStack{
                Button(action:{
                    withAnimation{ close.toggle() }
                }){
                    Image(systemName: "xmark")
                        .font(.title)
                        .foregroundColor(.black)
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, 40)
                Spacer()
                
                
                //is pro
                Text("Is Pro")
                    .font(.body)
                    .foregroundColor(.black)
                    .padding(.trailing, 10)
                
                Button(action:{
                    workoutVM.workout.isPro.toggle()
                }){
                    Image(systemName: workoutVM.workout.isPro ? "circle.fill" : "circle")
                        .font(.title)
                        .foregroundColor(.black)
                }.buttonStyle(PlainButtonStyle())
            }
            
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack(spacing: 20){
                    //Images
                    HStack(spacing: 20){
                        Spacer()
                        AddImageButton(imageURL: $workoutVM.iconURL, image: $workoutVM.workout.iconImage, name: "Icon")
                        Spacer()
                        AddImageButton(imageURL: $workoutVM.imageURL, image: $workoutVM.workout.image, name: "Image")
                        Spacer()
                    }
                    
                    //Text
                    TextField("Name", text: $workoutVM.workout.name)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(5)
                    
                    TextField("Short Description", text: $workoutVM.workout.shortDescription)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(5)
                    
                    TextField("Description", text: $workoutVM.workout.description)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(5)
                    
                    
                    //Types
                    HStack(alignment: .top, spacing: 30){
                       
                        MultiCaseChoseView(name: "LEVEL", selected: $workoutVM.level, array: LevelType.allCases.map({$0.str}))
                        MultiCaseChoseView(name: "Type", selected: $workoutVM.type, array: WorkType.allCases.map({$0.str}))
                        MultiCaseChoseView(name: "Sex", selected: $workoutVM.sex, array: SexType.allCases.map({$0.str}))
                        MultiCaseChoseView(name: "Target", selected: $workoutVM.target, multiChoose: true, array: TargetType.allCases.map({$0.str}))
                        MultiCaseChoseView(name: "Equipment", selected: $workoutVM.equipnemt, multiChoose: true, array: EquipmentType.allCases.map({$0.str}))
                    }
                    
                   
                    
                    Button(action:{
                        //workout save
                        close.toggle()
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
        }
    }
}

