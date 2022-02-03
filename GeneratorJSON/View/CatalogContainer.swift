

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
            if let item = manager.selectedItem {
                DetailItemView(item: .init(get: {item},
                                           set: {manager.selectedItem = $0}),
                               onSave: {_ in},
                               onDelete: {_ in })
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
