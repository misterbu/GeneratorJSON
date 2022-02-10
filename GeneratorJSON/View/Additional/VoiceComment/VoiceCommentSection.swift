//
//  VoiceCommentSection.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 01.10.2021.
//

import SwiftUI

struct VoiceCommentSection: View {
    
    @Binding var comments: [String]
    
    @State var show: Bool = false
    @State var changeComment: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Text("Voice comments:")
            
            if comments.count > 0 {
                ForEach(comments, id:\.self){comment in
                    
                    HStack(spacing: 10) {
                        HStack{
                            Text(comment)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(5)
                        .contentShape(RoundedRectangle(cornerRadius: 5))
                        .onTapGesture {
                            changeComment = comment
                            show = true
                        }
                        
                        
                        deleteCommentButton(comment)
                    }
                }
            }
            
            //КНОПКА ДОБАВИТЬ КОММЕНТ
            ButtonWithIcon(name: "Add comment", icon: "plus", onTap: {
                show.toggle()
            })
            
                .padding(.vertical)
        }.sheet(isPresented: $show) {
            EditVoiceComment(text: changeComment, onCommit: { comment in
                show.toggle()
                
                //ДОБАВЛЕНИЕ НОВОГО КОММЕНТА
                if changeComment == nil, comment != "" {
                    comments.append(comment)
                //ИЗМЕНЕНИЕ ТЕКУЩЕГО КОММЕНТА
                } else if changeComment != nil,
                          comment != "",
                          let index = comments.firstIndex(where: {$0 == changeComment}) {
                    comments.remove(at: index)
                    comments.insert(comment, at: index)
                }
                
                changeComment = nil
            })
        }
    }
    
    private func deleteCommentButton(_ comment: String) -> some View {
        Button {
            DispatchQueue.main.async {
                if comments.count > 1 {
                    comments.removeAll(where: {$0 == comment})
                } else {
                    comments = [""]
                }
            }
            
        } label: {
            Image(systemName: "minus.circle")
                .font(.title2)
                .foregroundColor(.white)
        }.buttonStyle(PlainButtonStyle())

    }
    
}

//struct VoiceCommentSection_Previews: PreviewProvider {
//    static var previews: some View {
//        VoiceCommentSection()
//    }
//}
