//
//  DetailSeriaView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 30.06.2021.
//

import SwiftUI

struct DetailSeriaView: View {
    
    @ObservedObject var viewModel: MySeriaViewModel
    @State var showWorkoutCatalog: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                HStack{
                    TextField("Seria name", text: $viewModel.seria.name)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                    
                    Spacer(minLength: 30)
                    
                }
                
                HStack(spacing: 40){
                    AddImageButton(imageURL: $viewModel.iconURL, image: $viewModel.seria.iconImage, name: "Icon")
                    AddImageButton(imageURL: $viewModel.imageURL, image: $viewModel.seria.image, name: "Image")
                    
                    Spacer()
                }
                
                VStack{
                    TextField("Description", text: $viewModel.seria.description)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                    
                    TextField("Workout name", text: $viewModel.seria.shortDescription)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                    
                    HStack(alignment: .top, spacing: 20){
                        
                        MultiCaseChoseView(name: "LEVEL", selected: $viewModel.level, multiChoose: true, array: LevelType.allCases.map({$0.str}))
                        MultiCaseChoseView(name: "Type", selected: $viewModel.type, array: WorkType.allCases.map({$0.str}))
                        MultiCaseChoseView(name: "Target", selected: $viewModel.target, multiChoose: true, array: TargetType.allCases.map({$0.str}))
                        MultiCaseChoseView(name: "Equipment", selected: $viewModel.equipnemt, multiChoose: true, array: EquipmentType.allCases.map({$0.str}))
                        MultiCaseChoseView(name: "Sex", selected: $viewModel.sex, multiChoose: false, array: SexType.allCases.map({$0.str}))
                        Spacer()
                    }
                }
                
                HStack{

                    addButton
                    
                    ForEach(viewModel.seria.workouts, id: \.id){workout in
                        VStack{
                            if let icon = workout.iconImage {
                                Image(nsImage: icon)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .padding(2)
                                    .overlay(Circle()
                                                .stroke(workout.type == .hiit ? Color.orange : Color.blue,
                                                        lineWidth: 3))
                            }
                            Text(workout.name)
                        }
                        .padding()
                        .overlay(deleteButton(workout: workout), alignment: .topTrailing)
                    }
                    
                    Spacer()
                }
                
                Spacer()
                
                saveButton
            }
            
        }
        .padding()
        .sheet(isPresented: $showWorkoutCatalog) {
            AddWorkoutCatalogView(viewModel: AddWorkoutViewModel(), seria: $viewModel.seria, show: $showWorkoutCatalog)
        }
        
    }
    
    var addButton: some View {
        Button(action:{
            withAnimation{ showWorkoutCatalog.toggle() }
        }){
            Image(systemName: "plus.circle")
                .font(.title)
                .foregroundColor(.primary)
        }.buttonStyle(PlainButtonStyle())
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
    
    func deleteButton(workout: Workout) -> some View {
        Button(action: {
            viewModel.delete(workout: workout)
        }, label: {
            Image(systemName: "xmark")
                .font(.title)
                .foregroundColor(.primary)
        }).buttonStyle(PlainButtonStyle())
    }
}


