//
//  WorkoutSeriasCatalogView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 02.04.2021.
//

import SwiftUI

struct WorkoutSeriasCatalogView: View {
    @EnvironmentObject var seriesVM: WorkoutSeriesViewModel
    
    private let row = Array(repeating: GridItem(.flexible(), spacing: 15, alignment: .center), count: 5)
    
    var body: some View {
        VStack{
            ScrollView{
                HStack{
                    Spacer()
                    //Create new exercise
                    createNewSeria
                    Spacer()
                    generateJSONButton
                    Spacer()
                }
                
                LazyVGrid(columns: row, content: {
                    ForEach(0..<seriesVM.series.count, id: \.self){index in
                        WorkoutSeriesCatalogItemView(seria: seriesVM.series[index].seria)
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .onTapGesture {
                                seriesVM.choseSeria(index)
                            }
                    }
                })
            }
        }
        .padding()
        .sheet(item: $seriesVM.seria) { seria in
            CreateWorkoutSeriaView(seriaVM: seria)
        }
        
    }
    
    
    var createNewSeria: some View {
        Button(action:{
            seriesVM.createNewSeria()
        }){
            HStack{
                Image(systemName: "plus.square")
                    .font(.title)
                    .foregroundColor(.black)
                
                Text(" NEW")
                    .font(.title)
                    .foregroundColor(.black)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    var generateJSONButton: some View {
        Button(action:{
            seriesVM.generateJSON()
        }){
            HStack{
                Image(systemName: "pencil.and.outline")
                    .font(.title)
                    .foregroundColor(.black)
                
                Text("GENERATE")
                    .font(.title)
                    .foregroundColor(.black)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}


struct WorkoutSeriesCatalogItemView: View {
    
    var seria: WorkoutSeria
    
    var body: some View {
        ZStack(alignment: .center) {
            Image(nsImage: seria.image ?? NSImage(named: "ph")!)
                .resizable()
                .scaledToFill()
            
            Color.black.opacity(0.4)
            
            Text(seria.name)
                .font(.title)
                .foregroundColor(.white)
        }
    }
}
