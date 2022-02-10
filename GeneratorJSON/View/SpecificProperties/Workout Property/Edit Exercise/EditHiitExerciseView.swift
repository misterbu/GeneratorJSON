//
//  IntervalExerciseSidePage.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 12.10.2021.
//

import SwiftUI
import Combine

struct EditHiitExerciseView: View {
    @Binding var exercise: IntervalExercise
    
    @State var duration = ""
    
    var body: some View {
        VStack{
            Text("Duration")
                .font(.callout)
                .foregroundColor(.white.opacity(0.5))
            
            HStack(alignment: .lastTextBaseline){
                TextField("\(exercise.duration)", text: $duration) {
                    exercise.duration = Int(duration) ?? 20
                }
                .onReceive(Just(duration)) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                        self.duration = filtered
                    }
                }
                .foregroundColor(.white)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.title2)
                
                Spacer()
                
                Text("sec")
                    .foregroundColor(.white.opacity(0.4))
                    .font(.body)
                
            }
            
            .frame(width: 80)
            .padding(.vertical, 4)
            .padding(.horizontal, 15)
            .background(Capsule()
                            .fill(Color.white.opacity(0.1)))
            
        }
    }
}


struct EditHiitExerciseView_Preview: PreviewProvider {
    static var previews: some View{
        EditHiitExerciseView(exercise: .constant(.sample))
            .preferredColorScheme(.dark)
    }
}
