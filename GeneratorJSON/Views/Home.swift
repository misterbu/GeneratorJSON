//
//  Home.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 23.03.2021.
//

import SwiftUI

struct Home: View {
    
    var widthScr = NSScreen.main?.visibleFrame.width ?? 1000
    var heightScr = NSScreen.main?.visibleFrame.height ?? 100
    
    @State var menuIndex = 0
    
    var body: some View {
        VStack{
            topMenu
            
            if menuIndex == 0 {
                WorkoutsCatalogView()
            } else if menuIndex == 1 {
                ExercisesCatalogView()
            } else {
                WorkoutSeriasCatalogView()
            }
            
            Spacer()
        }
        .frame(width: widthScr/1.5, height: heightScr - 60)
        .background(BlurWindow())
        
    }
    
    var topMenu: some View {
        HStack(spacing: 100){
            VStack(spacing: 10){
                Button(action:{
                    menuIndex = 0
                }){
                    Text("WORKOUTS")
                        .font(.largeTitle)
                        .foregroundColor(menuIndex == 0 ? Color.black : Color.gray)
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                
                if menuIndex == 0 {
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 20, height: 5, alignment: .center)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .frame(height: 80)
            
            VStack(spacing: 10){
                Button(action:{
                    menuIndex = 1
                }){
                    Text("EXERSICES")
                        .font(.largeTitle)
                        .foregroundColor(menuIndex == 1 ? Color.black : Color.gray)
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                
                if menuIndex == 1 {
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 20, height: 5, alignment: .center)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .frame(height: 80)
            
            VStack(spacing: 10){
                Button(action:{
                    menuIndex = 2
                }){
                    Text("SERIES")
                        .font(.largeTitle)
                        .foregroundColor(menuIndex == 2 ? Color.black : Color.gray)
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                
                if menuIndex == 2 {
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 20, height: 5, alignment: .center)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .frame(height: 80)
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
        .background(Color("bg"))
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
