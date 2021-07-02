//
//  ExercisesCatalogView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 29.06.2021.
//

import SwiftUI

struct AddExerciseCatalogView: View {
    
    @StateObject var viewModel: AddExerciseCatalogViewModel
    @Binding var circle: WorkoutCircle
    @Binding var show: Bool
    
    private let row = Array(repeating: GridItem(.flexible(), spacing: 10, alignment: .center), count: 5)
    
    var body: some View {
        VStack(spacing: 20){
            closeButton
            
            Picker(selection: $viewModel.type, label: Text("Picker")) {
                Text("Hiit")
                    .tag(WorkType.hiit)
                Text("Strenght")
                    .tag(WorkType.strenght)
            }.pickerStyle(SegmentedPickerStyle())
            
            
            LazyVGrid(columns: row) {
                ForEach(viewModel.exercises, id: \.id){exercise in
                    VStack{
                        if let icon = exercise.iconImage {
                            Image(nsImage: icon)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .padding(2)
                                .clipShape(Circle())
                                .overlay(Circle()
                                            .stroke(exercise.type == .hiit ? Color.orange : Color.blue, lineWidth: 2))
                        }
                        Text(exercise.name)
                    }.onTapGesture {
                        //Добавляем выбранное упражнение в цикл
                        if let exer = viewModel.getExercise(exercise, order: circle.exercises.count) {
                            circle.exercises.append(exer)
                        }
                        //Закрываем каталог
                        withAnimation{show.toggle()}
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var closeButton: some View {
        Button {
            withAnimation{show.toggle()}
        } label: {
            Image(systemName: "xmark")
                .resizable()
                .frame(width: 40, height: 40)
        }.buttonStyle(PlainButtonStyle())
    }
}





