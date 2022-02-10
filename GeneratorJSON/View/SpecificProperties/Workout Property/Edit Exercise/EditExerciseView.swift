//
//  EditExerciseView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 10.02.2022.
//

import SwiftUI

struct EditExerciseView: View {
    
    @State var exercise: Exercise
    var onSave: (Exercise)->()
    var onDelete:(Exercise)->()
    var onClose: ()->()
    
    var body: some View {
        VStack{
            CloseButton {
                onClose()
            }
            
            //НАЗВАНИЕ
            VStack(alignment: .center, spacing: 10){
                Text("EDIT")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.8))
                
                Text(exercise.basic.name.uppercased() )
                    .font(.title2)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
            
            exercisePropertyView
            
            Spacer()
            
            HStack{
                
                IconButton(icon: "trash") {}
                .opacity(0)
                Spacer()
                // MARK: - КНОПКА СОХРАНИТЬ
                ButtonWithIcon(name: "Save", icon: "square.and.arrow.down.on.square") {
                    onSave(exercise)
                }
                Spacer()
                // MARK: - КНОПКА   УДАЛИТЬ
                IconButton(icon: "trash") {
                    onDelete(exercise)
                }
            }
        }
    }
    
    
    private var exercisePropertyView: some View {
        VStack{
            if let strenght = exercise as? StrenghtExercise {
                EditStrenghtExerciseView(exercise: .init(get: {strenght},
                                                         set: {exercise = $0 as Exercise}))
            } else if let hiit = exercise as? IntervalExercise {
                EditHiitExerciseView(exercise: .init(get: {hiit},
                                                     set: {exercise = $0 as Exercise}))
            }
        }
    }
}

