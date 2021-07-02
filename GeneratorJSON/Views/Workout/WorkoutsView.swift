//
//  WorkoutsView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 25.06.2021.
//

import SwiftUI

struct WorkoutsView: View {
    
    @EnvironmentObject var viewModel: MyWorkoutsViewModel
    
    var body: some View {
        VStack{

            //Кнопки добавления упражнений
            HStack{
                Button(action: {
                    viewModel.create()
                }, label: {
                    VStack{
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                }).buttonStyle(PlainButtonStyle())
            }
            .padding()
            .padding(.bottom, 30)
            
            //Список упржаннеий
            List{
                ForEach(viewModel.workouts, id:\.id){workout in
                    NavigationLink(
                        destination: DetailWorkoutView(viewModel: MyWorkoutViewModel(workout: workout)),
                        label: {
                            ReviewWorkoutView(workout: workout)
                        })
                }
            }.listStyle(SidebarListStyle())
            
            
            Spacer()
            
            generateJSONButton
        }
        .padding()
    }
    
    var generateJSONButton: some View {
        Button {
            viewModel.generateJSON()
        } label: {
            Image(systemName: "highlighter")
                .font(.title)
                .foregroundColor(.primary)
                .contentShape(Circle())
        }.buttonStyle(PlainButtonStyle())

    }
}

