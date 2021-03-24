//
//  GeneratorJSONApp.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 04.03.2021.
//

import SwiftUI

@main
struct GeneratorJSONApp: App {
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            Home()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(ExercisesViewModel())
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
