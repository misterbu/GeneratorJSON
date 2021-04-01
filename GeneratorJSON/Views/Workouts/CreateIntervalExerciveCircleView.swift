//
//  CreateIntervalExerciveCircleView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 31.03.2021.
//

import SwiftUI

struct CreateIntervalExerciveCircleView: View {
    
    @ObservedObject var viewModel: IntervalExerciseCircleViewModel
    @ObservedObject var circleVM: WorkoutCircleViewModel
    
    var body: some View {
        HStack(spacing: 5){
            //Remove button
            removeButton
            
            Text("\(viewModel.exercise.orderAdd)")
            
            //Basic
            HStack{
                Image(nsImage: viewModel.exercise.basic.iconImage ?? NSImage(named: "ph")!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipped()
                
                VStack{
                    Text(viewModel.exercise.basic.name)
                        .foregroundColor(.black)
                        .font(.body)
                        .fontWeight(.bold)
                    Text(viewModel.exercise.basic.description)
                        .foregroundColor(.black)
                        .font(.caption)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
            }
            
            Spacer(minLength: 50)
            
            //Configured
            VStack{
                HStack{
                    Text("Duration")
                        .foregroundColor(.black)
                        .font(.body)
                    
                    TextField("Duration", text: $viewModel.duration)
                }
                
                HStack{
                    Text("Voice comment")
                        .foregroundColor(.black)
                        .font(.body)
                    
                    TextField("Voice comment", text: $viewModel.voiceComment)
                }
            }
        }
    }
    
    var removeButton: some View {
        Button(action:{
            print("tab")
            circleVM.remove(viewModel)
        }){
            Image(systemName: "trash.circle")
                .font(.title)
                .foregroundColor(.black)
                .padding()
                .contentShape(Circle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
