//
//  WorkoutProgramPropertyView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 26.01.2022.
//

import SwiftUI

struct WorkoutProgramPropertyView: View {
    @Binding var program: WorkoutProgmar
    
    @EnvironmentObject var programsViewModel: ProgramsManager
    @EnvironmentObject var workoutsManager: WorkoutsManager
    @State var showCatalog = false
    @State var selectedDay: String? = nil
    
    var body: some View{
        HStack(spacing: 20){
            
            ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) {day in
                getDayView(day)
            }
            Spacer()
        }
//        .sheet(isPresented: $showCatalog) {
//            WorkoutCatalog(show: $showCatalog, programId: program.id) { newWorkout in
//
//                guard let day = selectedDay else {return}
//
//                //ДОБАВЛЯЕМ ТРЕНИРОВКУ
//                program.plan[day] = newWorkout.id
//                self.selectedDay = nil
//
//                //Сохраняем
//                //programsViewModel.save(program)
//
//                withAnimation{self.showCatalog = false}
//            }
//        }
    }
    
    @ViewBuilder
    private func getDayView(_ day: String) -> some View {
        VStack{
            if let workoutID = program.plan.first(where: {$0.key == day})?.value,
               let workout = workoutsManager.items.first(where: {$0.id == workoutID}) {
            
                Image(nsImage: workout.image ?? NSImage(named: "ph")!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            
            } else {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .overlay(Image(systemName: "plus")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.6)))
            }
            
            Text(day)
                .foregroundColor(.white)
                .font(.body)
                .fontWeight(.semibold)
                .textCase(.uppercase)
        }
        .contentShape(Rectangle())
//        .onTapGesture {
//            self.selectedDay = day
//
//            let catalogView = SearchCatalogView(searchManager: SearchManager(workoutsManager.items),
//                                                title: "Select workout to \n\(selectedDay ?? "")",
//                                                onSelect: {workout in
//                //1. Add workout to plan
//                if let selectedDay = selectedDay {
//                    self.program.plan[selectedDay] = workout.id
//                    self.selectedDay = nil
//                }
//
//            })
//
//            showWorkoutsCatalog(AnyView(catalogView))
//        }
    }
}


struct WorkoutsCatalog: View {
    var body: some View {
        VStack{
            Text("CATALOG ")
                .font(.title)
                .foregroundColor(.red)
        }
    }
}
