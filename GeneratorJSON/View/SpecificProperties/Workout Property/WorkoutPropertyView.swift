//
//  WorkoutPropertyView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 26.01.2022.
//

import SwiftUI


struct WorkoutPropertyView: View {
    @Binding var workout: Workout
    @Binding var exercisesCatalogView: AnyView?
    
    var body: some View {
        //ЦИКЛЫ
        HStack(spacing: 30){
            ForEach(workout.workoutCircles.indices ,id: \.self){index in
                Safe($workout.workoutCircles, index: index) { binding in
                    WorkoutCircleView(workoutCircle: binding,
                                      workType: workout.type,
                                      additionalView: $exercisesCatalogView) { circle in
                        //УДАЛЯЕМ ЦИКЛ
                        workout.workoutCircles.removeAll(where: {$0.id == circle.id})
                    }
                }
            }
            
            Spacer()
        }
    }
}

