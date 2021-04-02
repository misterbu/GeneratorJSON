//
//  CreateStrenghtExerciveCircleView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 31.03.2021.
//

import SwiftUI

struct CreateStrenghtExerciveCircleView: View {
    
    @ObservedObject var viewModel: StrenghtExerciseCircleViewModel
    @ObservedObject var circleVM: WorkoutCircleViewModel
    
    var body: some View {
        HStack(spacing: 5){
            //Remove
            removeButton
            
            Text("\(viewModel.exercise.orderAdd)")
            
            //Basic
            HStack{
                Image(nsImage: viewModel.exercise.basic.image ?? NSImage(named: "ph")!)
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
            
            VStack{
                ForEach(0..<viewModel.sets.count, id:\.self) {index in
                    CreateSetsStrenghtExerciveCircleView(viewModel: viewModel.sets[index], exerciseVM: viewModel)
                }
                
                //Add set
                Button(action:{
                    viewModel.createNewSet()
                }){
                    HStack{
                        Image(systemName: "plus")
                        Text("add set")
                    }
                    .font(.title)
                    .foregroundColor(.black)
                }.buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    var removeButton: some View {
        Button(action:{
            circleVM.remove(viewModel)
        }){
            Image(systemName: "trash.circle")
                .font(.title)
                .foregroundColor(.black)
        }.buttonStyle(PlainButtonStyle())
    }
}



struct CreateSetsStrenghtExerciveCircleView: View {
    
    @ObservedObject var viewModel: SetsStrenghtExerciseCircleViewModel
    @ObservedObject var exerciseVM: StrenghtExerciseCircleViewModel
    
    var body: some View{
        HStack(spacing: 5){
            removeButton
            
            Text("\(viewModel.exerciseSet.order)")
            
            Spacer(minLength: 40)
            
            Text("Reps")
                .foregroundColor(.black)
                .font(.body)
            
            TextField("Reps", text: $viewModel.reps)
            
            Spacer(minLength: 40)
            
            Text("Is warmup?")
                .foregroundColor(.black)
                .font(.body)
            
            Button(action:{
                viewModel.exerciseSet.isWarm.toggle()
            }){
                Image(systemName: viewModel.exerciseSet.isWarm ? "circle.fill" : "circle")
                    .font(.title)
            }.buttonStyle(PlainButtonStyle())
        }
        
    }
    
    var removeButton: some View {
        Button(action:{
           //
        }){
            Image(systemName: "trash.circle")
                .font(.title)
                .foregroundColor(.black)
        }.buttonStyle(PlainButtonStyle())
    }
}
