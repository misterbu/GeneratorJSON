//
//  AddWorkoutCatalogView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 30.06.2021.
//

import SwiftUI

struct AddWorkoutCatalogView: View {
    
    @StateObject var viewModel: AddWorkoutViewModel
    @Binding var seria: WorkoutSeria
    @Binding var show: Bool
    
    private let row = Array(repeating: GridItem(.flexible(), spacing: 10, alignment: .center), count: 5)
    
    var body: some View {
        VStack{
            LazyVGrid(columns: row) {
                ForEach(viewModel.allWorkouts, id: \.id){workout in
                    VStack{
                        if let icon = workout.iconImage {
                            Image(nsImage: icon)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .padding(2)
                                .clipShape(Circle())
                                .overlay(Circle()
                                            .stroke(workout.type == .hiit ? Color.orange : Color.blue, lineWidth: 2))
                        }
                        Text(workout.name)
                    }.onTapGesture{
                        //Добавляем ИД сериии тренировок в тренировку
                        let workout1 = viewModel.addSeriaToWorkout(seriaId: seria.id, workout: workout)
                        
                        //Добавляем тренировку в серию тренировок
                        seria.workouts.append(workout1)
                        
                        //Закрываем
                        withAnimation{ show.toggle() }
                    }
                }
            }
        }
    }
}

