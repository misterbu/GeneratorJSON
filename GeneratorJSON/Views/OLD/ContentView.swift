//
//  ContentView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 04.03.2021.
//

import SwiftUI

struct ContentView: View {
    
    var width = NSScreen.main?.visibleFrame.width ?? 100
    var height = NSScreen.main?.visibleFrame.height ?? 100
    @StateObject var  exercises = ExercisesViewModel1()
    @StateObject var  workouts = WorkoutViewModel1()
    
    var body: some View {
        TabView {
            ExercisesView(exercises: exercises)
                .tabItem {
                    Image(systemName: "heart.text.square.fill")
                    Text("Exersice")
                }
            WorkoutsView(workouts: workouts, exercises: exercises)
                .tabItem {
                    Image(systemName: "waveform.path.ecg.rectangle")
                    Text("Workout")
                }
        }.frame(width: width/3, height: height/1.5)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
