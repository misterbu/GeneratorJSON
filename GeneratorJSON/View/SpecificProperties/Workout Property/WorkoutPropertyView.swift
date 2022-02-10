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
        VStack(alignment: .leading, spacing: 20){
            Divider()
            
            HStack{
                Text("Workout circles:".uppercased())
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                ButtonWithIcon(name: "Add circle", icon: "plus", type: .small) {
                    workout.workoutCircles.append(WorkoutCircle(order: workout.workoutCircles.count))
                }
                
                //addCircleButton
            }
            
            VStack(alignment: .leading, spacing: 20){
                ForEach($workout.workoutCircles, id: \.id){$circle in
                    WorkoutCircleView(workoutCircle: $circle,
                                      workType: workout.type,
                                      additionalView: $exercisesCatalogView,
                                      onDelete: {deleteCircle($0)})
                        .frame(height: 200)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var addCircleButton: some View {
        Button {
            workout.workoutCircles.append(WorkoutCircle(order: workout.workoutCircles.count))
        } label: {
            HStack{
                Image(systemName: "plus")
                Text("Add circle".uppercased())
            }
            .font(.title)
            .foregroundColor(.white)
        }
        
    }
    
    private func deleteCircle(_ circle: WorkoutCircle){
        workout.workoutCircles.removeAll(where: {$0.id == circle.id})
        
        if workout.workoutCircles.isEmpty {
            workout.workoutCircles.append(WorkoutCircle(order: 0))
        }
    }
}


struct WorkoutPropertyView_Preview: PreviewProvider {
    static var previews: some View {
        WorkoutPropertyView(workout: .constant(.sample), exercisesCatalogView: .constant(nil))
            .preferredColorScheme(.dark)
            .padding()
            .buttonStyle(PlainButtonStyle())
    }
}
