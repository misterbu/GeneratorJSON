//
//  DetailItemView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 26.01.2022.
//

import SwiftUI

struct DetailItemView<Item: CatalogDetail & HasProperties>: View {
    @Binding var item: Item
    var onSave: (Item)->()
    var onDelete: (Item)->()
    
    @State var additionalView: AnyView? = nil
    
    init(item: Binding<Item>, onSave: @escaping (Item)->(), onDelete: @escaping (Item)->()){
        self._item = item
        self.onSave = onSave
        self.onDelete = onDelete
    }
    
    var body: some View {
        
        HStack(spacing: 20){
            //Main content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20){
                    HStack(spacing: 20){
                        //ID
                        Text(item.id)
                            .font(.body)
                            .foregroundColor(Color.white.opacity(0.4))
                        
                        //КНОПКА КОПИРОВАТЬ ID
                        ButtonWIthIcon(name: "COPY ID", icon: "doc.on.doc") {
                            let pasteboard = NSPasteboard.general
                            pasteboard.clearContents()
                            pasteboard.setString(item.id, forType: .string)
                        }
                        
                        Spacer()
                        
                        //IS PRO СЕКЦИЯ
                        isPro
                    }
                    
                    //НАЗВАНИЕ
                    HStack(spacing: 10){
                        MyTextField(name: "Name", text: $item.name_en)
                        MyTextField(name: "Имя", text: $item.name_ru)
                        
                    }
                    
                    //ОПИСАНИЕ
                    HStack(spacing: 10){
                        MyTextField(name: "Description", text: $item.description_en, multiline: true)
                        MyTextField(name: "Описание", text: $item.description_ru, multiline: true)                    }
                    //КОРОТКОЕ ОПИСАНИЕ
                    HStack(spacing: 10){
                        MyTextField(name: "Short description", text: $item.shortDescription_en, multiline: true)
                        MyTextField(name: "Короткое описание", text: $item.shortDescription_ru, multiline: true)
                        
                    }
                    
                    //ФОТО
                    HStack(spacing: 40){
                        ImageFrame( image: $item.iconImage, name: "Icon")
                        ImageFrame( image: $item.image, name: "Image")
                        Spacer()
                    }
                    
                    //СВОЙСТВА
                    ProperiesView(item: $item)
                    
                    //ОПРЕДЕЛЕННОЕ СВОЙСТВО В ЗАВИСИМОСТИ ОТ ТИПА ОБЬЕКТА
                    specificProperties
                        .padding(.vertical, 20)
                    
                    
                    Divider()
                    
                    //КНОПКИ УДАЛИТЬ СОХРАНИТЬ
                    if additionalView == nil {
                        HStack(spacing: 50){
                            Spacer()
                            //СОХРАНИТЬ
                            ButtonWIthIcon(name: "SAVE", icon: "opticaldiscdrive.fill", isBig: true) {
                                onSave(item)
                            }
                            
                            //УДАЛИТь
                            ButtonWIthIcon(name: "DELETE", icon: "trash", isBig: true) {
                                onDelete(item)
                            }
                        }
                    }
                }
            }
            
            //Additional view (appear from right side)
            if let additionalView = additionalView {
                additionalView
                    .padding()
                    .background(Color.black.opacity(0.15))
                    .cornerRadius(15)
                    .frame(width: 500)
                    .transition(.move(edge: .trailing))
                    .padding(.bottom)
            }
        }
        .padding(.horizontal)
        //When a selected item was changed
        .onChange(of: item.id) { _ in
            //Close additional view
            withAnimation{
                self.additionalView = nil
            }
        }
    }
    
    
    private var isPro: some View {
        Button {
            withAnimation{item.isPro.toggle()}
        } label: {
            HStack{
                Text("IS PRO")
                Image(systemName: item.isPro ? "circle.fill" : "circle")
            }
            .foregroundColor(.white.opacity(0.6))
            .font(.body)
            .padding()
            .contentShape(RoundedRectangle(cornerRadius: 5))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    
    private var specificProperties: some View {
        VStack{
            //For Workout Programs
            if let workoutProgram = item as? WorkoutProgmar {
                WorkoutProgramPropertyView(program: .init(get: {workoutProgram},
                                                          set: {item = $0 as! Item }),
                                           workoutsCatalogView: $additionalView)
            //For Workouts
            } else if let workout = item as? Workout {
                WorkoutPropertyView(workout: .init(get: {workout},
                                                   set: {item = $0 as! Item}),
                                    exercisesCatalogView: $additionalView)
            }
        }
    }
}

