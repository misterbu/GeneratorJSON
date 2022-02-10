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
    var isLockedMainContent: Bool {
        additionalView != nil
    }
    
    init(item: Binding<Item>, onSave: @escaping (Item)->(), onDelete: @escaping (Item)->()){
        self._item = item
        self.onSave = onSave
        self.onDelete = onDelete
    }
    
    var body: some View {
        
        HStack(spacing: 20){
            //Main content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 40){
                    HStack(spacing: 20){
                        //ID
                        Text(item.id)
                            .font(.body)
                            .foregroundColor(Color.white.opacity(0.4))
                        
                        //КНОПКА КОПИРОВАТЬ ID
                        ButtonWithIcon(name: "COPY ID", icon: "doc.on.doc") {
                            let pasteboard = NSPasteboard.general
                            pasteboard.clearContents()
                            pasteboard.setString(item.id, forType: .string)
                        }
                        
                        Spacer()
                        
                        //IS PRO СЕКЦИЯ
                        isPro
                    }
                    
                    VStack(spacing: 15){
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
                    
                    
                    VStack(spacing: 15) {
                        Divider()
                        
                        //КНОПКИ УДАЛИТЬ СОХРАНИТЬ
                        HStack(spacing: 50){
                            //СОХРАНИТЬ
                            ButtonWithIcon(name: "SAVE", icon: "opticaldiscdrive.fill", type: .big) {
                                onSave(item)
                            }
                            
                            //УДАЛИТь
                            ButtonWithIcon(name: "DELETE", icon: "trash", type: .big) {
                                onDelete(item)
                            }
                            
                            Spacer()
                            
                        }
                    }
                }
                .padding(.vertical)
            }
            //Disable main content when show additional
            .blur(radius: isLockedMainContent ? 4 : 0)
            .opacity(isLockedMainContent ? 0.6 : 1)
            .disabled(isLockedMainContent)
            .onTapGesture {
                guard isLockedMainContent else {return}
                withAnimation{additionalView = nil}
            }
            
            //Additional view (appear from right side)
            if let additionalView = additionalView {
                additionalView
                    .padding()
                    .frame(width: 500)
                    .background(.black.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.bottom)
                    .transition(.move(edge: .trailing))
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
            if  (item as? WorkoutProgmar) != nil {
                WorkoutProgramPropertyView(program: .init(get: {item as! WorkoutProgmar},
                                                          set: {item = $0 as! Item }),
                                           workoutsCatalogView: $additionalView)
            //For Workouts
            } else if  (item as? Workout) != nil {
                WorkoutPropertyView(workout: .init(get: {item as! Workout},
                                                   set: {item = $0 as! Item}),
                                    exercisesCatalogView: $additionalView)
            }
        }
    }
}

