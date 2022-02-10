//
//  JSONManager.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 28.01.2022.
//

import Foundation
import SwiftyJSON

protocol JSONManager: AnyObject {
    associatedtype Item: JSONble
    
    var items: [Item] {get}
    func generateJSON()
}

extension JSONManager {
    func generateJSON() {
        guard var url = URL.getURL(location: Item.jsonType.location, create: true) else {return}
        
        url.appendPathComponent(Item.jsonType.prefix)
        url.appendPathExtension("json")
        
        let json = JSON(["items" : items.map({$0.getForJSON()})])
        
        do {
            
            let data = try json.rawData()
            try data.write(to: url)
        } catch {
            //
        }
    }
}
