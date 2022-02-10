//
//  WorkoutProgramPropertyView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 26.01.2022.
//

import SwiftUI

struct WorkoutProgramPropertyView: View {
    @Binding var program: WorkoutProgmar
    @Binding var workoutsCatalogView: AnyView?
    
    @EnvironmentObject var workoutsManager: WorkoutsManager

    @State var selectedDay: String? = nil
    
    var body: some View{
        VStack(alignment: .leading, spacing: 20){
            Text("Workout's plan:".uppercased())
                .foregroundColor(.white.opacity(0.8))
                .font(.title2)
            
            HStack(spacing: 20){
                ForEach(Calendar.current.shortWeekdaySymbols.indices, id: \.self) {indexDay in
                    getDayView(indexDay)
                }
                Spacer()
            }
        }
    }
    

    @ViewBuilder
    private func getDayView(_ indexDay: Int) -> some View {
        VStack{
            //Day's with attached a workout
            if let workoutID = program.plan.first(where: {$0.key == Calendar.current.shortWeekdaySymbols[indexDay]})?.value,
               let workout = workoutsManager.items.first(where: {$0.id == workoutID}) {
            
                Image(nsImage: workout.image ?? NSImage(named: "ph")!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            //Free day
            } else {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .overlay(Image(systemName: "plus")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.6)))
            }
            Text(Calendar.current.shortWeekdaySymbols[indexDay])
                .foregroundColor(.white)
                .font(.body)
                .fontWeight(.semibold)
                .textCase(.uppercase)
        }
        .contentShape(Circle())
        .onTapGesture {
            self.selectedDay = Calendar.current.shortWeekdaySymbols[indexDay]
            
            withAnimation {
                self.workoutsCatalogView = AnyView(
                    AdditionalItemsCatalog(searchManager: SearchManager(workoutsManager.items),
                                           title: "to \(Calendar.current.weekdaySymbols[indexDay])",
                                           subtitle: "Select workout for add",
                                           onSelect: {setWorkout($0 as Workout)},
                                           onClose: {closeWorkoutsCatalogView()})
                )
            }
            
        }
    }
    
    private func setWorkout(_ workout: Workout?){
        //Close an additional view
        withAnimation {
            workoutsCatalogView = nil
        }
        
        guard let workout = workout else { return }
        guard let selectedDay = selectedDay else {return }
        
        program.plan[selectedDay] = workout.id
        self.selectedDay = nil

    }
    
    private func closeWorkoutsCatalogView(){
        self.selectedDay = nil
        withAnimation {
            self.workoutsCatalogView = nil
        }
        
    }
}

struct WorkoutProgramPropertyView_Preview: PreviewProvider {
    static var previews: some View {
        WorkoutProgramPropertyView(program: .constant(.sample), workoutsCatalogView: .constant(nil))
            .preferredColorScheme(.dark)
            .padding()
    }
}
