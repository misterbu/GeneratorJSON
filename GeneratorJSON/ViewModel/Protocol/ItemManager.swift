//
//  ItemManager.swift
//  GeneratorJSON
//
//  Created by Marat Gazizov on 27.01.2022.
//

import Foundation

protocol ItemManager: ObservableObject {
    associatedtype Item: CatalogItem & HasProperties & CoreDatable
    
    var items: [Item] { get set}
    var itemsPublished: Published<[Item]> { get }
    var itemsPublisher: Published<[Item]>.Publisher { get }
    
    var selectedItem: Item? { get set}
    var selectedItemPublished: Published<Item?> { get }
    var selectedItemPublisher: Published<Item?>.Publisher { get }
    
    init()
    
    func add()
    func save(_ item: Item)
    func delete(_ item: Item)
}

extension ItemManager {
    func add(){
        let item = Item.init()
        self.items.append(item)
        self.selectedItem = item
    }
    
    func save(_ item: Item){
        CoreDataFuncs.shared.save(entity: item.entityType, model: item)
        self.items.removeAll(where: {$0.id == item.id})
        self.items.append(item)
    }
    
    func delete(_ item: Item) {
        //1. Delete from DB and Manager
        CoreDataFuncs.shared.delete(entity: item.entityType, model: item)
        items.removeAll(where: {$0.id == item.id})
        
        //2. If it was a last item, append default item
        if items.isEmpty {
            items.append(.init())
        }
        
        //3. Choose a next item as a selected item
        selectedItem = items.first
    }
}

