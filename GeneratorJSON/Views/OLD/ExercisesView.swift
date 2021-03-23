//
//  ExercisesView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 04.03.2021.
//

import SwiftUI


struct ExercisesView: View {
    
    @ObservedObject var exercises: ExercisesViewModel1
    @State var showExercise: Bool = false
    
    var body: some View {
        ZStack{
            ScrollView(.vertical, showsIndicators: true, content: {
                VStack(spacing: 15){
                    ForEach(0..<exercises.models.count, id: \.self) {index in
                        ExercisePreView(exersice: $exercises.models[index])
                            .onTapGesture {
                                exercises.exercise = exercises.models[index]
                                showExercise = true
                            }
                    }
                    Spacer()
                    createNew
                    Spacer()
                }
                .background(Color.red.opacity(0.3))
            })
            
            if showExercise {
                ExerciseView(exercise: exercises.exercise, exercises: exercises, show: $showExercise)
                    .background(Color.gray)
            }
        }
    }
    
    var createNew: some View {
        Button {
            exercises.exercise = Exercise1()
            showExercise = true
        } label: {
            Text("Create new")
        }

    }
}

//struct ExercisesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExercisesView()
//    }
//}
//
//
//
//
struct ExercisePreView: View {

    @Binding var exersice: Exercise1

    var body: some View {
        HStack{
            if let photo = exersice.photo {
                Image(nsImage: photo)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80, alignment: .center)
                    .clipped()
            } else {
                Color.blue
                    .frame(width: 80, height: 80, alignment: .center)
            }

            Text(exersice.title)
        }
    }
}



struct ExerciseView: View {
    
    @ObservedObject var exercise: Exercise1
    @ObservedObject var exercises: ExercisesViewModel1
    @Binding var show: Bool
    @State var tagsStr: String = ""
    
    @State var makeImageChange: Bool = false
    
    var body: some View {
        VStack(spacing: 15){
        
            Button(action:{
                exercises.saveExercise()
                if makeImageChange {
                    exercise.saveImage()
                    exercise.saveIcon()
                }
                show.toggle()
            }){
                Image(systemName: "xmark")
                    .font(.title)
            }

            
            Spacer()

            if let photo = exercise.photo {
                Image(nsImage: photo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
            } else {
                addImageButton
            }
            
            Group{
                TextField("Title", text: $exercise.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Description", text: $exercise.description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Duration", text: $exercise.durationStr)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Tags", text: $tagsStr) { changed in
                    if !changed {
                        exercise.addTag(tagsStr)
                        tagsStr = ""
                    }
                }
            }
            
            if exercise.tags.count > 0 {
                HStack{
                   tags
                }
            }

            TextField("Voice comment", text: $exercise.voiceComment)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if exercise.title != "" {
                Button(action:{
                    exercises.addNewModel(new: exercise)
                    if makeImageChange {
                        exercise.saveImage()
                        exercise.saveIcon()
                    }
                    show.toggle()
                }){
                    Text("Add Exersises")
                }
            }
            
            Spacer()
        }
    }
    
    
    var tags: some View {
        ForEach(0..<exercise.tags.count, id: \.self){index in
            Button {
                exercise.deleteTag(index)
            } label: {
                HStack(spacing: 2){
                    Text(exercise.tags[index])
                        .font(.callout)
                    Image(systemName: "xmark")
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
                    exercise.addImage(url: url)
                }
            }
            self.makeImageChange = true
        }){
            Image(systemName: "photo.on.rectangle")
                .font(.largeTitle)
        }
    }
}
