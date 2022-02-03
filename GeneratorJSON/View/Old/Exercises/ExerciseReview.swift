//
//  ExerciseCatalog.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 01.10.2021.
//

import SwiftUI
//
//struct ExerciseReview: View {
//    
//    @EnvironmentObject var viewModel: ExercisesViewModel
//    @State var muscleGroup: Bool = false
//    
//    var body: some View {
//        VStack(spacing: 10){
//            //ДОБАВИТЬ УПРАЖНЕНИЕ
//            addButton
//            
//            HStack(spacing: 20){
//                showStrenghtButton
//                showHiitButton
//            }.padding(.bottom, 20)
//            
//            //ГРУППИРОВАТЬ ПО МЫШЦАМ ИЛИ НЕТ
//            HStack{
//                Spacer()
//                muscleGroupButton
//            }
//            
//            VStack(spacing: 0){
//                ScrollView(.vertical, showsIndicators: false) {
//                    // MARK: - ГРУППЫ МЫШЦ
//                    //1.Если групперуем по мыщцам
//                    if muscleGroup {
//                    ForEach(MuscleType.allMuscles, id:\.self){muscle in
//                        //ПОЛУЧАЕМ УПР С ЭТОЙ ГРУППОЙ МЫШЦ
//                        let exercises = viewModel.visibleExercises
//                            .filter({$0.muscle.contains(where:{$0.str == muscle.str })})
//                        
//                        if !exercises.isEmpty {
//                            VStack(spacing: 0) {
//                                HStack{
//                                    Text(muscle.str.uppercased())
//                                        .foregroundColor(.white)
//                                        .font(.title)
//                                    Spacer()
//                                }
//                                
//                                // MARK: - УПР НА ЭТУ ГРУППУ МЫШЦ
//                                ForEach(exercises, id:\.id){exercise in
//                                    Review(object: exercise, selectedObject: $viewModel.selectedExercise)
//                                }
//                            }.padding(.bottom, 30)
//                        }
//                    }
//                    //2. Если не групперуем
//                    } else {
//                        ForEach(viewModel.visibleExercises.sorted(by: {$0.name < $1.name}), id:\.id){exercise in
//                            Review(object: exercise, selectedObject: $viewModel.selectedExercise)
//                        }
//                    }
//                }
//            }
//        }
//        .padding(.top)
//        .padding(.horizontal)
//        .padding(.bottom, 40)
//    }
//    
//    private var showStrenghtButton: some View {
//        Button {
//            if viewModel.typeFilter.contains(.strenght) {
//                viewModel.typeFilter.removeAll(where: {$0 == .strenght})
//            } else {
//                viewModel.typeFilter.append(.strenght)
//            }
//        } label: {
//            Text("STRENGHT")
//                .foregroundColor(.white)
//                .padding(.vertical, 5)
//                .padding(.horizontal, 10)
//                .frame(width: 150)
//                .background(Color.blue.opacity(viewModel.typeFilter.contains(.strenght) ? 1 : 0.2))
//                .cornerRadius(5)
//        }.buttonStyle(PlainButtonStyle())
//    }
//    
//    private var showHiitButton: some View {
//        Button {
//            if viewModel.typeFilter.contains(.hiit) {
//                viewModel.typeFilter.removeAll(where: {$0 == .hiit})
//            } else {
//                viewModel.typeFilter.append(.hiit)
//            }
//        } label: {
//            Text("HIIT")
//                .foregroundColor(.white)
//                .padding(.vertical, 5)
//                .padding(.horizontal, 10)
//                .frame(width: 150)
//                .background(Color.orange.opacity(viewModel.typeFilter.contains(.hiit) ? 1 : 0.2))
//                .cornerRadius(5)
//                
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
//    
//    private var addButton: some View {
//        Button {
//            viewModel.add()
//        } label: {
//            HStack(spacing: 5){
//                Spacer()
//                Image(systemName: "plus")
//                Text("Add exercise".uppercased())
//                Spacer()
//            }
//            .font(.body)
//            .foregroundColor(.white.opacity(0.6))
//            .padding(.horizontal, 8)
//            .padding(.vertical, 5)
//            .background(Color.black.opacity(0.2))
//            .cornerRadius(5)
//        }.buttonStyle(PlainButtonStyle())
//
//    }
//    
//    private var muscleGroupButton: some View {
//        Button {
//            muscleGroup.toggle()
//        } label: {
//            HStack(spacing: 5){
//                Text("by muscle group")
//                    .font(.callout)
//                Image(systemName: muscleGroup ? "circle.fill" : "circle")
//                    .font(.callout)
//            }
//            .foregroundColor(muscleGroup ? .white : .gray)
//            .padding(5)
//            .contentShape(Rectangle())
//        }
//
//    }
//}
//
//struct ExerciseReview_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseReview()
//    }
//}
