//
//  ExercisePropertyView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 30.06.2021.
//

import SwiftUI

struct IntervalExercisePropertyView: View {
    
    @ObservedObject var viewModel: IntervalExercisePropertyViewModel
    @Binding var circle: WorkoutCircle
    @Binding var selectedExercise: Exercise?
    
    let formatter: NumberFormatter = {
       let form = NumberFormatter()
        form.numberStyle = .decimal
        return form
    }()
    
    var body: some View {
        

        VStack( alignment: .leading, spacing: 30) {
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
            
            HStack{
                TextField("Duration", value: $viewModel.exercise.duration, formatter: formatter)
                Text("sec")
            }
            
            Picker(selection: $viewModel.exercise.noTimeLimit, label: Text("")) {
                Text("With Time Limit")
                    .tag(true)
                Text("Without Time Limit (Normal)")
                    .tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .labelsHidden()
            
        }
        .frame(maxWidth: 500)
        .padding()
        .background(BlurWindow())
        
    }
    
    var closeButton: some View {
        Button {
            
            circle.exercises.removeAll(where: {$0.id == viewModel.exercise.id})
            circle.exercises.append(viewModel.exercise)
            circle.exercises.sort(by: {$0.orderAdd < $1.orderAdd})
            
            selectedExercise = nil
        } label: {
            Image(systemName: "xmark")
                .font(.body)
                .foregroundColor(.primary)
        }

    }
}

