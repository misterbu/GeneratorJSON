//
//  ReviewExerciseView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 27.06.2021.
//

import SwiftUI

struct ReviewExerciseView: View {
    
    @EnvironmentObject var viewModel: MyExercisesViewModel
    var exercise: BasicExercise
    
    var body: some View {
        HStack{
            //Иконка тренировки
            if let image = exercise.iconImage {
                Image(nsImage: image)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .padding(2)
                    .overlay(Circle()
                                .stroke(exercise.type == .hiit ? Color.orange : Color.blue,
                                        lineWidth: 3))
            }
            
            
            Text(exercise.name)
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
            viewModel.delete(exercise: exercise)
        }, label: {
            Image(systemName: "trash.circle")
                .font(.title)
                .foregroundColor(.primary)
        }).buttonStyle(PlainButtonStyle())
    }
}
