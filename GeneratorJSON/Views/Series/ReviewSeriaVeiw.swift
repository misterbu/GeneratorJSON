//
//  ReviewSeriaVeiw.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 30.06.2021.
//

import SwiftUI

struct ReviewSeriaVeiw: View {
    
    @EnvironmentObject var viewModel: MySeriesViewModel
    var seria: WorkoutSeria
    
    var body: some View {
        HStack{
            //Иконка тренировки
            if let image = seria.iconImage {
                Image(nsImage: image)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .padding(2)
                    .overlay(Circle()
                                .stroke(seria.type == .hiit ? Color.orange : Color.blue,
                                        lineWidth: 3))
            }
            
            
            Text(seria.name)
                .lineLimit(2)
                .font(.title)
                .foregroundColor(.primary)
                .frame(maxWidth: 100)
            
            Spacer(minLength: 50)
            
            deleteButton
        }
    }
    
    var deleteButton: some View {
        Button(action: {
            viewModel.delete(seria)
        }, label: {
            Image(systemName: "trash.circle")
                .font(.title)
                .foregroundColor(.primary)
        }).buttonStyle(PlainButtonStyle())
    }
}

