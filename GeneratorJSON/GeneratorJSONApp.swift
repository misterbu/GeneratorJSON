//
//  GeneratorJSONApp.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 04.03.2021.
//

import SwiftUI

@main
struct GeneratorJSONApp: App {
    var body: some Scene {
        WindowGroup {
            Home()
                .buttonStyle(PlainButtonStyle())
                .textFieldStyle(PlainTextFieldStyle())
                .environmentObject(ProgramsManager())
                .environmentObject(ExercisesViewModel())
                .environmentObject(WorkoutsManager())
                .preferredColorScheme(.dark)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
