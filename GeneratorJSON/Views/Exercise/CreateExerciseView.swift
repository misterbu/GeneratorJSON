//
//  CreateExerciseView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 24.03.2021.
//

import SwiftUI

struct CreateExerciseView: View {
    
    @ObservedObject var exerciseVM: ExerciseViewModel
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
                       
                        MultiCaseChoseView(name: "LEVEL", selected: $exerciseVM.level, array: LevelType.allCases.map({$0.str}))
                        MultiCaseChoseView(name: "Type", selected: $exerciseVM.type, array: WorkType.allCases.map({$0.str}))
                        MultiCaseChoseView(name: "Muscle", selected: $exerciseVM.muscule, multiChoose: true, array: MuscleType.allCases.map({$0.str}))
                    }
                    
                    //Interval values
                    if exerciseVM.exercise.type == .hiit {
                        TextField("Duration", text: $exerciseVM.duration) { _ in
                            
                        } onCommit: {
                            exerciseVM.changeDuration(value: exerciseVM.duration)
                        }
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(5)
                            
                    } else if exerciseVM.exercise.type == .strenght {
                        Text("fdsjfdsj")
                    }
                    
                    Button(action:{
                        exerciseVM.save()
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
        }.padding()
    }
}



struct MultiCaseChoseView: View {
    
    var name: String
    @Binding var selected: [Int]
    var multiChoose: Bool = false
    var array: [String]
    
    var body: some View {
        VStack{
            Text(name)
                .font(.body)
                .foregroundColor(Color.black.opacity(0.6))
                .padding(.bottom, 20)
            
            ForEach(0..<array.count, id: \.self){index in
                VStack(spacing: 50) {
                    Text(array[index])
                        .font(.body)
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(selected.contains(index) ? Color.black.opacity(0.2) : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                        .onTapGesture {
                            if selected.contains(index) {
                                selected.removeAll(where: {$0 == index})
                            } else  {
                                if !multiChoose {
                                    selected.removeAll()
                                }
                                selected.append(index)
                            }
                        }
                }
            }
        }
    }
}
