//
//  WorkoutView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 04.03.2021.
//

import SwiftUI

struct WorkoutsView: View {
    
    @ObservedObject var workouts: WorkoutViewModel1
    @ObservedObject var exercises: ExercisesViewModel1
    @State var showWorkout: Bool = false
    @State var workout: Workout1?
    
    var body: some View {
        ZStack{
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20){
                    ForEach(0..<workouts.models.count, id: \.self){index in
                        WorkoutPreView(workout: workouts.models[index])
                            .onTapGesture {
                                workout = workouts.models[index]
                                showWorkout = true
                            }
                    }
                    
                    Spacer()
                    createNew
                    Spacer()
                }
            }
            
            if showWorkout, let workout = workout {
                WorkoutView(workouts: workouts, exercises: exercises, workout: workout, close: $showWorkout)
                    .background(Color.gray)
            }
        }
    }
    
    var createNew: some View {
        Button {
            workout = Workout1()
            showWorkout = true
        } label: {
            Text("Create new")
        }

    }
}


struct WorkoutPreView: View {
    
    var workout: Workout1

    var body: some View {
        HStack(spacing: 10){
            if let image = workout.image{
                Image(nsImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
            }
            Text(workout.name)
                .font(.title)
        }
    }
}



struct WorkoutView: View {
    
    @ObservedObject var workouts: WorkoutViewModel1
    @ObservedObject var exercises: ExercisesViewModel1
    @ObservedObject var workout: Workout1
    @Binding var close: Bool
    @State var tagsStr: String = ""
    @State var showType: Bool = false
    @State var showLevel: Bool = false
    @State var makeImageChange: Bool = false
    @State var showReleated: Bool = false
    @State var showExercise: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 30){
                //Close button
                Button(action:{
                    workouts.saveModels()
                    if makeImageChange{
                        workout.saveImage()
                        workout.saveIcon()
                    }
                    close.toggle()
                }){
                    Image(systemName: "xmark")
                }
                
                
                if let image = workout.image {
                    Image(nsImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipped()
                } else {
                    addImageButton
                }
                
                Group{
                    
                    TextField("Title", text: $workout.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Description", text: $workout.description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Tags", text: $tagsStr) { changed in
                        if !changed {
                            workout.addTag(tagsStr)
                            tagsStr = ""
                        }
                    }
                }
                
                if workout.tags.count > 0 {
                    HStack{
                        tags
                    }
                }
                Group{
                    chooseTypeButton
                        .sheet(isPresented: $showType) {
                            ChooseView(items: WorkoutType.allCases, close: $showType, selected: $workout.selectedType)
                        }
                    
                    chooseLevelButton
                        .sheet(isPresented: $showLevel) {
                            ChooseView(items: WorkoutLevel.allCases, close: $showLevel, selected: $workout.selectedLevel)
                        }
                }
                
                
                releatedWorkouts
                    .sheet(isPresented: $showReleated) {
                        ReleatedWorkoutsView(current: workout.id, workouts: workouts, close: $showReleated)
                    }
                
                exercisesSection
                    .sheet(isPresented: $showExercise) {
                        ChoseExerciseView(workout: workout, close: $showExercise, exercises: exercises.models)
                    }
                
                proSection
                        
                if workout.name != "" {
                    Button(action:{
                        workouts.addNewModel(new: workout)
                        if makeImageChange {
                            workout.saveImage()
                            workout.saveIcon()
                        }
                        close.toggle()
                    }){
                        Text("Add Workout")
                    }
                }
            }
             
        }
    }
    
    var addImageButton: some View {
        Button(action:{
            let openPanel = NSOpenPanel()
            openPanel.prompt = "Select image"
            openPanel.canChooseDirectories = false
            openPanel.canChooseFiles = true
            openPanel.allowedFileTypes = ["png", "jpg", "jpeg"]
            openPanel.allowsMultipleSelection = false
            openPanel.begin { (response) in
                if response == NSApplication.ModalResponse.OK,
                   let url = openPanel.url {
                    let path = url.path
                    print(path)
                    workout.addImage(url: url)
                }
            }
            self.makeImageChange = true
        }){
            Image(systemName: "photo.on.rectangle")
                .font(.largeTitle)
        }
    }
    
    
    var tags: some View {
        ForEach(0..<workout.tags.count, id: \.self){index in
            Button {
                workout.deleteTag(index)
            } label: {
                HStack(spacing: 2){
                    Text(workout.tags[index])
                        .font(.callout)
                    Image(systemName: "xmark")
                }
            }
            
        }
    }
    
    var chooseTypeButton: some View {
        Button(action:{
            showType = true
        }){
            Text(workout.type.str)
                .font(.title)
        }
    }
    
    var chooseLevelButton: some View {
        Button(action:{
            showLevel = true
        }){
            Text(workout.level.str)
                .font(.title)
        }
    }
    
    var releatedWorkouts: some View{
        VStack(spacing: 20){
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30){
                    ForEach(workout.releatedWorkouts, id: \.self){id in
                        if let releatedWorkout = workouts.models.first(where: {$0.id == id}) {
                            WorkoutPreView(workout: releatedWorkout)
                        }
                    }
                }
            }
            
            Button(action:{
                showReleated.toggle()
            }){
                Text("CHANGE RELEATED")
                    .font(.title)
            }
        }
    }
    
    var exercisesSection: some View {
        VStack(spacing: 20){
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30){
                    ForEach(workout.exersises, id: \.self){id in
                        if let exersise = exercises.models.first(where: {$0.id == id}) {
                            ExercisePreView2(exercise: exersise)
                        }
                    }
                }
            }
            
            Button(action:{
                showExercise.toggle()
            }){
                Text("CHANGE RELEATED")
                    .font(.title)
            }
        }
    }
    
    var proSection: some View{
        Button(action:{
            workout.isPro.toggle()
        }){
            Image(systemName: workout.isPro ? "checkmark.circle" : "circle")
                .font(.largeTitle)
        }
    }
}




struct ReleatedWorkoutsView: View {
    
    @ObservedObject var workouts: WorkoutViewModel1
    @Binding var close: Bool
    @State var releatedId: [String] = []

    init(current id: String, workouts: WorkoutViewModel1, close: Binding<Bool>) {
        self.workouts = workouts
        self._close = close
        self.releatedId.append(id)
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack{
                closeButton
                Spacer()
                ForEach(0..<workouts.models.count, id: \.self){index in
                    ZStack{
                        WorkoutPreView(workout: workouts.models[index])
                        
                        if releatedId.contains(workouts.models[index].id){
                            Color.red.opacity(0.4)
                            Image(systemName: "plus")
                                .font(.largeTitle)
                                .foregroundColor(Color.white.opacity(0.4))
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if !releatedId.contains(workouts.models[index].id) {
                            releatedId.append(workouts.models[index].id)
                        } else {
                            releatedId.removeAll(where: {$0 == workouts.models[index].id})
                        }
                    }
                }
                Spacer()
            }
        }
    }
    
    var closeButton: some View {
        Button(action:{
            //Add releatedIDs all workouts
            workouts.changeReleated(ids: releatedId)
            close.toggle()
        }){
           Image(systemName: "xmark")
            .font(.largeTitle)
        }
    }
}


struct ExercisePreView2: View {
    var exercise: Exercise1
    
    var body: some View{
        VStack{
            if let image = exercise.photo {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipped()
            }
            
            Text(exercise.title)
                .font(.largeTitle)
        }
    }
}

struct ChoseExerciseView: View {
    @ObservedObject var workout: Workout1
    @Binding var close: Bool
    var exercises: [Exercise1]
    
    var body: some View{
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 20){
                
                Button(action:{
                    close.toggle()
                }){
                    Image(systemName: "xmark")
                        .font(.largeTitle)
                }
                
                ForEach(exercises, id: \.id){exercise in
                    ZStack{
                        ExercisePreView2(exercise: exercise)
                        
                        if workout.exersises.contains(exercise.id) {
                            Color.red.opacity(0.3)
                            Text("ADDED")
                                .font(.largeTitle)
                                .foregroundColor(Color.white.opacity(0.5))
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if workout.exersises.contains(exercise.id){
                            workout.exersises.removeAll(where: {$0 == exercise.id})
                        } else {
                            workout.exersises.append(exercise.id)
                        }
                    }
                }
            }
        }
    }
}
