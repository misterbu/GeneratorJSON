//
//  IntervalExerciseSidePage.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 12.10.2021.
//

import SwiftUI
import Combine

struct IntervalExerciseSidePage: View {
    @ObservedObject var viewModel: IntervalSideViewModel
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
            Text(viewModel.exercise.basic.name.uppercased() )
                .font(.title2)
                .foregroundColor(.white)
            
            //КНОПКИ БЕЗ ЛИМИТА ВРЕМЕНИ
            noTimeLimin
            
            //СЕТЫ
            if !viewModel.exercise.noTimeLimit {
                VStack{
                    Text("Duration")
                        .font(.callout)
                        .foregroundColor(.white.opacity(0.5))
                    
                    TextField("\(viewModel.exercise.duration)", text: $duration) {
                        viewModel.exercise.duration = Int(duration) ?? 20
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
                ButtonWIthIcon(name: "Save", icon: "square.and.arrow.down.on.square") {
                    onSave(viewModel.exercise)
                }
                Spacer()
                // MARK: - КНОПКА   УДАЛИТЬ
                IconButton(icon: "trash") {
                    onDelete(viewModel.exercise)
                }
            }
        }
        .padding(.vertical, 25)
        .padding()
        .background(ZStack{
            Image(nsImage: viewModel.exercise.basic.image ?? NSImage(named: "ph")!)
                        .resizable()
                        .scaledToFill()
            .clipped()
            Color.black.opacity(0.8)
        })
        .frame(width: 350, height: 800)
        .clipped()
    }
    
    var noTimeLimin: some View {
        Button {
            viewModel.exercise.noTimeLimit.toggle()
        } label: {
            Text("No reps limit")
                .font(.title3)
                .foregroundColor(viewModel.exercise.noTimeLimit ? .black.opacity(0.4) : .white)
                .padding(.horizontal, 5)
                .padding(.vertical, 3)
                .background(Color.white.opacity(viewModel.exercise.noTimeLimit ? 1 : 0))
                .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(viewModel.exercise.noTimeLimit ? 0 : 1)))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }.buttonStyle(PlainButtonStyle())

    }



}
