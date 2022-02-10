//
//  IntervalExerciseSidePage.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 12.10.2021.
//

import SwiftUI
import Combine

struct EditHiitExerciseView: View {
    @State var exercise: IntervalExercise
    var onSave: (Exercise)->()
    var onDelete:(Exercise)->()
    var onClose: ()->()
    
    @State var duration = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 30){
            
            CloseButton {
                onClose()
            }
            
            //НАЗВАНИЕ
            Text(exercise.basic.name.uppercased() )
                .font(.title2)
                .foregroundColor(.white)
            
    
            //СЕТЫ
            if !exercise.noTimeLimit {
                VStack{
                    Text("Duration")
                        .font(.callout)
                        .foregroundColor(.white.opacity(0.5))
                    
                    TextField("\(exercise.duration)", text: $duration) {
                        exercise.duration = Int(duration) ?? 20
                    }.onReceive(Just(duration)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.duration = filtered
                        }
                    }
                }
            }
            
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

}
