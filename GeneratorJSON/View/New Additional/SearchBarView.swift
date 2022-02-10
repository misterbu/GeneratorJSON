//
//  SearchBarView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 05.02.2022.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var search: String
    var focusedSearchField: FocusState<Bool>.Binding
    var onResetSearch: ()->()

    
    var body: some View {
        HStack(spacing: 2){
            // MARK: - SEARCH
            HStack(spacing: 5){
                Image(systemName: "magnifyingglass")
                TextField(String(localized: "Search"), text: $search)
                    .focused(focusedSearchField)
                
                //SEARCH RESET BUTTON
                if search != "" {
                    Button {
                        DispatchQueue.main.async {
                            self.onResetSearch()
                            self.focusedSearchField.wrappedValue = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .contentShape(Rectangle())
                    }
                    
                }
            }
            .font(.body)
            .foregroundColor(.white.opacity(0.5))
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.white.opacity(0.1))
            .clipShape(Capsule())
            .onTapGesture {
                DispatchQueue.main.async {
                    focusedSearchField.wrappedValue = true
                }
            }

        }
    }
}

//
//struct SearchBarPreview_Preview: PreviewProvider{
//    static var previews: some View{
//        ZStack{
//            Color.black.opacity(0.8)
//            SearchBarView(search: .constant(""))
//        }.padding()
//            .textFieldStyle(PlainTextFieldStyle())
//    }
//}
