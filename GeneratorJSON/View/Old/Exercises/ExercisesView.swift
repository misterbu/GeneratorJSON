//
//  ExercisesView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 01.10.2021.
//

import SwiftUI

struct ExercisesView: View {
    @EnvironmentObject var viewModel: ExercisesViewModel
    
    var body: some View {
        HStack{
            ExerciseReview()
                .frame(width: 350)
                .background(BlurWindow())
            
            ExerciseDetail(exercise: $viewModel.selectedExercise, onSave: { exercise in
                viewModel.save(exercise)
            }, onDelete: { exercise in
                viewModel.delete(exercise)
            }).frame(maxWidth: .infinity)
        }
    }
    

    
}

struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        Home(activeTab: .exercises)
    }
}
