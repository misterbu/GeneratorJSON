//
//  CreateExerciseView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 24.03.2021.
//

import SwiftUI

struct CreateExerciseView: View {
    
    @ObservedObject var exerciseVM: ExerciseViewModel
    
    var body: some View {
        VStack{
            Button(action:{
                
            }){
               Image(systemName: "xmark")
                .font(.title)
                .foregroundColor(.black)
                
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack{
                        //Images
                        HStack{
                            Button(action:{
                                
                            }){
                                Image(exerciseVM.exercise.iconImage ?? NSImage(named: "ph")!)
                            }
                        }
                    }
                })
            }
        }
    }
}

struct CreateExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        CreateExerciseView()
    }
}
