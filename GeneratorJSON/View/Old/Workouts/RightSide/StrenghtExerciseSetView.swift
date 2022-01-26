//
//  StrenghtExerciseSetView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 07.10.2021.
//

import SwiftUI
import Combine

struct StrenghtExerciseSetView: View {
    
    @Binding var exSet: ExerciseSet
    @State var countsText: String = ""

    var body: some View {
        HStack(spacing: 40){
            //КОЛИЧЕСТВО ПОВТОРЕНИЙ
            TextField("\(exSet.reps)", text: $countsText, onCommit: {
                self.exSet.reps = Int(countsText) ?? 10
            }).onReceive(Just(countsText)) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                        self.countsText = filtered
                    }
            }.textFieldStyle(PlainTextFieldStyle())
                .font(.title3)
                .foregroundColor(.white)
                .frame(width: 80)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Capsule()
                                .fill(Color.white.opacity(0.1)))
            
            //КНОПКА РАЗМИНИЧНОГО СЕТА
            isWarmUpButton
        }
    }
    
    var isWarmUpButton: some View{
        Button {
            exSet.isWarm.toggle()
        } label: {
            Image(systemName: exSet.isWarm ? "circle.fill" : "circle")
                .font(.title3)
                .foregroundColor(.white)
                .padding(5)
                .contentShape(Circle())
        }.buttonStyle(PlainButtonStyle())

    }
}
