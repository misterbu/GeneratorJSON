//
//  ExerciseItem.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 03.10.2021.
//

import SwiftUI

struct ExerciseItem: View {
    
    var exercise: BasicExercise
    
    var body: some View {
        VStack{
            if let image = exercise.image {
                Image(nsImage: image)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(exercise.type == .hiit ? Color.orange : Color.blue,
                                        lineWidth: 3))
                    .padding(5)
            }
            
            Text(exercise.name)
                .lineLimit(2)
                .font(.body)
                .foregroundColor(.primary)
                .frame(maxWidth: 90, alignment: .center)
        }
    }
}
