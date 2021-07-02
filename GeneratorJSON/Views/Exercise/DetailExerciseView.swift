//
//  DetailExerciseView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 27.06.2021.
//

import SwiftUI

struct DetailExerciseView: View {
    
    @ObservedObject var viewModel: MyExerciseViewModel
    
    var body: some View {
        VStack(spacing: 15){
            //Имя и isPro
            HStack{
                TextField("Workout name", text: $viewModel.exercise.name)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                
                Spacer(minLength: 40)
                
                isProButton
            }
            
            HStack(spacing: 40){
                AddImageButton(imageURL: $viewModel.iconURL, image: $viewModel.exercise.iconImage, name: "Icon")
                AddImageButton(imageURL: $viewModel.imageURL, image: $viewModel.exercise.image, name: "Image")
                
                Spacer()
            }
            
            TextField("Description", text: $viewModel.exercise.description)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.vertical, 5)
                .padding(.horizontal)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
            
            TextField("Workout name", text: $viewModel.exercise.shortDescription)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.vertical, 5)
                .padding(.horizontal)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
            
            HStack(spacing: 20){
                
                MultiCaseChoseView(name: "LEVEL", selected: $viewModel.level, multiChoose: true, array: LevelType.allCases.map({$0.str}))
                MultiCaseChoseView(name: "Type", selected: $viewModel.type, array: WorkType.allCases.map({$0.str}))
                MultiCaseChoseView(name: "Muscle", selected: $viewModel.muscule, multiChoose: true, array: MuscleType.allCases.map({$0.str}))
                Spacer()
            }
            
            Spacer()
            
            //Кнопка сохранения
            HStack{
                saveButton
                Spacer()
            }
        }
        .padding()
    }
    
    var isProButton: some View {
        Button(action: {
            withAnimation{ viewModel.exercise.isPro.toggle() }
        }, label: {
            HStack{
                Circle()
                    .stroke(Color.primary, lineWidth: 1)
                    .frame(width: 15, height: 15)
                    .overlay(Circle()
                                .fill(viewModel.exercise.isPro ?
                                        Color.primary : Color.clear))
                Text("IS PRO")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
            }
        })
        .buttonStyle(PlainButtonStyle())
    }
    
    var saveButton: some View {
        Button(action: {
            viewModel.save()
        }, label: {
            Image(systemName: "arrow.down.doc.fill")
                .font(.title)
                .foregroundColor(.primary)
        }).buttonStyle(PlainButtonStyle())
    }
}


