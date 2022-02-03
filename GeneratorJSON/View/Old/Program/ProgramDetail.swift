//
//  ProgramDetail.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 12.10.2021.
//
//
//import SwiftUI
//
//struct ProgramDetail: View {
//    @Binding var program: WorkoutProgmar
//    @EnvironmentObject var programsViewModel: ProgramsViewModel
//    @EnvironmentObject var workoutsViewModel: WorkoutsViewModel
//    
//    @State var showCatalog = false
//    @State var selectedDay: String? = nil
//    
//    var body: some View {
//        ScrollView(.vertical, showsIndicators: false) {
//            VStack(spacing: 20){
//                HStack(spacing: 20){
//                    //ID
//                    Text(program.id)
//                        .font(.body)
//                        .foregroundColor(Color.white.opacity(0.4))
//                    
//                    //КНОПКА КОПИРОВАТЬ ID
//                    ButtonWIthIcon(name: "COPY ID", icon: "doc.on.doc") {
//                        let pasteboard = NSPasteboard.general
//                        pasteboard.clearContents()
//                        pasteboard.setString(program.id, forType: .string)
//                    }
//                    
//                    Spacer()
//                    
//                    //IS PRO СЕКЦИЯ
//                    isPro
//                }
//                
//                //НАЗВАНИЕ
//                HStack(spacing: 10){
//                    MyTextField(name: "Name", text: $program.name_en)
//                    MyTextField(name: "Название", text: $program.name_ru)
//                }
//               
//                
//                //ОПИСАНИЕ
//                HStack(spacing: 10){
//                    MyTextField(name: "Description", text: $program.description_en, multiline: true)
//                    MyTextField(name: "Описание", text: $program.description_ru, multiline: true)
//                }
//                
//                
//                //КОРОТКОЕ ОПИСАНИЕ
//                HStack(spacing: 10){
//                    MyTextField(name: "Short description", text: $program.shortDescription_en, multiline: true)
//                    MyTextField(name: "Короткое описание", text: $program.shortDescription_ru, multiline: true)
//                }
//               
//                
//                //ФОТО
//                HStack(spacing: 40){
//                    ImageFrame( image: $program.iconImage, name: "Icon")
//                    ImageFrame( image: $program.image, name: "Image")
//                    Spacer()
//                }
//                
//                //СВОЙСТВА
//                HStack(alignment: .top, spacing: 30){
//                    PropertyChoser(name: "Type", select: $program.type)
//                    PropertyChoser(name: "Place", select: $program.place)
//                    PropertyChoser(name: "Sex", select: $program.sex)
//                    MultiPropertyChoser(name: "Level", selects: $program.level)
//                    MultiPropertyChoser(name: "Target", selects: $program.target)
//                    MultiPropertyChoser(name: "Equipment", selects: $program.equipment)
//                    
//                    Spacer()
//                }
//                
//                Divider()
//                
//                //ТРЕНИРОВКИ
//                VStack{
//                    HStack(spacing: 20){
//                        
//                        ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) {day in
//                            getDayView(day)
//                        }
//                        Spacer()
//                        
////                        Text("Workouts:".uppercased())
////                            .font(.title3)
////                            .foregroundColor(.white.opacity(0.5))
////                            .padding(.vertical)
////
////                        Spacer()
////
////                        //ДОБАВЛЯЕМ ТРЕНИРОВКУ
////                        ButtonWIthIcon(name: "Add workout", icon: "plus") {
////                            showCatalog = true
////                        }
////                        .sheet(isPresented: $showCatalog) {
////                            WorkoutCatalog(show: $showCatalog, programId: program.id) { newWorkout in
////                                //ДОБАВЛЯЕМ ТРЕНИРОВКУ
////                                program.workouts.append(newWorkout)
////                                //Сохраняем
////                                programsViewModel.save(program)
////                            }
////                        }
////                    }
////
////                    ScrollView(.horizontal, showsIndicators: false) {
////                        HStack(spacing: 20){
////                            ForEach(program.workouts, id:\.id){workout in
////                                WorkoutIconView(workout: workout) { deletedWorkout in
////                                    //Удаляем seriaId из тренировки
////                                    workoutsViewModel.deleteSeriaId(for: deletedWorkout)
////                                    //Удаляем тренировку из программы тренировок
////                                    program.workouts.removeAll(where: {$0.id == deletedWorkout.id})
////                                    //Сохраняем
////                                    programsViewModel.save(program)
////                                }
////                            }
////                        }
//                    }
//                    
//                }
//                .sheet(isPresented: $showCatalog) {
//                    WorkoutCatalog(show: $showCatalog, programId: program.id) { newWorkout in
//                        
//                        guard let day = selectedDay else {return}
//                        
//                        //ДОБАВЛЯЕМ ТРЕНИРОВКУ
//                        program.plan[day] = newWorkout.id
//                        self.selectedDay = nil
//                        
//                        //Сохраняем
//                        programsViewModel.save(program)
//                        
//                        withAnimation{self.showCatalog = false}
//                    }
//                }
//                
//                //КНОПКИ УДАЛИТЬ СОХРАНИТЬ
//                Divider()
//                
//                HStack(spacing: 50){
//                    Spacer()
//                    //СОХРАНИТЬ
//                    ButtonWIthIcon(name: "SAVE", icon: "opticaldiscdrive.fill", isBig: true) {
//                        programsViewModel.save(program)
//                    }
//                    
//                    //УДАЛИТь
//                    ButtonWIthIcon(name: "DELETE", icon: "trash", isBig: true) {
//                        
//                        //Удаляем программу
//                        programsViewModel.delete(program)
//                    }
//                }
//            }
//            .padding()
//        }
//    }
//        
//    @ViewBuilder
//    private func getDayView(_ day: String) -> some View {
//        VStack{
//            if let workoutID = program.plan.first(where: {$0.key == day})?.value,
//               let workout = workoutsViewModel.allWorkouts.first(where: {$0.id == workoutID}) {
//            
//                Image(nsImage: workout.image ?? NSImage(named: "ph")!)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 100, height: 100)
//                    .clipShape(Circle())
//            
//            } else {
//                Circle()
//                    .fill(Color.white.opacity(0.2))
//                    .frame(width: 100, height: 100)
//                    .overlay(Image(systemName: "plus")
//                                .font(.body)
//                                .foregroundColor(.white.opacity(0.6)))
//            }
//            
//            Text(day)
//                .foregroundColor(.white)
//                .font(.body)
//                .fontWeight(.semibold)
//                .textCase(.uppercase)
//        }
//        .contentShape(Rectangle())
//        .onTapGesture {
//            self.selectedDay = day
//            self.showCatalog = true
//        }
//    }
//    
//    private var isPro: some View {
//        Button {
//            program.isPro.toggle()
//        } label: {
//            HStack{
//                Text("IS PRO")
//                Image(systemName: program.isPro ? "circle.fill" : "circle")
//            }
//            .foregroundColor(.white.opacity(0.6))
//            .font(.body)
//            .padding()
//            .contentShape(RoundedRectangle(cornerRadius: 5))
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
//    
//}
