//
//  MyTextField.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 01.10.2021.
//

import SwiftUI

struct MyTextField: View {
    var name: String?
    @Binding var text: String
    var multiline: Bool = false
    
    var body: some View {
        VStack(alignment: .leading){
            if let name = name {
                Text(name)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            
            if !multiline {
                TextField(name ?? "", text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(Color.black.opacity(0.2))
                    .clipShape(Capsule())
            } else {
                TextEditor(text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .frame(height: 60)
                    .background(Color.black.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}

struct MyTextField_Previews: PreviewProvider {
    static var previews: some View {
        MyTextField(name: "Text", text: .constant("jdflsjf ldskj"))
            .preferredColorScheme(.dark)
    }
}
