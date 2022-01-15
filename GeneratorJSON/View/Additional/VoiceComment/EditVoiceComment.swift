//
//  EditVoiceComment.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 02.10.2021.
//

import SwiftUI

struct EditVoiceComment: View {
    
    @State var text: String = ""
    var onCommit: (String)->()
    
    init(text: String?, onCommit: @escaping (String)->()){
        self._text = .init(initialValue: text ?? "")
        self.onCommit = onCommit
    }
    
    var body: some View {
        VStack{
            closeButton
            
            Spacer()
            
            TextField("Add comment", text: $text, onCommit:  {
                onCommit(text)
            })
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(.white)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(Color.black.opacity(0.2))
                .clipShape(Capsule())
        }
        .padding(30)
        .background(BlurWindow())
        .frame(width: 400, height: 150)
    }
    
    
    private var closeButton: some View {
        Button {
            onCommit("")
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding()
                .contentShape(Circle())
        }.buttonStyle(PlainButtonStyle())

    }
}

