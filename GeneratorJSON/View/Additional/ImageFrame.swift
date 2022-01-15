//
//  ImageFrame.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 01.10.2021.
//

import SwiftUI

struct ImageFrame: View {
    
    @Binding var image: NSImage?
    var name: String?
    
    var body: some View {
        VStack{
            if let name = name {
                Text(name)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.6))
            }
            
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
                        image = NSImage(byReferencing: url)
                        
                    }
                }
            }){
                if let image = image {
                    Image(nsImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    ZStack{
                        Color.black.opacity(0.3)
                        
                        Text("ADD IMAGE")
                            .font(.largeTitle)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                }
                
            }
            .buttonStyle(PlainButtonStyle())
            .frame(width: 250, height: 190, alignment: .center)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            
        }
    }
}
