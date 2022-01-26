//
//  Home.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 01.10.2021.
//

import SwiftUI

struct Home: View {
    
    @State var activeTab: MainPageType = .programs
    
    @EnvironmentObject var workoutViewModel: WorkoutsViewModel
    @EnvironmentObject var programsViewModel: ProgramsViewModel
    @EnvironmentObject var exercisesViewModel: ExercisesViewModel
    
    var body: some View {
        HStack(spacing: 0){
            // MARK: - ЛЕВЫЙ СТОЛБ ВЫБОРА: Программы, тренировки, упр
            VStack(spacing: 30){
                TabButton(pageType: .programs, activeTab: $activeTab)
                TabButton(pageType: .workouts, activeTab: $activeTab)
                TabButton(pageType: .exercises, activeTab: $activeTab)
                
                Spacer()
                
                generateJSONButton
            }
            .padding(.vertical, 35)
            .padding(.horizontal, 10)
            .background(BlurWindow())
            
            // MARK: - ОСНОВНОЙ КОНТЕНТ
            ZStack{
                switch activeTab {
                case .programs:
                    CatalogContainer(items: programsViewModel.allPrograms)
                case .workouts:
                    CatalogContainer(items: workoutViewModel.allWorkouts)
                case .exercises:
                    CatalogContainer(items: exercisesViewModel.allExerises)
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .edgesIgnoringSafeArea(.all)
        .frame(width: NSScreen.width/1.2, height: NSScreen.height/1.2)
        
    }
    
    
    var generateJSONButton: some View {
        Button {
            workoutViewModel.generateJSON()
            programsViewModel.generateJSON()
            exercisesViewModel.generateJSON()
        } label: {
            VStack{
                Image(systemName: "square.and.arrow.down")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                Text("JSON")
                    .font(.body)
            }
            .foregroundColor(.gray)
            .padding()
            .contentShape(RoundedRectangle(cornerRadius: 10))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .preferredColorScheme(.dark)
    }
}
