//
//  WorkoutSeriaItemView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 01.04.2021.
//

import SwiftUI

struct WorkoutSeriaItemView: View {
    
    @ObservedObject var itemVM: WorkoutSeriaItemViewModel
    
    var body: some View {
        VStack{
            ZStack{
                Image(nsImage: itemVM.workoutVM.workout.image ?? NSImage(named: "ph")!)
                    .resizable()
                    .scaledToFill()
                
                Color.black.opacity(0.3)
                Text(itemVM.workoutVM.workout.name)
                    .font(.title)
                    .foregroundColor(.white)
            }.frame(width: 150, height: 100)
            .clipped()
            
            TextField("Day", text: $itemVM.day)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.black.opacity(0.1))
                .cornerRadius(5)
        }
    }
}


