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
            MyHome(viewModel: MyHomeViewModel())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(MyExercisesViewModel())
                .environmentObject(MyWorkoutsViewModel())
                .environmentObject(MySeriesViewModel())
            
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
