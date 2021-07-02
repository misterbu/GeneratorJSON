//
//  MyHome.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 25.06.2021.
//

import SwiftUI

struct MyHome: View {
    
    @StateObject var viewModel: MyHomeViewModel
    
    var screen = NSScreen.main!.visibleFrame
    
    var body: some View {
        HStack(spacing: 0){
            VStack{
                MyTabButton(image: "figure.walk", title: "Exercises", selectedButton: $viewModel.selectedButton)
                MyTabButton(image: "hand.raised.fill", title: "Workouts", selectedButton: $viewModel.selectedButton)
                MyTabButton(image: "person.crop.rectangle", title: "Series", selectedButton: $viewModel.selectedButton)
                
                Spacer()
            }
            .padding(.top, 35)
            .padding()
            .background(BlurWindow())
            
            ZStack{
                switch viewModel.selectedButton {
                case "Exercises": NavigationView{ ExercisesView() }
                case "Workouts": NavigationView{ WorkoutsView() }
                case "Series": NavigationView{SeriesView()}
                default: Text("")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .ignoresSafeArea(.all)
        .frame(width: screen.width/1.2, height: screen.height-80)
    }
}

struct MyHome_Previews: PreviewProvider {
    static var previews: some View {
        MyHome(viewModel: MyHomeViewModel())
    }
}

