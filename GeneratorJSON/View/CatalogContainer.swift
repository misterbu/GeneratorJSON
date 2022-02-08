

import SwiftUI

struct CatalogContainer<Manager: ItemManager>: View {
    
    @ObservedObject var manager: Manager
    
 
    init(manager: Manager){
        self.manager = manager
    }
    
    var body: some View {
        HStack{
            //CatalogView
            CatalogView(items: manager.items,
                        selectedItem: $manager.selectedItem,
                        onAdd: {manager.add()})
                .background(BlurWindow().edgesIgnoringSafeArea(.all))
                .frame(width: 350)
                .frame(maxHeight: .infinity)
               
            
            //DetailViewOfCatalogItem
            if manager.selectedItem != nil  {
                DetailItemView(item: .init(get: {manager.selectedItem!},
                                           set: {manager.selectedItem = $0}),
                               onSave: {manager.save($0)},
                               onDelete: {manager.delete($0)})
            } else {
                //Отображаем страницу предлагающую создать первый элемент
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct CatalogContainer_Preview: PreviewProvider{
    static var previews: some View {
        CatalogContainer(manager: WorkoutsManager())
            .preferredColorScheme(.dark)
    }
}
