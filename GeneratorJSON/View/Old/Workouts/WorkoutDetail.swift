//
//  WorkoutDetail.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 02.10.2021.
//

import SwiftUI

struct WorkoutDetail: View {
    
    @Binding var workout: Workout
    @EnvironmentObject var workoutsViewModel: WorkoutsViewModel
    
    @State var exercise: Exercise? = nil
    @State var circleId: String? = nil
    
    var body: some View {
        HStack{
            //ОПИСАНИЕ ТРЕНИРОВКИ
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20){
                    HStack(spacing: 20){
                        //ID
                        Text(workout.id)
                            .font(.body)
                            .foregroundColor(Color.white.opacity(0.4))
                        
                        //КНОПКА КОПИРОВАТЬ ID
                        ButtonWIthIcon(name: "COPY ID", icon: "doc.on.doc") {
                            let pasteboard = NSPasteboard.general
                            pasteboard.clearContents()
                            pasteboard.setString(workout.id, forType: .string)
                        }
                        
                        Spacer()
                        
                        //IS PRO СЕКЦИЯ
                        isPro
                    }
                    
                    //НАЗВАНИЕ
                    HStack(spacing: 10){
                        MyTextField(name: "Name", text: $workout.name_en)
                        MyTextField(name: "Имя", text: $workout.name_ru)
                    }
                    
                    //ОПИСАНИЕ
                    HStack(spacing: 10){
                        MyTextField(name: "Description", text: $workout.description_en, multiline: true)
                        MyTextField(name: "Описание", text: $workout.description_ru, multiline: true)
                    }
                    //КОРОТКОЕ ОПИСАНИЕ
                    HStack(spacing: 10){
                        MyTextField(name: "Short description", text: $workout.shortDescription_en, multiline: true)
                        MyTextField(name: "Короткое описание", text: $workout.shortDescription_ru, multiline: true)
                    }
                    
                    //PROGRAM ID
                    if let seriaId = workout.seriaId{
                        HStack{
                            Text(seriaId)
                                .foregroundColor(.white.opacity(0.6))
                                .font(.title2)
                            Spacer()
                        }
                    }
                    
                    //ФОТО
                    HStack(spacing: 40){
                        ImageFrame( image: $workout.iconImage, name: "Icon")
                        ImageFrame( image: $workout.image, name: "Image")
                        Spacer()
                    }
                    
                    //СВОЙСТВА
                    HStack(alignment: .top, spacing: 30){
                        PropertyChoser(name: "Type", select: $workout.type)
                        PropertyChoser(name: "Place", select: $workout.place)
                        PropertyChoser(name: "Sex", select: $workout.sex)
                        MultiPropertyChoser(name: "Muscle", selects: $workout.muscle)
                        MultiPropertyChoser(name: "Level", selects: $workout.level)
                        MultiPropertyChoser(name: "Target", selects: $workout.target)
                        MultiPropertyChoser(name: "Equipment", selects: $workout.equipment)
                        
                        Spacer()
                    }
                    
                    //ПЛАН УПРАЖНЕНИЙ
                    VStack(alignment: .leading){
                        Divider()
                        
                        HStack{
                            Text("EXERCISE PLAN:")
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.5))
                                .padding(.vertical)
                            Spacer()
                            
                            //ДОБАВЛЯЕМ НОВЫЙ ЦИКЛ
                            ButtonWIthIcon(name: "Add circle", icon: "plus", isBig: false,
                                           onTap: {
                                workout.workoutCircles.append(WorkoutCircle(order: workout.workoutCircles.count))
                            })
                        }
                        
                        //ЦИКЛЫ
                        HStack(spacing: 30){
                            ForEach(workout.workoutCircles.indices ,id: \.self){index in
                                Safe($workout.workoutCircles, index: index) { binding in
                                    WorkoutCircleView(workoutCircle: binding) { circle in
                                        //УДАЛЯЕМ ЦИКЛ
                                        workout.workoutCircles.removeAll(where: {$0.id == circle.id})
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                    }
                    
                    //КНОПКИ УДАЛИТЬ СОХРАНИТЬ
                    Divider()
                    
                    HStack(spacing: 50){
                        Spacer()
                        //СОХРАНИТЬ
                        ButtonWIthIcon(name: "SAVE", icon: "opticaldiscdrive.fill", isBig: true) {
                            workoutsViewModel.save(workout)
                        }
                        
                        //УДАЛИТь
                        ButtonWIthIcon(name: "DELETE", icon: "trash", isBig: true) {
                            workoutsViewModel.delete(workout)
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    private var isPro: some View {
        Button {
            workout.isPro.toggle()
        } label: {
            HStack{
                Text("IS PRO")
                Image(systemName: workout.isPro ? "circle.fill" : "circle")
            }
            .foregroundColor(.white.opacity(0.6))
            .font(.body)
            .padding()
            .contentShape(RoundedRectangle(cornerRadius: 5))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

//struct WorkoutDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkoutDetail(workout: .constant(Workout()))
//    }
//}
