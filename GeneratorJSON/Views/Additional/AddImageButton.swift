//
//  AddImageButton.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 24.03.2021.
//

import SwiftUI

struct AddImageButton: View {
    
    @Binding var imageURL: URL?
    @Binding var image: NSImage?
    var name: String?
    
    var body: some View {
        VStack{
            Button(action:{
                let openPanel = NSOpenPanel()
                openPanel.prompt = "Select image"
                openPanel.canChooseDirectories = false
                openPanel.canChooseFiles = true
                openPanel.allowedFileTypes = ["png", "jpg", "jpeg"]
                openPanel.allowsMultipleSelection = false
                openPanel.begin { (response) in
                    if response == NSApplication.ModalResponse.OK,
                       let url = openPanel.url {
                        let path = url.path
                        print(path)
                        imageURL = url
                        
                    }
                }
            }){
                if let image = image {
                    Image(nsImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image("ph")
                        .resizable()
                        .scaledToFill()
                }
                
            }
            .buttonStyle(PlainButtonStyle())
            .frame(width: 250, height: 190, alignment: .center)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            if let name = name {
                Text(name)
                    .font(.body)
                    .foregroundColor(.black)
            }
        }
    }
}
