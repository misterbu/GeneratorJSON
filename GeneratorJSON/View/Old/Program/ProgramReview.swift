//
//  ProgramReview.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 12.10.2021.
//

//import SwiftUI
//
//struct ProgramReview: View {
//    
//    @EnvironmentObject var viewModel: ProgramsViewModel
//    
//    var body: some View {
//        VStack(spacing: 10){
//            //ДОБАВИТЬ ТРЕНИРОВКУ
//            addButton
//            
//            //ОТОБРАЖАТЬ ТОЛЬКО СИЛОВЫЕ ИЛИ ИНТЕРВАЛЬНЫЕ ТРЕНИРОВКИ ИЛИ И ТО И ТО
//            HStack(spacing: 20){
//                showStrenghtButton
//                showHiitButton
//            }.padding(.bottom, 20)
//            
//            VStack(spacing: 0){
//                ScrollView(.vertical, showsIndicators: false) {
//                    ForEach($viewModel.visiblePrograms, id:\.id) {program in
//                        Review(object: program, selectedObject: $viewModel.selectProgram)
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
//                Text("Add workout".uppercased())
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
//}
//
