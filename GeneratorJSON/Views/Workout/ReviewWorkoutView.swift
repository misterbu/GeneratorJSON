//
//  ReviewWorkoutView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 28.06.2021.
//

import SwiftUI

struct ReviewWorkoutView: View {
    
    @EnvironmentObject var viewModel: MyWorkoutsViewModel
    var workout: Workout
    
    var body: some View {
        HStack{
            //Иконка тренировки
            if let image = workout.iconImage {
                Image(nsImage: image)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .padding(2)
                    .overlay(Circle()
                                .stroke(workout.type == .hiit ? Color.orange : Color.blue,
                                        lineWidth: 3))
            }
            
            
            Text(workout.name)
                .lineLimit(2)
                .font(.title)
                .foregroundColor(.primary)
                .frame(maxWidth: 100)
            
            Spacer(minLength: 50)
            
            deleteButton
        }
    }
    
    var deleteButton: some View {
        Button(action: {
            viewModel.delete(workout: workout)
        }, label: {
            Image(systemName: "trash.circle")
                .font(.title)
                .foregroundColor(.primary)
        }).buttonStyle(PlainButtonStyle())
    }
}


