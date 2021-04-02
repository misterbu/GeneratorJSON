//
//  CreateWorkoutSeriaView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 01.04.2021.
//

import SwiftUI

struct CreateWorkoutSeriaView: View {
    @EnvironmentObject var seriesVM: WorkoutSeriesViewModel
    @ObservedObject var seriaVM: WorkoutSeriaViewModel
    
    var body: some View {
        VStack{
            //Close and is Pro
            HStack{
                Button(action:{
                    seriesVM.close()
                }){
                    Image(systemName: "xmark")
                        .font(.title)
                        .foregroundColor(.black)
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, 40)
                Spacer()
                
                
                //is pro
                Text("Is Pro")
                    .font(.body)
                    .foregroundColor(.black)
                    .padding(.trailing, 10)
                
                Button(action:{
                    seriaVM.seria.isPro.toggle()
                }){
                    Image(systemName: seriaVM.seria.isPro ? "circle.fill" : "circle")
                        .font(.title)
                        .foregroundColor(.black)
                }.buttonStyle(PlainButtonStyle())
        }
            
            ScrollView(.vertical, showsIndicators: true, content: {
                VStack(spacing: 20){
                    //Images
                    HStack(spacing: 20){
                        Spacer()
                        AddImageButton(imageURL: $seriaVM.iconURL, image: $seriaVM.seria.iconImage, name: "Icon")
                        Spacer()
                        AddImageButton(imageURL: $seriaVM.imageURL, image: $seriaVM.seria.image, name: "Image")
                        Spacer()
                    }
                    
                    Group{
                    //Text
                    TextField("Name", text: $seriaVM.seria.name)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(5)
                    
                    TextField("Short Description", text: $seriaVM.seria.shortDescription)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(5)
                    
                    TextField("Description", text: $seriaVM.seria.description)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(5)
                    }
                    
                    //Types
                    HStack(alignment: .top, spacing: 30){
                       
                        MultiCaseChoseView(name: "LEVEL", selected: $seriaVM.level, multiChoose: true, array: LevelType.allCases.map({$0.str}))
                        MultiCaseChoseView(name: "Type", selected: $seriaVM.type, array: WorkType.allCases.map({$0.str}))
                        MultiCaseChoseView(name: "Sex", selected: $seriaVM.sex, array: SexType.allCases.map({$0.str}))
                        MultiCaseChoseView(name: "Target", selected: $seriaVM.target, multiChoose: true, array: TargetType.allCases.map({$0.str}))
                        MultiCaseChoseView(name: "Equipment", selected: $seriaVM.equipnemt, multiChoose: true, array: EquipmentType.allCases.map({$0.str}))
                    }
                    
                    //workouts
                    Divider()
                    Text("WORKOUTS")
                    
                    addWorkoutButton
                    
                    HStack{
                        ScrollView(.horizontal, showsIndicators: true, content: {
                            HStack(spacing: 10){
                                ForEach(0..<seriaVM.items.count, id: \.self) {index in
                                    WorkoutSeriaItemView(itemVM: seriaVM.items[index])
                                }
                            }
                        })
                    }
                    
                    Divider()
                    
                    saveButton
                }
            })
        }
        .padding()
        .sheet(isPresented: $seriaVM.showWorkoutCatalog) {
            WorkoutSeriaItemsCatalogView(seriaVM: seriaVM)
        }
    }
       
    var addWorkoutButton: some View {
        Button(action:{
            seriaVM.showCatalog()
        }){
            Image(systemName: "plus")
                .font(.title)
                .foregroundColor(.black)
        }
    }
    
    var saveButton: some View {
        Button(action:{
            //Сохраняем модель тренировки
            seriaVM.save()
        }){
            Text("SAVE")
                .font(.title)
                .foregroundColor(.black)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.black, lineWidth: 2))
        }.buttonStyle(PlainButtonStyle())
    }
}



struct WorkoutSeriaItemsCatalogView: View {
    @ObservedObject var seriaVM: WorkoutSeriaViewModel
    @EnvironmentObject var workoutsVM: WorkoutsViewModel
    
    private let row = Array(repeating: GridItem(.flexible(), spacing: 15, alignment: .center), count: 5)
    
    var body: some View {
        VStack(spacing: 20){
            
            //Close button
            Button(action:{
                seriaVM.closeCatalog()
            }){
                Image(systemName: "xmark")
                    .font(.title)
                    .foregroundColor(.black)
            }.buttonStyle(PlainButtonStyle())
            
            
            //Free wokrouts
            LazyVGrid(columns: row, alignment: .center, spacing: 10) {
                ForEach(workoutsVM.getFreeWorkouts(), id: \.id) {workoutVM in
                    ZStack{
                        Image(nsImage: workoutVM.workout.image ?? NSImage(named: "ph")!)
                            .resizable()
                            .scaledToFill()
                        
                        
                        Color.black.opacity(0.4)
                        
                        Text(workoutVM.workout.name)
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .frame(width: 150, height: 100)
                    .clipped()
                    .onTapGesture {
                        seriaVM.chooseWorkout(workoutVM)
                        seriaVM.closeCatalog()
                    }
                }
            }
        }
    }
}
