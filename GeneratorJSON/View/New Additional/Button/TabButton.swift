//
//  TabButton.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 01.10.2021.
//

import SwiftUI

struct TabButton: View {
    
    var type: MainPageType
    @Binding var activeTab: MainPageType
    
    init(pageType: MainPageType, activeTab: Binding<MainPageType>){
        self.type = pageType
        self._activeTab = activeTab
    }
    
    var body: some View {
        Button {
            activeTab = type
        } label: {
            VStack{
                type.image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                Text(type.name.uppercased())
                    .font(.body)
            }
            .foregroundColor(activeTab.name == type.name ? .white : .gray)
            .padding()
            .background(Color.black.opacity(activeTab.name == type.name ? 0.6 : 0))
            .contentShape(RoundedRectangle(cornerRadius: 10))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(PlainButtonStyle())

        
    }
}

struct TabButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20){
            TabButton(pageType: .exercises, activeTab: .constant(.workouts))
            TabButton(pageType: .workouts, activeTab: .constant(.workouts))
        } .preferredColorScheme(.dark)
        
    }
}
