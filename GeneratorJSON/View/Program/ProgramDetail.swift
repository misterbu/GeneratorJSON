//
//  ProgramDetail.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 12.10.2021.
//

import SwiftUI

struct ProgramDetail: View {
    @Binding var program: WorkoutProgmar
    @EnvironmentObject var programsViewModel: ProgramsViewModel
    @EnvironmentObject var workoutsViewModel: WorkoutsViewModel
    
    @State var showCatalog = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20){
                HStack(spacing: 20){
                    //ID
                    Text(program.id)
                        .font(.body)
                        .foregroundColor(Color.white.opacity(0.4))
                    
                    //КНОПКА КОПИРОВАТЬ ID
                    ButtonWIthIcon(name: "COPY ID", icon: "doc.on.doc") {
                        let pasteboard = NSPasteboard.general
                        pasteboard.clearContents()
                        pasteboard.setString(program.id, forType: .string)
                    }
                    
                    Spacer()
                    
                    //IS PRO СЕКЦИЯ
                    isPro
                }
                
                //НАЗВАНИЕ
                HStack(spacing: 10){
                    MyTextField(name: "Name", text: $program.name_en)
                    MyTextField(name: "Название", text: $program.name_ru)
                }
               
                
                //ОПИСАНИЕ
                HStack(spacing: 10){
                    MyTextField(name: "Description", text: $program.description_en, multiline: true)
                    MyTextField(name: "Описание", text: $program.description_ru, multiline: true)
                }
                
                
                //КОРОТКОЕ ОПИСАНИЕ
                HStack(spacing: 10){
                    MyTextField(name: "Short description", text: $program.shortDescription_en, multiline: true)
                    MyTextField(name: "Короткое описание", text: $program.shortDescription_ru, multiline: true)
                }
               
                
                //ФОТО
                HStack(spacing: 40){
                    ImageFrame( image: $program.iconImage, name: "Icon")
                    ImageFrame( image: $program.image, name: "Image")
                    Spacer()
                }
                
                //СВОЙСТВА
                HStack(alignment: .top, spacing: 30){
                    PropertyChoser(name: "Type", select: $program.type)
                    PropertyChoser(name: "Place", select: $program.place)
                    PropertyChoser(name: "Sex", select: $program.sex)
                    MultiPropertyChoser(name: "Level", selects: $program.level)
                    MultiPropertyChoser(name: "Target", selects: $program.target)
                    MultiPropertyChoser(name: "Equipment", selects: $program.equipment)
                    
                    Spacer()
                }
                
                Divider()
                
                //ТРЕНИРОВКИ
                VStack{
                    HStack{
                        Text("Workouts:".uppercased())
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.5))
                            .padding(.vertical)
                        
                        Spacer()
                        
                        //ДОБАВЛЯЕМ ТРЕНИРОВКУ
                        ButtonWIthIcon(name: "Add workout", icon: "plus") {
                            showCatalog = true
                        }
                        .sheet(isPresented: $showCatalog) {
                            WorkoutCatalog(show: $showCatalog, programId: program.id) { newWorkout in
                                //ДОБАВЛЯЕМ ТРЕНИРОВКУ
                                program.workouts.append(newWorkout)
                                //Сохраняем
                                programsViewModel.save(program)
                            }
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20){
                            ForEach(program.workouts, id:\.id){workout in
                                WorkoutIconView(workout: workout) { deletedWorkout in
                                    //Удаляем seriaId из тренировки
                                    workoutsViewModel.deleteSeriaId(for: deletedWorkout)
                                    //Удаляем тренировку из программы тренировок
                                    program.workouts.removeAll(where: {$0.id == deletedWorkout.id})
                                    //Сохраняем
                                    programsViewModel.save(program)
                                }
                            }
                        }
                    }
                    
                }
                
                //КНОПКИ УДАЛИТЬ СОХРАНИТЬ
                Divider()
                
                HStack(spacing: 50){
                    Spacer()
                    //СОХРАНИТЬ
                    ButtonWIthIcon(name: "SAVE", icon: "opticaldiscdrive.fill", isBig: true) {
                        programsViewModel.save(program)
                    }
                    
                    //УДАЛИТь
                    ButtonWIthIcon(name: "DELETE", icon: "trash", isBig: true) {
                        //Перед удалением программы удаляем seriaId во всех тренировках
                        program.workouts.forEach({workoutsViewModel.deleteSeriaId(for: $0)})
                        //Удаляем программу
                        programsViewModel.delete(program)
                    }
                }
            }
            .padding()
        }
    }
    
    private var isPro: some View {
        Button {
            program.isPro.toggle()
        } label: {
            HStack{
                Text("IS PRO")
                Image(systemName: program.isPro ? "circle.fill" : "circle")
            }
            .foregroundColor(.white.opacity(0.6))
            .font(.body)
            .padding()
            .contentShape(RoundedRectangle(cornerRadius: 5))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
}



struct WorkoutIconView: View {
    var workout: Workout
    var onDelete:(Workout)->()
    
    var body: some View{
        VStack{
            HStack{
                Spacer()
                
                //КНОПКА УДАЛИТЬ
                IconButton(icon: "trash") {
                    onDelete(workout)
                }
            }
            
            Spacer()
            
            HStack{
                Text(workout.name.uppercased())
                    .font(.title3)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                Spacer(minLength: 30)
            }
        }
        .padding()
        .cornerRadius(10)
        .background(
            VStack{
                if let image = workout.image {
                    Image(nsImage: image)
                        .resizable()
                        .scaledToFill()
                    
                } else {
                    BlurWindow()
                }
            }
        )
        .frame(width: 250, height: 220)
        .clipped()
        
    }
}

