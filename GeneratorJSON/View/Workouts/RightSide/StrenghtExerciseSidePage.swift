//
//  StrenghtExerciseSidePage.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 03.10.2021.
//

import SwiftUI

struct StrenghtExerciseSidePage: View {

    //@State var exercise: StrenghtExercise
    @ObservedObject var viewModel: StrenghtSideViewModel
    var onSave: (Exercise)->()
    var onDelete:(Exercise)->()
    var onClose: ()->()

    var body: some View {
        VStack(alignment: .center, spacing: 30){
            
            CloseButton {
                onClose()
            }
            
            //НАЗВАНИЕ
            Text(viewModel.exercise.basic.name.uppercased() )
                .font(.title2)
                .foregroundColor(.white)
            
            //КНОПКИ БЕЗ КОЛИЧЕСТВА ПОВТОРЕНИЙ и С СОБСТВЕННЫМ ВЕСОМ
            HStack(spacing: 20){
                noLimitReps
                withOwnWeight
            }.padding(.bottom, 40)
            
            //СЕТЫ
            VStack(alignment:.center){
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15){
                        
                        //НАИМЕНОВАНИЕ СТОЛБЦОВ(КОЛ_ВО ПОВТОРЕНИЙ И РАЗМИНКА)
                        HStack(spacing: 40){
                            Text("REPS:")
                                .font(.callout)
                                .foregroundColor(.white.opacity(0.6))
                                .frame(width: 80)
                            Text("WarmUp")
                                .font(.callout)
                                .foregroundColor(.white.opacity(0.6))
                        }
                        
                        //CЕТЫ
                        ForEach(viewModel.exercise.sets.indices, id:\.self){index in
                            Safe($viewModel.exercise.sets, index: index) { exSet in
                                StrenghtExerciseSetView(exSet: exSet)
                            }
                        }
                        
                        //ДОБАВИТЬ СЕТ
                        addSet
                            .padding(.top, 20)
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
    
    var noLimitReps: some View {
        Button {
            viewModel.exercise.noLimitReps.toggle()
        } label: {
            Text("No reps limit")
                .font(.title3)
                .foregroundColor(viewModel.exercise.noLimitReps ? .black.opacity(0.4) : .white)
                .padding(.horizontal, 5)
                .padding(.vertical, 3)
                .background(Color.white.opacity(viewModel.exercise.noLimitReps ? 1 : 0))
                .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(viewModel.exercise.noLimitReps ? 0 : 1)))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }.buttonStyle(PlainButtonStyle())

    }

    var withOwnWeight: some View {
        Button {
            viewModel.exercise.ownWeight.toggle()
        } label: {
            Text("With own weight")
                .font(.title3)
                .foregroundColor(viewModel.exercise.ownWeight ? .black.opacity(0.4) : .white)
                .padding(.horizontal, 5)
                .padding(.vertical, 3)
                .background(Color.white.opacity(viewModel.exercise.ownWeight ? 1 : 0))
                .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(viewModel.exercise.ownWeight ? 0 : 1)))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }.buttonStyle(PlainButtonStyle())
    }
    
    var addSet: some View {
        Button {
            viewModel.exercise.sets.append(ExerciseSet(order: viewModel.exercise.sets.count))
        } label: {
            Image(systemName: "plus.circle")
                .font(.largeTitle)
                .foregroundColor(.white.opacity(0.5))
        }.buttonStyle(PlainButtonStyle())

    }
    
    
}
