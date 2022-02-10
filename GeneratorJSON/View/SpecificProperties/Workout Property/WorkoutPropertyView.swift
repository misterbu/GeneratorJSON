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
        HStack(spacing: 30){
            addCircleButton
            
            ForEach($workout.workoutCircles, id: \.id){$circle in
                WorkoutCircleView(workoutCircle: $circle,
                                  workType: workout.type,
                                  additionalView: $exercisesCatalogView
                ) { circle in
                    workout.workoutCircles.removeAll(where: {$0.id == circle.id})
                }
            }
            
            Spacer()
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
    }
    
    private var addCircleButton: some View {
        Button {
            workout.workoutCircles.append(WorkoutCircle(order: workout.workoutCircles.count))
        } label: {
            Image(systemName: "plus.circle")
                .font(.title)
                .foregroundColor(.white)
        }

    }
}

