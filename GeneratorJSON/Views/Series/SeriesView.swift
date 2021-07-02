//
//  SeriesView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 25.06.2021.
//

import SwiftUI

struct SeriesView: View {
    
    @EnvironmentObject var viewModel: MySeriesViewModel
    
    var body: some View {
        
        VStack{
            Button {
                viewModel.create()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                
            }
            .buttonStyle(PlainButtonStyle())
            .padding()
            .padding(.bottom)
            
            
            List{
                ForEach(viewModel.series, id: \.id){seria in
                    NavigationLink(destination: DetailSeriaView(viewModel: MySeriaViewModel(seria))) {
                        ReviewSeriaVeiw( seria: seria)
                    }
                }
            }
            
            Spacer()
            
            generateJSONButton
        }
    }
    
    
    var generateJSONButton: some View {
        Button {
            viewModel.generateJSON()
        } label: {
            Image(systemName: "highlighter")
                .font(.title)
                .foregroundColor(.primary)
                .contentShape(Circle())
        }.buttonStyle(PlainButtonStyle())

    }
}

struct SeriesView_Previews: PreviewProvider {
    static var previews: some View {
        SeriesView()
    }
}
