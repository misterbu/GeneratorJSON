//
//  DetailWorkoutView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 28.06.2021.
//

import SwiftUI

struct DetailWorkoutView: View {
    
    @ObservedObject var viewModel: MyWorkoutViewModel
    @State var selectedExercise: Exercise? = nil
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            HStack{
                VStack(alignment: .leading, spacing: 20){
                    HStack{
                        TextField("Workout name", text: $viewModel.workout.name)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.vertical, 5)
                            .padding(.horizontal)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                        
                        Spacer(minLength: 30)
                        
                        isProButton
                    }
                    
                    HStack(spacing: 40){
                        AddImageButton(imageURL: $viewModel.iconURL, image: $viewModel.workout.iconImage, name: "Icon")
                        AddImageButton(imageURL: $viewModel.imageURL, image: $viewModel.workout.image, name: "Image")
                        
                        Spacer()
                    }
                    
                    VStack{
                        TextField("Description", text: $viewModel.workout.description)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.vertical, 5)
                            .padding(.horizontal)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                        
                        TextField("Workout name", text: $viewModel.workout.shortDescription)
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
                    
                    Divider()
                    
                    Text("PLAN:")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 10){
//                        ForEach(0..<viewModel.workout.workoutCircles.count, id: \.self ){index in
//                            HStack(spacing: 20) {
//                               // DetailWorkoutCircleView(viewModel: viewModel.circlesViewModels[index])
//                                DetailWorkoutCircleView(circle: $viewModel.workout.workoutCircles[index])
//                                deleteCircle(index: index)
//                            }
//                        }
                        
                        ForEach(viewModel.workout.workoutCircles, id: \.id ){circle in
                            HStack(spacing: 20) {
                                if let index = viewModel.workout.workoutCircles.firstIndex(where: {$0.id == circle.id}) {
                                    DetailWorkoutCircleView( circle: $viewModel.workout.workoutCircles[index])
                                    deleteCircle(index: index)
                                }
                               
                                
                            }
                        }
                        
                        addCircleButton
                    }
                    
                    Spacer()
                    
                    
                    Text("\(viewModel.workout.seriaId ?? "No seria")")
                    
                    saveButton
                    
                }.padding()
                
                //Side Menu
//                if selectedExercise != nil {
//                    ExercisePropertyView(exercise: $selectedExercise)
//                }
            }
        })
        
    }
    
    var isProButton: some View {
        Button(action: {
            withAnimation{ viewModel.workout.isPro.toggle() }
        }, label: {
            HStack{
                Circle()
                    .stroke(Color.primary, lineWidth: 1)
                    .frame(width: 15, height: 15)
                    .overlay(Circle()
                                .fill(viewModel.workout.isPro ?
                                        Color.primary : Color.clear))
                Text("IS PRO")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
            }
        })
        .buttonStyle(PlainButtonStyle())
    }
    
    var addCircleButton: some View {
        Button {
            viewModel.addCircle()
        } label: {
            VStack{
                Image(systemName: "plus.circle")
                    .font(.title)
                    .foregroundColor(.primary)
                Text("Add circle")
                    .font(.body)
                    .foregroundColor(.primary)
            }
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
    
    func deleteCircle(index: Int) -> some View {
        Button(action: {
            viewModel.deleteCircle(index: index)
        }, label: {
            Image(systemName: "trash.circle")
                .font(.title)
                .foregroundColor(.primary)
            }).buttonStyle(PlainButtonStyle())
        }
    
}


