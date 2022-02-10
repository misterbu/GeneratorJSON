

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
                               onSave: { manager.save($0)},
                               onDelete: {manager.delete($0)})
            } else {
                emptyView
            }
        }.edgesIgnoringSafeArea(.all)
    }
    
    private var emptyView: some View {
        VStack(spacing: 40){
            Text("Create first item".uppercased())
                .font(.largeTitle)
                .foregroundColor(.white.opacity(0.4))
                .multilineTextAlignment(.center)
            
            ButtonWithIcon(name: "create",
                           icon: "plus",
                           type: .big) {
                withAnimation{
                    manager.add()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}

struct CatalogContainer_Preview: PreviewProvider{
    static var previews: some View {
        CatalogContainer(manager: WorkoutsManager())
            .preferredColorScheme(.dark)
    }
}
