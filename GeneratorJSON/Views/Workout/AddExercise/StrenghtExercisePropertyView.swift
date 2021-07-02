//
//  StrenghtExercisePropertyView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 30.06.2021.
//

import SwiftUI

struct StrenghtExercisePropertyView: View {
    
    @ObservedObject var viewModel: StrenghtExercisePropertyViewModel
    @Binding var circle: WorkoutCircle
    @Binding var selectedExercise: Exercise?
    
    var body: some View {
        
        VStack( alignment: .leading) {
            closeButton
            if let image = viewModel.exercise.basic.image {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 90)
                    .clipped()
            }
            
            Text(viewModel.exercise.basic.name)
                .foregroundColor(.primary)
                .font(.body)
            
            Spacer()
            
            Picker(selection: $viewModel.exercise.noLimitReps, label: Text("")) {
                Text("No Limit Reps")
                    .tag(true)
                Text("Limit Reps (Normal)")
                    .tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .labelsHidden()
            
            Picker(selection: $viewModel.exercise.ownWeight, label: Text("")) {
                Text("With Own Weight")
                    .tag(true)
                Text("Normal")
                    .tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .labelsHidden()
            
            Divider()
            
            VStack{
                ForEach(0..<viewModel.sets.count, id: \.self){index in
                    StrenghtExerciseSetPropertyView(viewModel: viewModel.sets[index])
                }
                
                addSetButton
            }
            
        }
        .frame(maxWidth: 200)
        .padding()
        .background(BlurWindow())
    }
    
    var addSetButton: some View {
        Button(action:{
            viewModel.addSet()
        }){
            Image(systemName: "plus.circle")
                .font(.title)
                .foregroundColor(.primary)
        }.buttonStyle(PlainButtonStyle())
    }
    
    var closeButton: some View {
        Button {
            circle.exercises.removeAll(where: {$0.id == viewModel.exercise.id})
            circle.exercises.append(viewModel.getExercise())
            circle.exercises.sort(by: {$0.orderAdd < $1.orderAdd})
            
            selectedExercise = nil
        } label: {
            Image(systemName: "xmark")
                .font(.body)
                .foregroundColor(.primary)
        }

    }
}

struct StrenghtExerciseSetPropertyView: View {
    
    @ObservedObject var viewModel: StrenghtExercisePropertySetViewModel
    
    let formatter: NumberFormatter = {
       let form = NumberFormatter()
        form.numberStyle = .decimal
        return form
    }()
    
    var body: some View {
        HStack{
            TextField("Reps", value: $viewModel.set.reps, formatter: formatter)
            Spacer(minLength: 20)
            Picker(selection: $viewModel.set.isWarm, label: Text("")) {
                Text("Yes")
                    .tag(true)
                Text("No")
                    .tag(false)
            }
        }.padding()
    }
}
