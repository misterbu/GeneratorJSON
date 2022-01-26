//
//  WorkoutsView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 02.10.2021.
//

import SwiftUI

struct WorkoutsView: View {
    @EnvironmentObject var viewModel: WorkoutsViewModel
   
    
    var body: some View {
        HStack{
            //КАТАЛОГ ТРЕНИРОВОК
            WorkoutReview()
                .frame(width: 350)
                .background(BlurWindow())
            
            //СТРАНИЦА ТРЕНИРОВКИ
            WorkoutDetail(workout: $viewModel.selectedWorkout)
            
        }
    }
}

