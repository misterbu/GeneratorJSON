//
//  ProgramsView.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 12.10.2021.
//

import SwiftUI

struct ProgramsView: View {
    @EnvironmentObject var viewModel: ProgramsViewModel
    
    var body: some View {
        HStack{
            ProgramReview()
                .frame(width: 350)
                .background(BlurWindow())
            
            ProgramDetail(program: $viewModel.selectProgram)
        }
    }
}

struct ProgramsView_Previews: PreviewProvider {
    static var previews: some View {
        ProgramsView()
    }
}
