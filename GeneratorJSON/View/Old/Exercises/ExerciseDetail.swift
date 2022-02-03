//
//  ExerciseDetail.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 01.10.2021.
//

import SwiftUI
import AppKit
//
//struct ExerciseDetail: View {
//    @Binding var exercise: BasicExercise
//    var onSave:(BasicExercise) -> ()
//    var onDelete:(BasicExercise) -> ()
//    
//    var body: some View {
//        ScrollView(.vertical, showsIndicators: false) {
//            VStack(spacing: 20){
//                //ID
//                HStack(spacing: 20){
//                    Text(exercise.id)
//                        .font(.body)
//                        .foregroundColor(Color.white.opacity(0.4))
//                    
//                    //КНОПКА КОПИРОВАТЬ ID
//                    ButtonWIthIcon(name: "COPY ID", icon: "doc.on.doc") {
//                        let pasteboard = NSPasteboard.general
//                        pasteboard.clearContents()
//                        pasteboard.setString( exercise.id, forType: .string)
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
//                    MyTextField(name: "Name", text: $exercise.name_en)
//                    MyTextField(name: "Имя", text: $exercise.name_ru)
//                }
//                
//                //ОПИСАНИЕ
//                HStack(spacing: 10){
//                    MyTextField(name: "Description", text: $exercise.description_en, multiline: true)
//                    MyTextField(name: "Описание", text: $exercise.description_ru, multiline: true)
//                }
//                
//                //КОРОТКОЕ ОПИСАНИЕ
//                HStack(spacing: 10){
//                    MyTextField(name: "Short description", text: $exercise.shortDescription_en, multiline: true)
//                    MyTextField(name: "Короткое описание", text: $exercise.shortDescription_ru, multiline: true)
//                }
//                
//                //ФОТО
//                HStack(spacing: 40){
//                    ImageFrame( image: $exercise.iconImage, name: "Icon")
//                    ImageFrame( image: $exercise.image, name: "Image")
//                    Spacer()
//                }
//                
//                //СВОЙСТВА
//                HStack(alignment: .top, spacing: 30){
//                    PropertyChoser(name: "Type", select: $exercise.type)
//                    MultiPropertyChoser(name: "Level", selects: $exercise.level)
//                    MultiPropertyChoser(name: "Muscle", selects: $exercise.muscle)
//                    MultiPropertyChoser(name: "Equipment", selects: $exercise.equipment)
//                    
//                    Spacer()
//                }
//                
//                //КОММЕНТАРИИ
//                VStack(){
//                    Divider()
//                    VoiceCommentSection(comments: $exercise.voiceComment)
//                }
//                
//                Spacer()
//                
//                //КНОПКИ УДАЛИТЬ СОХРАНИТЬ
//                Divider()
//                
//                HStack(spacing: 50){
//                    Spacer()
//                    //СОХРАНИТЬ
//                    ButtonWIthIcon(name: "SAVE", icon: "opticaldiscdrive.fill", isBig: true) {
//                        onSave(exercise)
//                    }
//                    
//                    //УДАЛИТь
//                    ButtonWIthIcon(name: "DELETE", icon: "trash", isBig: true) {
//                        onDelete(exercise)
//                    }
//                }
//            }
//            .padding()
//        }
//       
//    }
//    
//    
//    private var isPro: some View {
//        Button {
//            exercise.isPro.toggle()
//        } label: {
//            HStack{
//                Text("IS PRO")
//                Image(systemName: exercise.isPro ? "circle.fill" : "circle")
//            }
//            .foregroundColor(.white.opacity(0.6))
//            .font(.body)
//            .padding()
//            .contentShape(RoundedRectangle(cornerRadius: 5))
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
//}

//struct ExerciseDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseDetail(exercise: .constant(BasicExercise()))
//    }
//}
