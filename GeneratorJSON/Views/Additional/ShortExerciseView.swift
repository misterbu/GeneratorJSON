//
//  ShortExerciseView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 29.06.2021.
//

import SwiftUI

struct ShortExerciseView: View {
    
    var exercise: Exercise
    
    var body: some View {
        VStack{
            if let icon = exercise.basic.iconImage {
                Image(nsImage: icon)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .padding(2)
                    .overlay(Circle()
                                .stroke(exercise.basic.type == .hiit ? Color.orange : Color.blue, lineWidth: 2))
                    .padding(5)
            }
            Text(exercise.basic.name)
            if let interval = exercise as? IntervalExercise {
                Text("\(interval.duration)sec" )
            } else if let strenght = exercise as? StrenghtExercise {
                Text("sets count \(strenght.sets.count)")
            }
        }
    }
}

