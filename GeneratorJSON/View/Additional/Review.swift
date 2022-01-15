//
//  ExerciseReview.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 01.10.2021.
//

import SwiftUI

struct Review<ReviewType: Reviewble>: View {
    var object: ReviewType
    @Binding var selectedObject: ReviewType
    
    var body: some View {
        HStack(spacing: 20){
            if let image = object.image {
                Image(nsImage: image)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(object.type == .hiit ? Color.orange : Color.blue,
                                        lineWidth: 3))
                    .padding(5)
                    
            }
            
            Text(object.name)
                .lineLimit(2)
                .font(.title)
                .foregroundColor(.primary)
                .frame(maxWidth: 250, alignment: .leading)
            
            Spacer(minLength: 30)
        }
        .contentShape(Rectangle())
        .padding(5)
        .background(Color.black.opacity(selectedObject.id == object.id ? 0.2 : 0))
        .cornerRadius(10)
        .onTapGesture {
            selectedObject = object
        }
    }
}

//struct ExerciseReview_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseReview(exercise: BasicExercise(), selectedExercise: .constant(BasicExercise()))
//    }
//}
