//
//  ExerciseCatalog.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 03.10.2021.
//

import SwiftUI

struct ExerciseCatalog: View {
    
    @Binding var show: Bool
    var onSelect: (BasicExercise)->() = {_ in}
    let type: WorkType? = nil
    
    @EnvironmentObject var viewModel: ExercisesViewModel
    
    
    var body: some View {
        VStack(spacing: 20){
            
            //КНОПКА ЗАКРЫТЬ
            CloseButton(onTap: {
                show.toggle()
            })
            
            Text("CATALOG")
                .font(.title3)
                .foregroundColor(.white.opacity(0.6))
            
            //КНОПКИ СИЛОВЫЕ ИЛИ ИНТЕРВАЛЬНЫЕ ТРЕНИРОВКИ
            HStack{
                showHiitButton
                showStrenghtButton
            }
            
            VStack{
                Divider()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10){
                        ForEach(MuscleType.allCases, id:\.id){muscleType in
                            muscleButton(type: muscleType)
                        }
                    }
                }
                Divider()
            }
            
            //HIIT
            VStack(alignment: .leading){
                Text("HIIT:")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.6))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20){
                        ForEach(viewModel.visibleExercises.filter({$0.type == .hiit}), id:\.id){exercise in
                            //УПРАЖНЕНИЕ
                            ExerciseItem(exercise: exercise)
                                .onTapGesture {
                                    //ВЫБРАЛИ УПР
                                    onSelect(exercise)
                                }
                        }
                    }
                }
            }
            
            //STRENGHT
            VStack(alignment: .leading){
                Text("STRENGHT:")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.6))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20){
                        ForEach(viewModel.visibleExercises.filter({$0.type == .strenght}), id:\.id){exercise in
                            //УПРАЖНЕНИЕ
                            ExerciseItem(exercise: exercise)
                                .onTapGesture {
                                    //ВЫБРАЛИ УПР
                                    onSelect(exercise)
                                }
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .frame(width: 700, height: 500)
        .background(BlurWindow())
        .cornerRadius(20)
    }
    
    private var showStrenghtButton: some View {
        Button {
            if viewModel.typeFilter.contains(.strenght) {
                viewModel.typeFilter.removeAll(where: {$0 == .strenght})
            } else {
                viewModel.typeFilter.append(.strenght)
            }
        } label: {
            Text("STRENGHT")
                .foregroundColor(.white)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .frame(width: 150)
                .background(Color.blue.opacity(viewModel.typeFilter.contains(.strenght) ? 1 : 0.2))
                .cornerRadius(5)
        }.buttonStyle(PlainButtonStyle())
    }
    
    private var showHiitButton: some View {
        Button {
            if viewModel.typeFilter.contains(.hiit) {
                viewModel.typeFilter.removeAll(where: {$0 == .hiit})
            } else {
                viewModel.typeFilter.append(.hiit)
            }
        } label: {
            Text("HIIT")
                .foregroundColor(.white)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .frame(width: 150)
                .background(Color.orange.opacity(viewModel.typeFilter.contains(.hiit) ? 1 : 0.2))
                .cornerRadius(5)
                
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func muscleButton(type: MuscleType) -> some View {
        Button {
            if viewModel.muscleFilter.contains(type) {
                viewModel.muscleFilter.removeAll(where: {$0 == type})
            } else {
                viewModel.muscleFilter.append(type)
            }
        } label: {
            Text(type.str.uppercased())
                .font(.callout)
                .foregroundColor(viewModel.muscleFilter.contains(type) ? .black.opacity(0.3) : .white.opacity(0.5))
                .padding(.vertical, 3)
                .padding(.horizontal, 6)
                .background( Color.white.opacity( viewModel.muscleFilter.contains(type) ? 0.8 : 0) )
                .overlay( Capsule()
                            .stroke(Color.white.opacity(viewModel.muscleFilter.contains(type) ? 0 : 0.5)) )
                .clipShape(Capsule())
                .contentShape(Capsule())
        }.buttonStyle(PlainButtonStyle())

    }
}

struct ExerciseCatalog_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseCatalog(show: .constant(false))
            .background(Color.black.opacity(0.8))
    }
}

